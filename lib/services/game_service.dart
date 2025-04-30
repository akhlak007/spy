import 'dart:math';
import '../models/game_state.dart';
import '../models/game_theme.dart';
import '../models/player.dart';
import '../models/game_settings.dart';

class GameService {
  GameState _gameState;
  
  GameService(GameSettings settings)
      : _gameState = GameState.createNewGame(settings);
  
  GameState get gameState => _gameState;
  
  void startGame() {
    _gameState = _gameState.copyWith(currentPhase: GamePhase.roleReveal);
  }
  
  void startGameplay() {
    _gameState = _gameState.copyWith(
      currentPhase: GamePhase.gameplay,
      isTimerRunning: true,
    );
  }
  
  void playerAskedQuestion(int playerIndex) {
    final List<Player> updatedPlayers = List.from(_gameState.players);
    updatedPlayers[playerIndex] = updatedPlayers[playerIndex].copyWith(
      hasAskedQuestion: true,
    );
    
    int nextPlayerIndex = (playerIndex + 1) % updatedPlayers.length;
    
    // Check if all players have asked questions
    if (updatedPlayers.every((player) => player.hasAskedQuestion)) {
      _gameState = _gameState.copyWith(
        players: updatedPlayers,
        currentPhase: GamePhase.voting,
        currentPlayerIndex: 0,
      );
    } else {
      _gameState = _gameState.copyWith(
        players: updatedPlayers,
        currentPlayerIndex: nextPlayerIndex,
      );
    }
  }
  
  void castVote(int voterIndex, int votedForIndex) {
    final List<Player> updatedPlayers = List.from(_gameState.players);
    
    // Mark that this player has voted
    updatedPlayers[voterIndex] = updatedPlayers[voterIndex].copyWith(
      hasVoted: true,
    );
    
    // Increment vote count for the player being voted for
    updatedPlayers[votedForIndex] = updatedPlayers[votedForIndex].copyWith(
      votesReceived: updatedPlayers[votedForIndex].votesReceived + 1,
    );
    
    int nextVoterIndex = _findNextPlayerWhoHasntVoted(updatedPlayers, voterIndex);
    
    // Check if all players have voted
    if (updatedPlayers.every((player) => player.hasVoted)) {
      handleVotingComplete(updatedPlayers);
    } else {
      _gameState = _gameState.copyWith(
        players: updatedPlayers,
        currentPlayerIndex: nextVoterIndex,
      );
    }
  }
  
  int _findNextPlayerWhoHasntVoted(List<Player> players, int currentIndex) {
    int nextIndex = (currentIndex + 1) % players.length;
    while (players[nextIndex].hasVoted && nextIndex != currentIndex) {
      nextIndex = (nextIndex + 1) % players.length;
    }
    return nextIndex;
  }
  
  void handleVotingComplete(List<Player> updatedPlayers) {
    // Find players with most votes
    int maxVotes = updatedPlayers.map((p) => p.votesReceived).reduce(max);
    List<Player> mostVotedPlayers = updatedPlayers
        .where((p) => p.votesReceived == maxVotes)
        .toList();
    
    // Choose a random player if there's a tie
    final random = Random();
    Player eliminatedPlayer = mostVotedPlayers[random.nextInt(mostVotedPlayers.length)];
    
    // Get index of the eliminated player
    int eliminatedIndex = updatedPlayers.indexWhere(
      (p) => p.name == eliminatedPlayer.name
    );
    
    bool spyCaught = eliminatedPlayer.isSpy;
    
    if (spyCaught) {
      // Move to round end if spy is caught
      final Map<String, int> updatedScores = Map.from(_gameState.scores);
      
      // Award points to non-spy players
      for (var player in updatedPlayers) {
        if (!player.isSpy) {
          updatedScores[player.name] = (updatedScores[player.name] ?? 0) + 1;
        }
      }
      
      _gameState = _gameState.copyWith(
        players: updatedPlayers,
        currentPhase: GamePhase.roundEnd,
        scores: updatedScores,
      );
    } else {
      // Move to spy guess phase if a non-spy was eliminated
      _gameState = _gameState.copyWith(
        players: updatedPlayers,
        currentPhase: GamePhase.spyGuess,
        currentPlayerIndex: updatedPlayers.indexWhere((p) => p.isSpy),
      );
    }
  }
  
  void handleSpyGuess(bool correctGuess) {
    final Map<String, int> updatedScores = Map.from(_gameState.scores);
    
    if (correctGuess) {
      // Award points to spies if they guess correctly
      for (var player in _gameState.players) {
        if (player.isSpy) {
          updatedScores[player.name] = (updatedScores[player.name] ?? 0) + 2;
        }
      }
    } else {
      // Award points to non-spies if spies guess incorrectly
      for (var player in _gameState.players) {
        if (!player.isSpy) {
          updatedScores[player.name] = (updatedScores[player.name] ?? 0) + 1;
        }
      }
    }
    
    _gameState = _gameState.copyWith(
      currentPhase: GamePhase.roundEnd,
      scores: updatedScores,
    );
  }
  
  void startNewRound() {
    // Reset player states for the new round
    final List<Player> updatedPlayers = _gameState.players.map((player) {
      player.resetForNewRound();
      return player;
    }).toList();
    
    // Reassign roles and word
    final random = Random();
    final spyIndices = <int>[];
    
    // Reset spy status
    for (int i = 0; i < updatedPlayers.length; i++) {
      updatedPlayers[i] = updatedPlayers[i].copyWith(isSpy: false, secretWord: null);
    }
    
    // Assign new spies
    while (spyIndices.length < _gameState.spyCount) {
      final spyIndex = random.nextInt(updatedPlayers.length);
      if (!spyIndices.contains(spyIndex)) {
        spyIndices.add(spyIndex);
        updatedPlayers[spyIndex] = updatedPlayers[spyIndex].copyWith(isSpy: true);
      }
    }
    
    // Get theme and select new word
    final gameTheme = GameThemes.getAllThemes()
        .firstWhere((theme) => theme.name.toLowerCase() == 
                             _gameState.themeType.toString().split('.').last);
    
    final word = gameTheme.words[random.nextInt(gameTheme.words.length)];
    
    // Assign word to non-spy players
    for (int i = 0; i < updatedPlayers.length; i++) {
      if (!spyIndices.contains(i)) {
        updatedPlayers[i] = updatedPlayers[i].copyWith(secretWord: word);
      }
    }
    
    _gameState = _gameState.copyWith(
      players: updatedPlayers,
      selectedWord: word,
      currentPhase: GamePhase.roleReveal,
      currentPlayerIndex: 0,
      currentRound: _gameState.currentRound + 1,
      isTimerRunning: false,
    );
  }
  
  void endGame() {
    // This could reset to setup phase or navigate to results screen
    _gameState = _gameState.copyWith(
      currentPhase: GamePhase.setup,
    );
  }
}