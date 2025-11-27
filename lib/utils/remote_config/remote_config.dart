import 'package:firebase_remote_config/firebase_remote_config.dart';

final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;

const _amWordsKey = 'words_version_am';
const _ruWordsKey = 'words_version_ru';
const _enWordsKey = 'words_version_en';

class AppRemoteConfig {
  AppRemoteConfig._(this._remoteConfig);

  static AppRemoteConfig? instance;

  final FirebaseRemoteConfig _remoteConfig;

  static Future<AppRemoteConfig> initialize() async {
    final remoteConfig = FirebaseRemoteConfig.instance;

    await remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 30),
        minimumFetchInterval: const Duration(days: 1),
      ),
    );

    await remoteConfig.fetchAndActivate();

    instance = AppRemoteConfig._(remoteConfig);
    return instance!;
  }

  int getWordsVersion(String locale) {
    return switch (locale) {
      'am' => amWordsVersion,
      'ru' => ruWordsVersion,
      'en' => enWordsVersion,
      _ => 0,
    };
  }

  int get amWordsVersion => _remoteConfig.getInt(_amWordsKey);

  int get ruWordsVersion => _remoteConfig.getInt(_ruWordsKey);

  int get enWordsVersion => _remoteConfig.getInt(_enWordsKey);
}
