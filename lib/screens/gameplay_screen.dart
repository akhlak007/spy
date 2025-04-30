import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/game_service.dart';
import '../services/timer_service.dart';
import '../models/game_state.dart';
import 'voting_screen.dart';

class GameplayScreen extends StatefulWidget {
  final GameService gameService;
  
  const GameplayScreen({
    Key? key,
    required this.gameService,
  }) : super(key: key);

  @override
  State<GameplayScreen> createState() => _GameplayScreenState();
}

class _GameplayScreenState extends State<GameplayScreen> {
  late TimerService _timerService;
  int _remainingSeconds = 0;
  String _formattedTime = '';
  
  @override
  void initState() {
    super.initState();
    _initTimer();
  }
  
  void _initTimer() {
    _remainingSeconds = widget.gameService.gameState.timerDuration;
    _formatTime();
    
    _timerService = TimerService(
      durationInSeconds: _remainingSeconds,
      onTick: (seconds) {
        setState(() {
          _remainingSeconds = seconds;
          _formatTime();
        });
      },
      onComplete: _handleTimerComplete,
    );
    
    if (widget.gameService.gameState.isTimerRunning) {
      _timerService.start();
    }
  }
  
  void _formatTime() {
    final minutes = (_remainingSeconds / 60).floor();
    final seconds = _remainingSeconds % 60;
    final tenths = 0; // Would be updated in a real implementation for smooth animation
    
    _formattedTime = '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}:${tenths.toString().padLeft(2, '0')}';
  }
  
  void _handleTimerComplete() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => VotingScreen(
          gameService: widget.gameService,
        ),
      ),
    );
  }
  
  @override
  void dispose() {
    _timerService.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final currentPlayer = widget.gameService.gameState.getCurrentPlayer();
    final allQuestionsAsked = widget.gameService.gameState.allPlayersAskedQuestions();
    
    if (allQuestionsAsked) {
      // Move to voting screen if all questions have been asked
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => VotingScreen(
              gameService: widget.gameService,
            ),
          ),
        );
      });
    }
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Question Time'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Remaining time',
              style: AppTheme.subheadingStyle.copyWith(
                color: AppTheme.textSecondaryColor,
              ),
            ),
            const SizedBox(height: 8),
            _buildTimerDisplay(),
            const SizedBox(height: 48),
            
            Text(
              'Current Player',
              style: AppTheme.subheadingStyle.copyWith(
                color: AppTheme.textSecondaryColor,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
              decoration: BoxDecoration(
                color: AppTheme.accentColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                currentPlayer.name,
                style: AppTheme.headingStyle,
              ),
            ),
            const SizedBox(height: 32),
            
            const Text(
              'Ask a subtle question to another player\nthat relates to the secret word',
              style: TextStyle(
                fontSize: 16,
                color: AppTheme.textSecondaryColor,
              ),
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _questionAsked,
                style: AppTheme.primaryButtonStyle,
                child: const Text('NEXT PLAYER'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimerDisplay() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.timer,
          size: 40,
          color: Colors.white,
        ),
        const SizedBox(width: 16),
        Text(
          _formattedTime,
          style: const TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: 'monospace',
          ),
        ),
      ],
    );
  }

  void _questionAsked() {
    widget.gameService.playerAskedQuestion(_getCurrentPlayerIndex());
    setState(() {});
  }

  int _getCurrentPlayerIndex() {
    return widget.gameService.gameState.currentPlayerIndex;
  }
}