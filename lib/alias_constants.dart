class AliasConstants {
  AliasConstants._();

  static const aliasCoverImagePath = 'assets/images/alias.png';

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
  static const teamNameMaxLength = 15;

  // Shared preferences keys
  static const roundDurationKey = 'round_duration';
  static const pointsToWinKey = 'points_to_win';
  static const soundEnabledKey = 'is_sound_enabled';
  static const allowSkippingKey = 'allow_skipping';
  static const penaltyForSkippingKey = 'penalty_for_skipping';
  static const wordsPerCardKey = 'words_per_card';
  static const gameModeKey = 'game_mode';
  static const teamNamesKey = 'team_names';
  static const preGameConfigKey = 'pre_game_config';

  // Hive DB keys
  static const aliasWordPack = 'alias_word_packs';
  static const aliasWordPackName = 'alias_word_pack_name';
  static const aliasWordPackWords = 'alias_word_pack_words';
  static const aliasWordPackEmoji = 'alias_word_pack_emoji';
  static const aliasSelectedWordPackKey = 'alias_selected_word_pack';
}
