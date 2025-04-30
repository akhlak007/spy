import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/game_settings.dart';
import '../widgets/number_selector.dart';
import 'theme_selection_screen.dart';

class SetupScreen extends StatefulWidget {
  const SetupScreen({Key? key}) : super(key: key);

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  int _playerCount = 4;
  int _spyCount = 1;
  int _timerMinutes = 5;
  int _themeCount = 6;
  final List<TextEditingController> _nameControllers = [];

  @override
  void initState() {
    super.initState();
    _initializeNameControllers();
  }

  void _initializeNameControllers() {
    _nameControllers.clear();
    for (int i = 0; i < 8; i++) {
      _nameControllers.add(TextEditingController(text: 'Player ${i + 1}'));
    }
  }

  @override
  void dispose() {
    for (var controller in _nameControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuration'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildConfigCard(
                    'Players',
                    _playerCount.toString(),
                    Icons.people,
                    AppTheme.accentColor,
                    () => _showNumberSelector(
                      'Players',
                      _playerCount,
                      3,
                      8,
                      (value) => setState(() => _playerCount = value),
                    ),
                  ),
                  _buildConfigCard(
                    'Spies',
                    _spyCount.toString(),
                    Icons.visibility,
                    AppTheme.secondaryColor,
                    () => _showNumberSelector(
                      'Spies',
                      _spyCount,
                      1,
                      (_playerCount / 3).floor(),
                      (value) => setState(() => _spyCount = value),
                    ),
                  ),
                  _buildConfigCard(
                    'Timer',
                    '$_timerMinutes min',
                    Icons.timer,
                    AppTheme.secondaryColor,
                    () => _showNumberSelector(
                      'Timer (minutes)',
                      _timerMinutes,
                      1,
                      15,
                      (value) => setState(() => _timerMinutes = value),
                    ),
                  ),
                  _buildConfigCard(
                    'Themes',
                    _themeCount.toString(),
                    Icons.category,
                    AppTheme.accentColor,
                    () => _showNumberSelector(
                      'Theme Count',
                      _themeCount,
                      1,
                      6,
                      (value) => setState(() => _themeCount = value),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                'Player Names',
                style: AppTheme.subheadingStyle,
              ),
              const SizedBox(height: 16),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _playerCount,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: TextField(
                      controller: _nameControllers[index],
                      style: const TextStyle(
                        color: AppTheme.textColor,
                        fontSize: 16,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Player ${index + 1}',
                        labelStyle: const TextStyle(
                          color: AppTheme.textSecondaryColor,
                          fontSize: 14,
                        ),
                        filled: true,
                        fillColor: AppTheme.cardColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: AppTheme.accentColor,
                            width: 2,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () => _navigateToThemeSelection(),
                  style: AppTheme.primaryButtonStyle,
                  child: const Text('PLAY'),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConfigCard(
    String title,
    String value,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: AppTheme.textColor,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppTheme.textColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                color: AppTheme.textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showNumberSelector(
    String title,
    int currentValue,
    int min,
    int max,
    Function(int) onValueChanged,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => NumberSelector(
        title: title,
        currentValue: currentValue,
        minValue: min,
        maxValue: max,
        onValueChanged: onValueChanged,
      ),
    );
  }

  void _navigateToThemeSelection() {
    final settings = GameSettings(
      playerCount: _playerCount,
      spyCount: _spyCount,
      timerDuration: _timerMinutes * 60,
      playerNames: _nameControllers
          .sublist(0, _playerCount)
          .map((controller) => controller.text.trim())
          .toList(),
      selectedTheme: GameThemeType.places,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ThemeSelectionScreen(settings: settings),
      ),
    );
  }
}
