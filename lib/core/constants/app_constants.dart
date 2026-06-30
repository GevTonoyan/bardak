class AppConstants {
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
  static const wordsVersionKey = 'words_version';

  // Hive DB keys
  static const aliasWordPack = 'alias_word_packs';
  static const aliasWordPackName = 'alias_word_pack_name';
  static const aliasWordPackWords = 'alias_word_pack_words';
  static const aliasWordPackImage = 'alias_word_pack_image';
  static const aliasWordPackImageBlurHash = 'alias_word_pack_image_blur_hash';
  static const aliasSelectedWordPackKey = 'alias_selected_word_pack';

  // Sync
  static const lastWordsSyncKey = 'last_words_sync';
  static const wordsSyncIntervalDays = 3;
}
