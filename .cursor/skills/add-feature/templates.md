# Templates — Add Feature

Copy and adapt these stubs. Replace `Feature` / `feature` with the actual name.

---

## Entity

```dart
// lib/feature/domain/entities/feature_entity.dart
import 'package:equatable/equatable.dart';

class FeatureEntity extends Equatable {
  const FeatureEntity({
    required this.id,
    required this.value,
  });

  factory FeatureEntity.initial() => const FeatureEntity(id: '', value: '');

  factory FeatureEntity.fromJson(Map<String, dynamic> json) {
    return FeatureEntity(
      id: json['id'] as String,
      value: json['value'] as String,
    );
  }

  final String id;
  final String value;

  Map<String, dynamic> toJson() => {'id': id, 'value': value};

  FeatureEntity copyWith({String? id, String? value}) => FeatureEntity(
        id: id ?? this.id,
        value: value ?? this.value,
      );

  @override
  List<Object?> get props => [id, value];
}
```

---

## UseCase

```dart
// lib/feature/domain/usecases/get_feature_usecase.dart
class GetFeatureUseCase {
  const GetFeatureUseCase(this.repository);

  final FeatureRepository repository;

  Future<FeatureEntity> call(GetFeatureParams params) =>
      repository.getFeature(params);
}

class GetFeatureParams {
  const GetFeatureParams({required this.id});

  final String id;
}
```

```dart
// lib/feature/domain/usecases/save_feature_usecase.dart
class SaveFeatureUseCase {
  const SaveFeatureUseCase(this.repository);

  final FeatureRepository repository;

  Future<void> call(SaveFeatureParams params) =>
      repository.saveFeature(params);
}

class SaveFeatureParams {
  const SaveFeatureParams({required this.entity});

  final FeatureEntity entity;
}
```

---

## Repository Interface

```dart
// lib/feature/domain/repositories/feature_repository.dart
abstract interface class FeatureRepository {
  Future<FeatureEntity> getFeature(GetFeatureParams params);
  Future<void> saveFeature(SaveFeatureParams params);
}
```

---

## Data Layer

### Local data source interface

```dart
// lib/feature/data/data_sources/local/feature_local_data_source.dart
abstract interface class FeatureLocalDataSource {
  Future<FeatureEntity> getFeature(String id);
  Future<void> saveFeature(FeatureEntity entity);
}
```

### Local data source implementation (SharedPreferences example)

```dart
// lib/feature/data/data_sources/local/feature_local_data_source_impl.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class FeatureLocalDataSourceImpl implements FeatureLocalDataSource {
  const FeatureLocalDataSourceImpl(this._prefs);

  final SharedPreferences _prefs;

  static const _key = 'feature_data';

  @override
  Future<FeatureEntity> getFeature(String id) async {
    final raw = _prefs.getString(_key);
    if (raw == null) return FeatureEntity.initial();
    return FeatureEntity.fromJson(
      jsonDecode(raw) as Map<String, dynamic>,
    );
  }

  @override
  Future<void> saveFeature(FeatureEntity entity) async {
    await _prefs.setString(_key, jsonEncode(entity.toJson()));
  }
}
```

### Remote data source interface

```dart
// lib/feature/data/data_sources/remote/feature_remote_data_source.dart
abstract interface class FeatureRemoteDataSource {
  Future<FeatureEntity> getFeature(String id);
}
```

### Remote data source implementation (Firestore example)

```dart
// lib/feature/data/data_sources/remote/feature_remote_data_source_impl.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class FeatureRemoteDataSourceImpl implements FeatureRemoteDataSource {
  const FeatureRemoteDataSourceImpl({required this.firestore});

  final FirebaseFirestore firestore;

  @override
  Future<FeatureEntity> getFeature(String id) async {
    final doc = await firestore.collection('features').doc(id).get();
    return FeatureEntity.fromJson(doc.data()!..['id'] = id);
  }
}
```

### Repository implementation

```dart
// lib/feature/data/repositories/feature_repository_impl.dart
class FeatureRepositoryImpl implements FeatureRepository {
  const FeatureRepositoryImpl({
    required this.localDataSource,
    // required this.remoteDataSource,  // add if remote exists
  });

  final FeatureLocalDataSource localDataSource;

  @override
  Future<FeatureEntity> getFeature(GetFeatureParams params) =>
      localDataSource.getFeature(params.id);

  @override
  Future<void> saveFeature(SaveFeatureParams params) =>
      localDataSource.saveFeature(params.entity);
}
```

---

## BLoC

### Events

