import 'package:flutter/material.dart';
import '../models/game_state.dart';
import '../theme/app_theme.dart';
import '../services/game_service.dart';
import '../models/player.dart';
import 'spy_guess_screen.dart';
import 'round_end_screen.dart';

class VotingScreen extends StatefulWidget {
  final GameService gameService;
  
  const VotingScreen({
    Key? key,
    required this.gameService,
  }) : super(key: key);

  @override
  State<VotingScreen> createState() => _VotingScreenState();
}

class _VotingScreenState extends State<VotingScreen> {
  @override
  Widget build(BuildContext context) {
    final currentVoter = widget.gameService.gameState.getCurrentPlayer();
    final allPlayersVoted = widget.gameService.gameState.allPlayersVoted();
    
    if (allPlayersVoted) {
      // Check game state to determine next screen
      final gameState = widget.gameService.gameState;
      
      if (gameState.currentPhase == GamePhase.spyGuess) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => SpyGuessScreen(
                gameService: widget.gameService,
              ),
            ),
          );
        });
      } else if (gameState.currentPhase == GamePhase.roundEnd) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => RoundEndScreen(
                gameService: widget.gameService,
              ),
            ),
          );
        });
      }
    }
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Voting'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '${currentVoter.name}, who do you think is the spy?',
              style: AppTheme.subheadingStyle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            
            Expanded(
              child: ListView.builder(
                itemCount: widget.gameService.gameState.players.length,
                itemBuilder: (context, index) {
                  final player = widget.gameService.gameState.players[index];
                  // Skip the current voter
                  if (player.name == currentVoter.name) {
                    return const SizedBox.shrink();
                  }
                  return _buildPlayerVoteCard(player, index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayerVoteCard(Player player, int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: GestureDetector(
        onTap: () => _castVote(index),
        child: Container(
          decoration: BoxDecoration(
            color: AppTheme.cardColor,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  color: AppTheme.secondaryColor,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Text(
                player.name,
                style: AppTheme.subheadingStyle,
              ),
              const Spacer(),
              const Icon(
                Icons.arrow_forward_ios,
                color: AppTheme.textSecondaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _castVote(int votedForIndex) {
    final currentVoterIndex = widget.gameService.gameState.currentPlayerIndex;
    widget.gameService.castVote(currentVoterIndex, votedForIndex);
    setState(() {});
  }
}