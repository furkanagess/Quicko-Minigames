import 'package:flutter/material.dart' hide Card;
import 'package:quicko_app/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:quicko_app/core/constants/app_icons.dart';
import '../../../shared/widgets/game_screen_base.dart';
import '../../../shared/models/game_state.dart';
import '../models/twenty_one_game_state.dart';
import '../providers/twenty_one_provider.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/text_theme_manager.dart';

class TwentyOneScreen extends StatelessWidget {
  const TwentyOneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TwentyOneProvider(),
      child: const _TwentyOneView(),
    );
  }
}

class _TwentyOneView extends StatelessWidget {
  const _TwentyOneView();

  @override
  Widget build(BuildContext context) {
    return Consumer<TwentyOneProvider>(
      builder: (context, provider, child) {
        final gameState = provider.gameState;

        // Create game result when game is over
        GameResult? gameResult;
        if (gameState.showGameOver) {
          // ignore: unrelated_type_equality_checks
          final isWin = gameState.status == GameStatus.won;
          gameResult = GameResult(
            isWin: isWin,
            score: gameState.score,
            title:
                isWin
                    ? AppLocalizations.of(context)!.congratulations
                    : AppLocalizations.of(context)!.gameOver,
            subtitle:
                isWin
                    ? AppLocalizations.of(context)!.youReached21
                    : AppLocalizations.of(context)!.youWentOver21,
            lossReason:
                isWin ? null : AppLocalizations.of(context)!.youWentOver21,
          );
        }

        return GameScreenBase(
          title: 'twenty_one',
          descriptionKey: 'twenty_one_description',
          gameId: 'twenty_one',
          gameResult: gameResult,
          showCongratsOnWin: true,
          onTryAgain: () {
            provider.hideGameOver();
            provider.resetGame();
          },
          onContinueGame: () => provider.continueGame(),
          canContinueGame: () => provider.canContinueGame(),
          onGameResultCleared: () => provider.hideGameOver(),
          onBackToMenu: () {
            provider.hideGameOver();
            Navigator.of(context).pop();
          },
          onStartGame: () {
            provider.startGame();
          },
          onResetGame: () {
            provider.resetGame();
          },
          isWaiting: gameState.isWaiting,
          isGameInProgress: gameState.isGameActive,
          onPauseGame: () => provider.pauseGame(),
          onResumeGame: () => provider.resumeGame(),
          child: _buildGameContent(context, gameState, provider),
        );
      },
    );
  }

  Widget _buildGameContent(
    BuildContext context,
    TwentyOneGameState gameState,
    TwentyOneProvider provider,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // final maxWidth = constraints.maxWidth;
        // final maxHeight = constraints.maxHeight;

        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Top section: Score
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Score display
                  _buildScoreDisplay(context, gameState),
                ],
              ),
            ),

            // Middle section: Player and Dealer side by side
            Expanded(
              flex: 4,
              child: Row(
                children: [
                  // You section (left)
                  Expanded(child: _buildPlayerSection(context, gameState)),
                  const SizedBox(width: AppConstants.mediumSpacing),
                  // Dealer section (right)
                  Expanded(child: _buildDealerSection(context, gameState)),
                ],
              ),
            ),

            // Bottom section: Action buttons
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Action buttons
                  if (gameState.isGameActive && !gameState.isDealerTurn)
                    _buildActionButtons(context, gameState, provider),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildScoreDisplay(
    BuildContext context,
    TwentyOneGameState gameState,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            AppIcons.trophy,
            color: Theme.of(context).colorScheme.primary,
            size: 18,
          ),
          const SizedBox(width: 6),
          Text(
            '${AppLocalizations.of(context)!.score}: ${gameState.score}',
            style: TextThemeManager.subtitleMedium.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDealerSection(
    BuildContext context,
    TwentyOneGameState gameState,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          AppLocalizations.of(context)!.dealer,
          style: TextThemeManager.subtitleMedium.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppConstants.smallSpacing),
        _buildHandDisplay(
          context,
          gameState.dealerHand,
          gameState.dealerVisibleTotal,
        ),
      ],
    );
  }

  Widget _buildPlayerSection(
    BuildContext context,
    TwentyOneGameState gameState,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          AppLocalizations.of(context)!.you,
          style: TextThemeManager.subtitleMedium.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppConstants.smallSpacing),
        _buildHandDisplay(context, gameState.playerHand, gameState.playerTotal),
      ],
    );
  }

  Widget _buildHandDisplay(BuildContext context, List<Card> hand, int total) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 280),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          // Cards
          Wrap(
            spacing: 4,
            runSpacing: 4,
            alignment: WrapAlignment.center,
            children: hand.map((card) => _buildCard(context, card)).toList(),
          ),
          const SizedBox(height: AppConstants.smallSpacing),
          // Total
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppTheme.darkPrimary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppTheme.darkPrimary.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Text(
              '${AppLocalizations.of(context)!.total}: $total',
              style: TextThemeManager.bodyMedium.copyWith(
                color: AppTheme.darkPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context, Card card) {
    return Container(
      width: 55,
      height: 75,
      decoration: BoxDecoration(
        color: card.isHidden ? AppTheme.overlayDark : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Center(
        child: Text(
          card.displayName,
          style: TextStyle(
            fontSize: card.isHidden ? 18 : 14,
            fontWeight: FontWeight.bold,
            color: card.isHidden ? Colors.white : _getCardColor(card.suit),
          ),
        ),
      ),
    );
  }

  Color _getCardColor(String suit) {
    if (suit == '♥' || suit == '♦') {
      return Colors.red;
    }
    return Colors.black;
  }

  Widget _buildActionButtons(
    BuildContext context,
    TwentyOneGameState gameState,
    TwentyOneProvider provider,
  ) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 400),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildActionButton(
            context,
            AppLocalizations.of(context)!.hit,
            Icons.add,
            AppTheme.darkSuccess,
            gameState.canHit ? () => provider.hit() : null,
          ),
          _buildActionButton(
            context,
            AppLocalizations.of(context)!.stand,
            Icons.stop,
            AppTheme.darkError,
            gameState.canStand ? () => provider.stand() : null,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    String text,
    IconData icon,
    Color color,
    VoidCallback? onPressed,
  ) {
    return Container(
      width: 120,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
          padding: EdgeInsets.zero,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 24),
            const SizedBox(height: 4),
            Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