```dart
// lib/feature/presentation/bloc/feature_event.dart
import 'package:equatable/equatable.dart';

sealed class FeatureEvent extends Equatable {
  const FeatureEvent();
}

class LoadFeature extends FeatureEvent {
  const LoadFeature({required this.id});

  final String id;

  @override
  List<Object?> get props => [id];
}

class SaveFeature extends FeatureEvent {
  const SaveFeature({required this.entity});

  final FeatureEntity entity;

  @override
  List<Object?> get props => [entity];
}
```

### States

```dart
// lib/feature/presentation/bloc/feature_state.dart
import 'package:equatable/equatable.dart';

sealed class FeatureState extends Equatable {
  const FeatureState();
}

class FeatureInitial extends FeatureState {
  const FeatureInitial();

  @override
  List<Object?> get props => [];
}

class FeatureLoading extends FeatureState {
  const FeatureLoading();

  @override
  List<Object?> get props => [];
}

class FeatureLoaded extends FeatureState {
  const FeatureLoaded({required this.entity});

  final FeatureEntity entity;

  @override
  List<Object?> get props => [entity];
}

class FeatureError extends FeatureState {
  const FeatureError({required this.message});

  final String message; // replace with typed Failure when adopted

  @override
  List<Object?> get props => [message];
}
```

### BLoC

```dart
// lib/feature/presentation/bloc/feature_bloc.dart
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FeatureBloc extends Bloc<FeatureEvent, FeatureState> {
  FeatureBloc({
    required this.getFeatureUseCase,
    required this.saveFeatureUseCase,
  }) : super(const FeatureInitial()) {
    on<LoadFeature>(_onLoad, transformer: droppable());
    on<SaveFeature>(_onSave, transformer: sequential());
  }

  final GetFeatureUseCase getFeatureUseCase;
  final SaveFeatureUseCase saveFeatureUseCase;

  Future<void> _onLoad(
    LoadFeature event,
    Emitter<FeatureState> emit,
  ) async {
    emit(const FeatureLoading());
    try {
      final entity = await getFeatureUseCase(GetFeatureParams(id: event.id));
      emit(FeatureLoaded(entity: entity));
    } on Exception catch (e) {
      emit(FeatureError(message: e.toString()));
    }
  }

  Future<void> _onSave(
    SaveFeature event,
    Emitter<FeatureState> emit,
  ) async {
    await saveFeatureUseCase(SaveFeatureParams(entity: event.entity));
  }
}
```

---

## Feature Scope

```dart
// lib/feature/feature_scope.dart
import 'package:bardak/utils/dependency_injection/di.dart';

void injectFeatureScope() {
  if (sl.isRegistered<FeatureRepository>()) return;

  sl
    ..registerLazySingleton<GetFeatureUseCase>(
      () => GetFeatureUseCase(sl()),
    )
    ..registerLazySingleton<SaveFeatureUseCase>(
      () => SaveFeatureUseCase(sl()),
    )
    ..registerLazySingleton<FeatureRepository>(
      () => FeatureRepositoryImpl(localDataSource: sl()),
    )
    ..registerLazySingleton<FeatureLocalDataSource>(
      () => FeatureLocalDataSourceImpl(sl()),
    );
}
```

Then in `lib/utils/dependency_injection/di.dart`:

```dart
Future<void> injectDependencies() async {
  // ... existing registrations ...
  injectFeatureScope(); // add this line
}
```

---

## Screen

```dart
// lib/feature/presentation/pages/feature_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FeatureScreen extends StatelessWidget {
  const FeatureScreen({super.key});

  static const routePath = 'feature';
  static const routeName = 'feature';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeatureBloc, FeatureState>(
      builder: (context, state) => switch (state) {
        FeatureInitial() => const SizedBox.shrink(),
        FeatureLoading() => const Center(child: CircularProgressIndicator()),
        FeatureLoaded(:final entity) => _FeatureContent(entity: entity),
        FeatureError(:final message) => Center(child: Text(message)),
      },
    );
  }
}

class _FeatureContent extends StatelessWidget {
  const _FeatureContent({required this.entity});

  final FeatureEntity entity;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.firstGradient,
      body: Center(
        child: Text(entity.value, style: context.typography.regular38),
      ),
    );
  }
}
```

---

## GoRoute entry

```dart
// in lib/router/app_router.dart, inside the parent route's `routes:` list:
GoRoute(
  path: FeatureScreen.routePath,
  name: FeatureScreen.routeName,
  pageBuilder: (context, state) => _buildPlatformPage(
    child: BlocProvider(
      create: (_) => FeatureBloc(
        getFeatureUseCase: sl(),
        saveFeatureUseCase: sl(),
      ),
      child: const FeatureScreen(),
    ),
  ),
),
```
