import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/game_settings.dart';
import '../models/game_theme.dart';
import 'card_reveal_screen.dart';
import '../services/game_service.dart';

class ThemeSelectionScreen extends StatefulWidget {
  final GameSettings settings;
  
  const ThemeSelectionScreen({
    Key? key,
    required this.settings,
  }) : super(key: key);

  @override
  State<ThemeSelectionScreen> createState() => _ThemeSelectionScreenState();
}

class _ThemeSelectionScreenState extends State<ThemeSelectionScreen> {
  GameThemeType _selectedTheme = GameThemeType.places;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Specify your theme'),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildThemeCard(
                    'Countries',
                    Icons.public,
                    GameThemeType.countries,
                  ),
                  _buildThemeCard(
                    'Objects',
                    Icons.lightbulb,
                    GameThemeType.objects,
                  ),
                  _buildThemeCard(
                    'Sports',
                    Icons.sports_soccer,
                    GameThemeType.sports,
                  ),
                  _buildThemeCard(
                    'Places',
                    Icons.location_on,
                    GameThemeType.places,
                  ),
                  _buildThemeCard(
                    'Animals',
                    Icons.pets,
                    GameThemeType.animals,
                  ),
                  _buildThemeCard(
                    'Transportation',
                    Icons.directions_car,
                    GameThemeType.transportation,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _startGame,
                style: AppTheme.primaryButtonStyle,
                child: const Text('CONFIRM'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeCard(String title, IconData icon, GameThemeType themeType) {
    final isSelected = _selectedTheme == themeType;
    
    return GestureDetector(
      onTap: () => setState(() => _selectedTheme = themeType),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.accentColor : AppTheme.secondaryColor,
          borderRadius: BorderRadius.circular(16),
          border: isSelected
              ? Border.all(color: Colors.white, width: 3)
              : null,
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 40,
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _startGame() {
    final updatedSettings = widget.settings.copyWith(
      selectedTheme: _selectedTheme,
    );
    
    final gameService = GameService(updatedSettings);
    gameService.startGame();
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CardRevealScreen(
          gameService: gameService,
          initialPlayerIndex: 0,
        ),
      ),
    );
  }
}