import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/game_service.dart';
import 'round_end_screen.dart';

class SpyGuessScreen extends StatefulWidget {
  final GameService gameService;
  
  const SpyGuessScreen({
    Key? key,
    required this.gameService,
  }) : super(key: key);

  @override
  State<SpyGuessScreen> createState() => _SpyGuessScreenState();
}

class _SpyGuessScreenState extends State<SpyGuessScreen> {
  final TextEditingController _guessController = TextEditingController();
  String? _errorText;
  
  @override
  void dispose() {
    _guessController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final spy = widget.gameService.gameState.getSpies().first;
    final correctWord = widget.gameService.gameState.selectedWord;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Spy\'s Turn'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.visibility_off,
              size: 60,
              color: AppTheme.accentColor,
            ),
            const SizedBox(height: 24),
            Text(
              '${spy.name}, you have been identified as the spy!',
              style: AppTheme.subheadingStyle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'If you can guess the secret word, you still win the round!',
              style: TextStyle(
                fontSize: 16,
                color: AppTheme.textSecondaryColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            
            TextField(
              controller: _guessController,
              decoration: InputDecoration(
                labelText: 'Enter your guess',
                errorText: _errorText,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: AppTheme.cardColor,
              ),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 32),
            
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _submitGuess(false),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.errorColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('GIVE UP'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _submitGuess(true),
                    style: AppTheme.secondaryButtonStyle,
                    child: const Text('SUBMIT GUESS'),
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(
              'Correct word: $correctWord',
              style: const TextStyle(
                color: AppTheme.primaryColor,
                fontSize: 1, // Hidden, just for demo purposes
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submitGuess(bool isGuessing) {
    if (isGuessing) {
      if (_guessController.text.isEmpty) {
        setState(() {
          _errorText = 'Please enter a guess';
        });
        return;
      }
      
      final guess = _guessController.text.trim().toLowerCase();
      final correctWord = widget.gameService.gameState.selectedWord.toLowerCase();
      
      final isCorrect = guess == correctWord;
      widget.gameService.handleSpyGuess(isCorrect);
      
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => RoundEndScreen(
            gameService: widget.gameService,
            spyGuessedCorrectly: isCorrect,
            spyGuess: _guessController.text,
          ),
        ),
      );
    } else {
      // Spy gives up
      widget.gameService.handleSpyGuess(false);
      
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => RoundEndScreen(
            gameService: widget.gameService,
            spyGuessedCorrectly: false,
          ),
        ),
      );
    }
  }
}