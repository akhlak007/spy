import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/game_service.dart';
import '../models/player.dart';
import 'gameplay_screen.dart';

class CardRevealScreen extends StatefulWidget {
  final GameService gameService;
  final int initialPlayerIndex;
  
  const CardRevealScreen({
    Key? key,
    required this.gameService,
    required this.initialPlayerIndex,
  }) : super(key: key);

  @override
  State<CardRevealScreen> createState() => _CardRevealScreenState();
}

class _CardRevealScreenState extends State<CardRevealScreen> {
  late int _currentPlayerIndex;
  bool _isCardRevealed = false;
  
  @override
  void initState() {
    super.initState();
    _currentPlayerIndex = widget.initialPlayerIndex;
  }
  
  @override
  Widget build(BuildContext context) {
    final currentPlayer = widget.gameService.gameState.players[_currentPlayerIndex];
    
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                currentPlayer.name,
                style: AppTheme.headingStyle,
              ),
              const SizedBox(height: 48),
              GestureDetector(
                onTap: _toggleCardReveal,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 240,
                  height: 340,
                  decoration: BoxDecoration(
                    color: AppTheme.secondaryColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.white,
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: _isCardRevealed
                        ? _buildRevealedCardContent(currentPlayer)
                        : const Icon(
                            Icons.visibility,
                            size: 80,
                            color: Colors.white,
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                _isCardRevealed
                    ? 'Tap again to hide your card and pass the phone'
                    : 'Tap on the card',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRevealedCardContent(Player player) {
    if (player.isSpy) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(
            Icons.visibility_off,
            size: 60,
            color: Colors.white,
          ),
          SizedBox(height: 16),
          Text(
            'YOU ARE\nA SPY.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      );
    } else {
      return Text(
        player.secretWord!,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      );
    }
  }

  void _toggleCardReveal() {
    if (_isCardRevealed) {
      // Card is already revealed, hide it and move to next player
      setState(() {
        _isCardRevealed = false;
      });
      
      // Check if all players have seen their cards
      if (_currentPlayerIndex == widget.gameService.gameState.players.length - 1) {
        widget.gameService.startGameplay();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => GameplayScreen(
              gameService: widget.gameService,
            ),
          ),
        );
      } else {
        // Move to next player
        Future.delayed(const Duration(milliseconds: 500), () {
          setState(() {
            _currentPlayerIndex++;
          });
        });
      }
    } else {
      // Reveal the card
      setState(() {
        _isCardRevealed = true;
      });
    }
  }
}