class AliasConstants {
  AliasConstants._();

  static const heroTag = 'alias_hero_tag';
  static const aliasCoverImagePath = 'assets/images/alias.png';

  // Settings
  static const defaultGameDuration = 60;
  static const minGameDuration = 20;
  static const maxGameDuration = 300;
  static const defaultPointsToWin = 100;
  static const minPointsToWin = 30;
  static const maxPointsToWin = 200;
  static const defaultWordsPerCard = 7;
  static const minWordsPerCard = 3;
  static const maxWordsPerCard = 10;

  // Shared preferences keys
  static const gameDurationKey = 'game_duration';
  static const pointsToWinKey = 'points_to_win';
  static const isSoundEnabledKey = 'is_sound_enabled';
  static const allowSkippingKey = 'allow_skipping';
  static const penaltyForSkippingKey = 'penalty_for_skipping';
  static const wordsPerCardKey = 'words_per_card';

  // Hive DB keys
  static const aliasWordPack = 'alias_word_packs';
  static const aliasWordPackName = 'alias_word_pack_name';
  static const aliasWordPackWords = 'alias_word_pack_words';
  static const aliasWordPackEmoji = 'alias_word_pack_emoji';
  static const aliasSelectedWordPackKey = 'alias_selected_word_pack';
}
