import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../shared/widgets/game_slot.dart';
import '../../../shared/widgets/game_screen_base.dart';
import '../../../shared/widgets/game_over_dialog.dart';
import '../providers/blind_sort_provider.dart';
import '../../../shared/models/game_state.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/text_theme_manager.dart';

class BlindSortScreen extends StatelessWidget {
  const BlindSortScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BlindSortProvider(),
      child: const _BlindSortView(),
    );
  }
}

class _BlindSortView extends StatelessWidget {
  const _BlindSortView();

  @override
  Widget build(BuildContext context) {
    return Consumer<BlindSortProvider>(
      builder: (context, provider, child) {
        final gameState = provider.gameState;

        // Show game over dialog when needed
        if (gameState.showGameOver) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _showGameOverDialog(context, gameState, provider);
          });
        }

        return GameScreenBase(
          title: 'blind_sort',
          descriptionKey: 'blind_sort_description',
          gameId: 'blind_sort',
          bottomActions: _buildBottomActions(context, gameState, provider),
          child: _buildGameContent(context, gameState, provider),
        );
      },
    );
  }

  Widget _buildGameContent(
    BuildContext context,
    GameState gameState,
    BlindSortProvider provider,
  ) {
    return Opacity(
      opacity: gameState.isWaiting ? 0.4 : 1.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Sabit sayı gösterimi alanı
          _buildNumberDisplayArea(context, gameState, provider),

          const SizedBox(height: AppConstants.extraLargeSpacing),

          // Sabit oyun slotları alanı
          _buildGameSlots(context, gameState, provider),

          // Dinamik içerik alanı (uyarı mesajları, oyun sonu mesajları)
          Expanded(child: _buildDynamicContent(context, gameState, provider)),
        ],
      ),
    );
  }

  Widget _buildNumberDisplayArea(
    BuildContext context,
    GameState gameState,
    BlindSortProvider provider,
  ) {
    return Container(
      constraints: const BoxConstraints(
        maxWidth: 300, // Maksimum genişlik
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Skor rozeti (Higher or Lower ile aynı)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: 0.15),
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
                  Icons.emoji_events_rounded,
                  size: 18,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 6),
                Text(
                  '${'score'.tr()}: ${gameState.score}',
                  style: TextThemeManager.subtitleMedium.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppConstants.mediumSpacing),

          // Modern sayı gösterimi
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  _getNumberDisplayColor(context, gameState),
                  _getNumberDisplayColor(
                    context,
                    gameState,
                  ).withValues(alpha: 0.8),
                ],
              ),
              borderRadius: BorderRadius.circular(AppConstants.largeRadius),
              boxShadow: [
                BoxShadow(
                  color: _getNumberDisplayColor(
                    context,
                    gameState,
                  ).withValues(alpha: 0.4),
                  blurRadius: 12,
                  spreadRadius: 0,
                  offset: const Offset(0, 4),
                ),
                BoxShadow(
                  color: _getNumberDisplayColor(
                    context,
                    gameState,
                  ).withValues(alpha: 0.2),
                  blurRadius: 20,
                  spreadRadius: 0,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Center(
              child: _buildNumberContent(context, gameState, provider),
            ),
          ),
        ],
      ),
    );
  }

  Color _getNumberDisplayColor(BuildContext context, GameState gameState) {
    if (gameState.isNextNumberUnplayable) {
      return Theme.of(context).brightness == Brightness.dark
          ? AppTheme.darkError
          : AppTheme.darkError;
    }
    return Theme.of(context).colorScheme.primary;
  }

  Widget _buildNumberContent(
    BuildContext context,
    GameState gameState,
    BlindSortProvider provider,
  ) {
    if (gameState.isWaiting) {
      return TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 2000),
        tween: Tween(begin: 0.0, end: 1.0),
        builder: (context, value, child) {
          return Transform.scale(
            scale: 0.8 + (0.2 * value),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(AppConstants.smallRadius),
              ),
              child: const Icon(
                Icons.question_mark_rounded,
                size: 36,
                color: Colors.white,
              ),
            ),
          );
        },
      );
    }

    if (gameState.isNextNumberUnplayable) {
      return Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(AppConstants.smallRadius),
        ),
        child: Text(
          gameState.currentNumber.toString(),
          style: TextThemeManager.gameNumber.copyWith(
            fontSize: 36,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 600),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.7 + (0.3 * value),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(AppConstants.smallRadius),
            ),
            child: Text(
              provider.isAnimating
                  ? provider.animatedNumber.toString()
                  : gameState.currentNumber.toString(),
              style: TextThemeManager.gameNumber.copyWith(
                fontSize: 36,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDynamicContent(
    BuildContext context,
    GameState gameState,
    BlindSortProvider provider,
  ) {
    // Oyun devam ediyor veya bekliyor - boş alan
    return const SizedBox.shrink();
  }

  void _showGameOverDialog(
    BuildContext context,
    GameState gameState,
    BlindSortProvider provider,
  ) {
    // Ensure we have the final score
    final finalScore = gameState.score;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return PopScope(
          canPop: false,
          child: GameOverDialog(
            title:
                gameState.status == GameStatus.won
                    ? 'Congratulations!'
                    : 'game_over'.tr(),
            subtitle:
                gameState.status == GameStatus.won
                    ? 'You successfully sorted all numbers!'
                    : null,
            score: finalScore,
            isWin: gameState.status == GameStatus.won,
            losingNumber:
                gameState.status != GameStatus.won &&
                        gameState.currentNumber != null
                    ? gameState.currentNumber.toString()
                    : null,
            onTryAgain: () {
              Navigator.of(context).pop();
              provider.hideGameOver();
              provider.resetGame();
            },
          ),
        );
      },
    );
  }

  Widget _buildGameSlots(
    BuildContext context,
    GameState gameState,
    BlindSortProvider provider,
  ) {
    return Container(
      constraints: const BoxConstraints(
        maxWidth: 350, // Maksimum genişlik
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Top Row (1-5)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(5, (index) {
              return GameSlot(
                number: gameState.slots[index],
                position: index,
                isActive:
                    gameState.isGameActive && gameState.slots[index] == null,
                onTap:
                    gameState.isGameActive
                        ? () => provider.placeNumber(index)
                        : null,
              );
            }),
          ),

          const SizedBox(height: AppConstants.mediumSpacing),

          // Bottom Row (6-10)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(5, (index) {
              final slotIndex = index + 5;
              return GameSlot(
                number: gameState.slots[slotIndex],
                position: slotIndex,
                isActive:
                    gameState.isGameActive &&
                    gameState.slots[slotIndex] == null,
                onTap:
                    gameState.isGameActive
                        ? () => provider.placeNumber(slotIndex)
                        : null,
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActions(
    BuildContext context,
    GameState gameState,
    BlindSortProvider provider,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        height: 60,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors:
                gameState.isWaiting
                    ? [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.8),
                    ]
                    : [
                      Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.8),
                      Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.6),
                    ],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.primary.withValues(
                alpha: gameState.isWaiting ? 0.4 : 0.2,
              ),
              blurRadius: gameState.isWaiting ? 16 : 8,
              offset: Offset(0, gameState.isWaiting ? 6 : 3),
              spreadRadius: 0,
            ),
            BoxShadow(
              color: Theme.of(context).colorScheme.primary.withValues(
                alpha: gameState.isWaiting ? 0.2 : 0.1,
              ),
              blurRadius: gameState.isWaiting ? 32 : 16,
              offset: Offset(0, gameState.isWaiting ? 12 : 6),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              if (gameState.isWaiting) {
                provider.startGame();
                provider.startNumberAnimation();
              } else {
                provider.resetGame();
              }
            },
            borderRadius: BorderRadius.circular(20),
            splashColor: Colors.white.withValues(alpha: 0.3),
            highlightColor: Colors.white.withValues(alpha: 0.1),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      gameState.isWaiting
                          ? Icons.play_arrow_rounded
                          : Icons.refresh_rounded,
                      size: 28,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 12),
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 200),
                    style: TextThemeManager.buttonLarge.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      letterSpacing: 0.5,
                    ),
                    child: Text(
                      gameState.isWaiting ? 'Start Game' : 'Restart Game',
                    ),
                  ),
                  if (gameState.isWaiting) ...[
                    const SizedBox(width: 8),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
