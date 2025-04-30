import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/game_service.dart';
import '../models/player.dart';
import 'card_reveal_screen.dart';
import 'setup_screen.dart';

class RoundEndScreen extends StatelessWidget {
  final GameService gameService;
  final bool? spyGuessedCorrectly;
  final String? spyGuess;

  const RoundEndScreen({
    Key? key,
    required this.gameService,
    this.spyGuessedCorrectly,
    this.spyGuess,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gameState = gameService.gameState;
    final spies = gameState.getSpies();
    final correctWord = gameState.selectedWord;

    bool spiesWon = false;
    String resultText = '';

    if (spyGuessedCorrectly != null) {
      spiesWon = spyGuessedCorrectly!;
      resultText = spiesWon
          ? 'The spy correctly guessed the word and won!'
          : 'The spy failed to guess the word. Agents win!';
    } else {
      final mostVoted = gameState.getMostVotedPlayers();
      spiesWon = !(mostVoted.length == 1 && mostVoted.first.isSpy);
      resultText = spiesWon
          ? 'Agents failed to identify the spy. Spies win!'
          : 'Agents identified the spy correctly. Agents win!';
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Round Results'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                spiesWon ? Icons.visibility_off : Icons.visibility,
                size: 60,
                color: spiesWon ? AppTheme.accentColor : AppTheme.successColor,
              ),
              const SizedBox(height: 24),
              Text(
                spiesWon ? 'Spies Win!' : 'Agents Win!',
                style: AppTheme.headingStyle.copyWith(
                  color: spiesWon ? AppTheme.accentColor : AppTheme.successColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                resultText,
                style: const TextStyle(
                  fontSize: 16,
                  color: AppTheme.textColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              _buildInfoCard('The Word', correctWord),
              const SizedBox(height: 16),
              _buildInfoCard('Spies', spies.map((spy) => spy.name).join(', ')),

              if (spyGuess != null)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: _buildInfoCard('Spy\'s Guess', spyGuess!),
                ),

              const SizedBox(height: 32),
              _buildScoreTable(),
              const SizedBox(height: 32),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _backToSetup(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.errorColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('END GAME'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _startNextRound(context),
                      style: AppTheme.secondaryButtonStyle,
                      child: const Text('NEXT ROUND'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String content) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              color: AppTheme.textSecondaryColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            content,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreTable() {
    final scores = gameService.gameState.scores;
    final sortedScores = scores.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Scores',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.textColor,
            ),
          ),
          const SizedBox(height: 12),
          ...sortedScores.map((entry) => Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    entry.key,
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppTheme.textColor,
                    ),
                  ),
                ),
                Text(
                  entry.value.toString(),
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppTheme.highlightColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  void _startNextRound(BuildContext context) {
    gameService.startNewRound();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => CardRevealScreen(
          gameService: gameService,
          initialPlayerIndex: 0,
        ),
      ),
    );
  }

  void _backToSetup(BuildContext context) {
    gameService.endGame();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const SetupScreen()),
          (route) => false,
    );
  }
}