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

class _CardRevealScreenState extends State<CardRevealScreen>
    with SingleTickerProviderStateMixin {
  late int _currentPlayerIndex;
  bool _isCardRevealed = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _currentPlayerIndex = widget.initialPlayerIndex;

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentPlayer =
        widget.gameService.gameState.players[_currentPlayerIndex];

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.deepPurple.shade900,
              Colors.deepPurple.shade700,
              Colors.purple.shade700,
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        currentPlayer.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 48),
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: GestureDetector(
                        onTap: _toggleCardReveal,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: 240,
                          height: 340,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: _isCardRevealed
                                  ? [
                                      Colors.deepPurpleAccent,
                                      Colors.purpleAccent
                                    ]
                                  : [
                                      Colors.deepPurple.shade800,
                                      Colors.purple.shade800
                                    ],
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: (_isCardRevealed
                                        ? Colors.deepPurpleAccent
                                        : Colors.black)
                                    .withOpacity(0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                            border: Border.all(
                              color: Colors.white,
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: _isCardRevealed
                                ? _buildRevealedCardContent(currentPlayer)
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.visibility,
                                        size: 80,
                                        color: Colors.white.withOpacity(0.8),
                                      ),
                                      const SizedBox(height: 16),
                                      const Text(
                                        'Tap to reveal',
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _isCardRevealed
                            ? 'Tap again to hide your card and pass the phone'
                            : 'Tap on the card to reveal your role',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRevealedCardContent(Player player) {
    if (player.isSpy) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.visibility_off,
            size: 60,
            color: Colors.white.withOpacity(0.8),
          ),
          const SizedBox(height: 16),
          const Text(
            'YOU ARE\nA SPY',
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            'Try to blend in and\nfind the word',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.check_circle,
            size: 60,
            color: Colors.white,
          ),
          const SizedBox(height: 16),
          Text(
            player.secretWord!,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            'You are an agent\nProtect the word',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
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
      if (_currentPlayerIndex ==
          widget.gameService.gameState.players.length - 1) {
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
            _controller.reset();
            _controller.forward();
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
