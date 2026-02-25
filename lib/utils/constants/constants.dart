class AppConstants {
  //settings preferences keys
  static const appThemeKey = 'app_theme_key';
  static const appLocaleKey = 'app_locale_key';
  static const appColorSchemeKey = 'app_color_scheme_key';
  static const soundEnabledKey = 'is_sound_enabled';

  // Settings
  static const defaultRoundDuration = 60;
  static const minRoundDuration = 30;
  static const maxRoundDuration = 120;
  static const defaultPointsToWin = 60;
  static const minPointsToWin = 30;
  static const maxPointsToWin = 120;
  static const defaultWordsPerCard = 6;
  static const minWordsPerCard = 4;
  static const maxWordsPerCard = 8;
  static const minTeamCount = 2;
  static const maxTeamCount = 4;

  // Shared preferences keys
  static const roundDurationKey = 'round_duration';
  static const pointsToWinKey = 'points_to_win';
  static const allowSkippingKey = 'allow_skipping';
  static const penaltyForSkippingKey = 'penalty_for_skipping';
  static const wordsPerCardKey = 'words_per_card';
  static const wordsVersionKey = 'words_version';

  // Hive DB keys
  static const aliasWordPack = 'alias_word_packs';
  static const aliasWordPackName = 'alias_word_pack_name';
  static const aliasWordPackWords = 'alias_word_pack_words';
  static const aliasSelectedWordPackKey = 'alias_selected_word_pack';
}
