/// The games whose completions count toward the in-app review prompt.
///
/// Each game is tracked independently: finishing enough games of a single
/// game type makes the user eligible, regardless of the other games.
enum ReviewGame { alias, spy, sudoku }
