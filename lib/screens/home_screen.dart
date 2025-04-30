import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'setup_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: AppTheme.primaryColor,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo and title
                const Icon(
                  Icons.visibility,
                  size: 80,
                  color: AppTheme.accentColor,
                ),
                const SizedBox(height: 24),
                const Text(
                  'SPY GAME',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Can you find the spy?',
                  style: TextStyle(
                    fontSize: 18,
                    color: AppTheme.textSecondaryColor,
                  ),
                ),
                const SizedBox(height: 60),
                
                // Menu buttons
                _buildMenuButton(
                  context,
                  'NEW GAME',
                  AppTheme.secondaryColor,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SetupScreen()),
                  ),
                ),
                const SizedBox(height: 16),
                _buildMenuButton(
                  context,
                  'HOW TO PLAY',
                  AppTheme.accentColor,
                  () => _showHowToPlay(context),
                ),
                const SizedBox(height: 16),
                _buildMenuButton(
                  context,
                  'SETTINGS',
                  AppTheme.cardColor,
                  () {}, // Would show settings screen in a complete implementation
                ),
                
                // Version and credits
                const Spacer(),
                const Text(
                  'Version 1.0.0',
                  style: TextStyle(
                    color: AppTheme.textSecondaryColor,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton(
    BuildContext context,
    String text,
    Color color,
    VoidCallback onPressed,
  ) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void _showHowToPlay(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cardColor,
        title: const Text(
          'How to Play',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                '1. All players join the game via the same device.',
                style: AppTheme.bodyStyle,
              ),
              SizedBox(height: 12),
              Text(
                '2. Most players (agents) receive a secret word, but a few randomly chosen players (spies) will not know the word.',
                style: AppTheme.bodyStyle,
              ),
              SizedBox(height: 12),
              Text(
                '3. Players take turns asking each other subtle questions about the word without revealing it directly.',
                style: AppTheme.bodyStyle,
              ),
              SizedBox(height: 12),
              Text(
                '4. After everyone has asked one question, players vote on who they think is the spy.',
                style: AppTheme.bodyStyle,
              ),
              SizedBox(height: 12),
              Text(
                '5. If a spy is caught, the agents win. If not, the spy gets a chance to guess the secret word.',
                style: AppTheme.bodyStyle,
              ),
              SizedBox(height: 12),
              Text(
                '6. If the spy guesses correctly, they win. Otherwise, the agents win.',
                style: AppTheme.bodyStyle,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'GOT IT',
              style: TextStyle(
                color: AppTheme.accentColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}