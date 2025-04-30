import 'dart:math';
import 'player.dart';
import 'game_theme.dart';
import 'game_settings.dart';

enum GamePhase {
  setup,
  roleReveal,
  gameplay,
  voting,
  spyGuess,
  roundEnd
}

class GameState {
  final List<Player> players;
  final int spyCount;
  final GameThemeType themeType;
  final String selectedWord;
  final int timerDuration;
  final GamePhase currentPhase;
  final int currentPlayerIndex;
  final int currentRound;
  final Map<String, int> scores;
  final bool isTimerRunning;
  
  const GameState({
    required this.players,
    required this.spyCount,
    required this.themeType,
    required this.selectedWord,
    required this.timerDuration,
    this.currentPhase = GamePhase.setup,
    this.currentPlayerIndex = 0,
    this.currentRound = 1,
    required this.scores,
    this.isTimerRunning = false,
  });
  
  GameState copyWith({
    List<Player>? players,
    int? spyCount,
    GameThemeType? themeType,
    String? selectedWord,
    int? timerDuration,
    GamePhase? currentPhase,
    int? currentPlayerIndex,
    int? currentRound,
    Map<String, int>? scores,
    bool? isTimerRunning,
  }) {
    return GameState(
      players: players ?? this.players,
      spyCount: spyCount ?? this.spyCount,
      themeType: themeType ?? this.themeType,
      selectedWord: selectedWord ?? this.selectedWord,
      timerDuration: timerDuration ?? this.timerDuration,
      currentPhase: currentPhase ?? this.currentPhase,
      currentPlayerIndex: currentPlayerIndex ?? this.currentPlayerIndex,
      currentRound: currentRound ?? this.currentRound,
      scores: scores ?? this.scores,
      isTimerRunning: isTimerRunning ?? this.isTimerRunning,
    );
  }
  
  static GameState createNewGame(GameSettings settings) {
    final random = Random();
    final List<Player> players = [];
    final Map<String, int> scores = {};
    
    // Create players
    for (int i = 0; i < settings.playerCount; i++) {
      final player = Player(
        name: settings.playerNames[i],
      );
      players.add(player);
      scores[player.name] = 0;
    }
    
    // Assign spies
    final spyIndices = <int>[];
    while (spyIndices.length < settings.spyCount) {
      final spyIndex = random.nextInt(settings.playerCount);
      if (!spyIndices.contains(spyIndex)) {
        spyIndices.add(spyIndex);
        players[spyIndex] = players[spyIndex].copyWith(isSpy: true);
      }
    }
    
    // Select a random word
    final gameTheme = _getThemeFromType(settings.selectedTheme);
    final word = gameTheme.words[random.nextInt(gameTheme.words.length)];
    
    // Assign word to non-spy players
    for (int i = 0; i < players.length; i++) {
      if (!spyIndices.contains(i)) {
        players[i] = players[i].copyWith(secretWord: word);
      }
    }
    
    return GameState(
      players: players,
      spyCount: settings.spyCount,
      themeType: settings.selectedTheme,
      selectedWord: word,
      timerDuration: settings.timerDuration,
      scores: scores,
    );
  }
  
  static GameTheme _getThemeFromType(GameThemeType type) {
    switch (type) {
      case GameThemeType.countries:
        return GameThemes.countries;
      case GameThemeType.places:
        return GameThemes.places;
      case GameThemeType.sports:
        return GameThemes.sports;
      case GameThemeType.objects:
        return GameThemes.objects;
      case GameThemeType.animals:
        return GameThemes.animals;
      case GameThemeType.transportation:
        return GameThemes.transportation;
      case GameThemeType.custom:
        // In a real app, we would handle custom themes differently
        return GameThemes.places;
    }
  }
  
  List<Player> getSpies() {
    return players.where((player) => player.isSpy).toList();
  }
  
  Player getCurrentPlayer() {
    return players[currentPlayerIndex];
  }
  
  bool allPlayersAskedQuestions() {
    return players.every((player) => player.hasAskedQuestion);
  }
  
  bool allPlayersVoted() {
    return players.every((player) => player.hasVoted);
  }
  
  List<Player> getMostVotedPlayers() {
    if (players.isEmpty) return [];
    
    int maxVotes = players.map((p) => p.votesReceived).reduce(max);
    return players.where((p) => p.votesReceived == maxVotes).toList();
  }
}