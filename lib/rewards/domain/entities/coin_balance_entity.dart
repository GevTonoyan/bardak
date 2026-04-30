import 'package:equatable/equatable.dart';

class CoinBalanceEntity extends Equatable {
  const CoinBalanceEntity({
    required this.coins,
    required this.boxesDay,
    required this.openedBoxes,
  });

  factory CoinBalanceEntity.initial() {
    return CoinBalanceEntity(
      coins: 0,
      boxesDay: _todayDate(),
      openedBoxes: const {},
    );
  }

  factory CoinBalanceEntity.fromJson(Map<String, dynamic> json) {
    final boxesDayRaw = json['boxesDay'] as String?;
    final boxesDay = boxesDayRaw != null
        ? (_parseYyyyMmDd(boxesDayRaw) ?? _todayDate())
        : _todayDate();

    final openedBoxesRaw = json['openedBoxes'];
    final openedBoxes = <int, int>{};

    if (openedBoxesRaw is Map) {
      for (final entry in openedBoxesRaw.entries) {
        final idx = int.tryParse(entry.key.toString());
        if (idx == null || idx < 0 || idx > 8) continue;

        final v = entry.value;
        if (v is int) openedBoxes[idx] = v;
        if (v is num) openedBoxes[idx] = v.toInt();
      }
    }

    return CoinBalanceEntity(
      coins: json['coins'] as int? ?? 0,
      boxesDay: boxesDay,
      openedBoxes: openedBoxes,
    ).normalizeForToday();
  }

  final int coins;
  final DateTime boxesDay;
  final Map<int, int> openedBoxes;

  bool get _isForToday {
    final today = _todayDate();
    return boxesDay.year == today.year &&
        boxesDay.month == today.month &&
        boxesDay.day == today.day;
  }

  /// Today's opened boxes map if [boxesDay] is today (same year/month/day), otherwise empty.
  Map<int, int> get openedBoxesToday => _isForToday ? openedBoxes : const {};

  int get openedCountToday => openedBoxesToday.length;

  bool isBoxOpened(int index) => openedBoxesToday.containsKey(index);

  CoinBalanceEntity normalizeForToday() {
    if (_isForToday) return this;
    return copyWith(
      boxesDay: _todayDate(),
      openedBoxes: const {},
    );
  }

  CoinBalanceEntity copyWith({
    int? coins,
    DateTime? boxesDay,
    Map<int, int>? openedBoxes,
  }) {
    return CoinBalanceEntity(
      coins: coins ?? this.coins,
      boxesDay: boxesDay ?? this.boxesDay,
      openedBoxes: openedBoxes ?? this.openedBoxes,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'coins': coins,
      'boxesDay': _formatYyyyMmDd(boxesDay),
      'openedBoxes': openedBoxes.map((k, v) => MapEntry(k.toString(), v)),
    };
  }

  @override
  List<Object?> get props => [coins, boxesDay, openedBoxes];

  static DateTime _todayDate() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  static DateTime? _parseYyyyMmDd(String value) {
    final parts = value.split('-');
    if (parts.length != 3) return null;
    final y = int.tryParse(parts[0]);
    final m = int.tryParse(parts[1]);
    final d = int.tryParse(parts[2]);
    if (y == null || m == null || d == null) return null;
    return DateTime(y, m, d);
  }

  static String _formatYyyyMmDd(DateTime dt) {
    final d = DateTime(dt.year, dt.month, dt.day);
    return '${d.year}-'
        '${d.month.toString().padLeft(2, '0')}-'
        '${d.day.toString().padLeft(2, '0')}';
  }
}
