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
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
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
                    Colors.deepPurple,
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
                    Colors.indigo,
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
                    Colors.purple,
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
                    Colors.deepPurpleAccent,
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
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.person_outline,
                          color: Colors.deepPurple,
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Player Names',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _playerCount,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[50],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.grey[200]!,
                                width: 1,
                              ),
                            ),
                            child: TextField(
                              controller: _nameControllers[index],
                              style: const TextStyle(
                                color: Colors.black87,
                                fontSize: 16,
                              ),
                              decoration: InputDecoration(
                                labelText: 'Player ${index + 1}',
                                labelStyle: const TextStyle(
                                  color: Colors.deepPurple,
                                  fontSize: 14,
                                ),
                                prefixIcon: Container(
                                  width: 40,
                                  height: 40,
                                  margin: const EdgeInsets.only(right: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.deepPurple.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${index + 1}',
                                      style: const TextStyle(
                                        color: Colors.deepPurple,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                prefixIconConstraints: const BoxConstraints(
                                  minWidth: 40,
                                  minHeight: 40,
                                ),
                                filled: true,
                                fillColor: Colors.transparent,
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
                                    color: Colors.deepPurple,
                                    width: 2,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 16,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () => _navigateToThemeSelection(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: const Text(
                    'PLAY',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [
                  Shadow(
                    offset: Offset(1, 1),
                    blurRadius: 2,
                    color: Colors.black26,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white,
                shadows: [
                  Shadow(
                    offset: Offset(1, 1),
                    blurRadius: 2,
                    color: Colors.black26,
                  ),
                ],
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
      backgroundColor: Colors.black,
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
