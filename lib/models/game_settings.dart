class GameSettings {
  final int playerCount;
  final int spyCount;
  final int timerDuration; // in seconds
  final List<String> playerNames;
  final GameThemeType selectedTheme;
  
  const GameSettings({
    required this.playerCount,
    required this.spyCount,
    required this.timerDuration,
    required this.playerNames,
    required this.selectedTheme,
  });
  
  GameSettings copyWith({
    int? playerCount,
    int? spyCount,
    int? timerDuration,
    List<String>? playerNames,
    GameThemeType? selectedTheme,
  }) {
    return GameSettings(
      playerCount: playerCount ?? this.playerCount,
      spyCount: spyCount ?? this.spyCount,
      timerDuration: timerDuration ?? this.timerDuration,
      playerNames: playerNames ?? this.playerNames,
      selectedTheme: selectedTheme ?? this.selectedTheme,
    );
  }
}

enum GameThemeType {
  countries,
  places,
  sports,
  objects,
  animals,
  transportation,
  custom
}