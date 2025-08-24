import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quicko_app/l10n/app_localizations.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_icons.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/text_theme_manager.dart';

import '../../../shared/widgets/game_screen_base.dart';

import '../models/pattern_memory_game_state.dart';
import '../providers/pattern_memory_provider.dart';

class PatternMemoryScreen extends StatelessWidget {
  const PatternMemoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PatternMemoryProvider(),
      child: Consumer<PatternMemoryProvider>(
        builder: (context, provider, child) {
          final gameState = provider.gameState;

          // Create game result when game is over
          GameResult? gameResult;
          if (gameState.showGameOver) {
            gameResult = GameResult(
              isWin: false,
              score: gameState.score,
              title: AppLocalizations.of(context)!.gameOver,
              subtitle: AppLocalizations.of(context)!.wrongPattern,
              lossReason: AppLocalizations.of(context)!.wrongPattern,
            );
          }

          return GameScreenBase(
            title: 'pattern_memory',
            descriptionKey: 'pattern_memory_description',
            gameId: 'pattern_memory',
            gameResult: gameResult,
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
      ),
    );
  }

  Widget _buildGameContent(
    BuildContext context,
    PatternMemoryGameState gameState,
    PatternMemoryProvider provider,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Score info (matched to Find Difference design)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: 0.2),
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
        ),

        const SizedBox(height: AppConstants.extraLargeSpacing),

        // Game grid
        _buildGameGrid(context, gameState, provider),
      ],
    );
  }

  Widget _buildGameGrid(
    BuildContext context,
    PatternMemoryGameState gameState,
    PatternMemoryProvider provider,
  ) {
    const gridSize = 5;
    const tileSpacing = 8.0;
    const tileRadius = 8.0;

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxSize = constraints.maxWidth - 40; // Padding

        return SizedBox(
          width: maxSize,
          height: maxSize,
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: gridSize,
              mainAxisSpacing: tileSpacing,
              crossAxisSpacing: tileSpacing,
              childAspectRatio: 1,
            ),
            itemCount: gridSize * gridSize,
            itemBuilder: (context, index) {
              final row = index ~/ gridSize;
              final col = index % gridSize;

              final isHighlighted = gameState.pattern.contains(index);
              final isSelected = gameState.userSelection.contains(index);
              final isCorrect = gameState.correctSelections.contains(index);
              final isWrong = gameState.wrongIndices.contains(index);
              final hasWrongSelection = gameState.wrongIndices.isNotEmpty;

              Color tileColor;
              if (isCorrect) {
                tileColor = AppTheme.darkSuccess; // Correct tiles stay green
              } else if (isWrong) {
                tileColor = AppTheme.darkError; // Wrong tiles are red
              } else if (isSelected) {
                tileColor = AppTheme.darkSuccess; // Selected tiles are green
              } else if (isHighlighted &&
                  (gameState.isShowingPattern || hasWrongSelection)) {
                tileColor =
                    Colors
                        .yellow; // Pattern tiles during show phase or when showing feedback
              } else {
                tileColor = Theme.of(context).colorScheme.surface;
              }

              return Semantics(
                label:
                    '${AppLocalizations.of(context)!.row} ${row + 1} ${AppLocalizations.of(context)!.column} ${col + 1}',
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  decoration: BoxDecoration(
                    color: tileColor,
                    borderRadius: BorderRadius.circular(tileRadius),
                    border: Border.all(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.2),
                      width: 1,
                    ),
                    boxShadow: [
                      if (isSelected || isHighlighted || isWrong)
                        BoxShadow(
                          color: tileColor.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap:
                          (isCorrect || hasWrongSelection)
                              ? null
                              : () => provider.onTileTapped(index),
                      borderRadius: BorderRadius.circular(tileRadius),
                      child: Container(),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
