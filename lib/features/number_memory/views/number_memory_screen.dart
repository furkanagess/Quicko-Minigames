import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:quicko_app/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:quicko_app/core/constants/app_icons.dart';
import '../../../shared/widgets/game_screen_base.dart';
import '../models/number_memory_game_state.dart';
import '../providers/number_memory_provider.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/text_theme_manager.dart';

class NumberMemoryScreen extends StatelessWidget {
  const NumberMemoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NumberMemoryProvider(),
      child: const _NumberMemoryView(),
    );
  }
}

class _NumberMemoryView extends StatelessWidget {
  const _NumberMemoryView();

  @override
  Widget build(BuildContext context) {
    return Consumer<NumberMemoryProvider>(
      builder: (context, provider, child) {
        final gameState = provider.gameState;

        // Create game result when game is over
        GameResult? gameResult;
        if (gameState.showGameOver) {
          final isWin = gameState.showCorrectMessage;
          gameResult = GameResult(
            isWin: isWin,
            score: gameState.score,
            title:
                isWin
                    ? AppLocalizations.of(context)!.congratulations
                    : AppLocalizations.of(context)!.gameOver,
            subtitle:
                isWin
                    ? AppLocalizations.of(context)!.youRememberedAllNumbers
                    : AppLocalizations.of(context)!.wrongNumber,
            lossReason:
                isWin ? null : AppLocalizations.of(context)!.wrongNumber,
          );
        } else if (gameState.showContinueDialog) {
          gameResult = GameResult(
            isWin: false,
            score: gameState.score,
            title: AppLocalizations.of(context)!.gameOver,
            subtitle: AppLocalizations.of(context)!.betterLuckNextTime,
            lossReason: AppLocalizations.of(context)!.wrongNumber,
          );
        }

        return GameScreenBase(
          title: 'number_memory',
          descriptionKey: 'number_memory_description',
          gameId: 'number_memory',
          gameResult: gameResult,
          onTryAgain: () {
            provider.hideGameOver();
            provider.hideContinueDialog();
            provider.resetGame();
          },
          onContinueGame: () => provider.continueGame(),
          canContinueGame: () => provider.canContinueGame(),
          onGameResultCleared: () {
            provider.hideGameOver();
            provider.hideContinueDialog();
          },
          onBackToMenu: () {
            provider.hideGameOver();
            provider.hideContinueDialog();
            Navigator.of(context).pop();
          },
          onStartGame: () {
            provider.startGame();
          },
          onResetGame: () {
            provider.resetGame();
          },
          isWaiting: !gameState.isGameActive,
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
    NumberMemoryGameState gameState,
    NumberMemoryProvider provider,
  ) {
    return Transform.translate(
      offset: const Offset(0, -20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Score + Level display (modern badge)
          _buildScoreLevelDisplay(context, gameState),

          const SizedBox(height: AppConstants.mediumSpacing),

          // Sequence display area
          _buildSequenceDisplay(context, gameState, provider),

          const SizedBox(height: AppConstants.mediumSpacing),

          // Keypad with opacity animation
          AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: gameState.isShowingSequence ? 0.3 : 1.0,
            child: IgnorePointer(
              ignoring: gameState.isShowingSequence,
              child: _buildKeypad(context, gameState, provider),
            ),
          ),

          const SizedBox(height: AppConstants.mediumSpacing),
        ],
      ),
    );
  }

  Widget _buildScoreLevelDisplay(
    BuildContext context,
    NumberMemoryGameState gameState,
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

  Widget _buildSequenceDisplay(
    BuildContext context,
    NumberMemoryGameState gameState,
    NumberMemoryProvider provider,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          constraints: const BoxConstraints(maxWidth: 260),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(gameState.level, (index) {
                String displayText;
                Color textColor;

                if (gameState.isShowingSequence) {
                  displayText = gameState.sequence[index].toString();
                  textColor = AppTheme.goldYellow;
                } else {
                  if (index < gameState.userInput.length) {
                    displayText = gameState.userInput[index].toString();
                    if (gameState.wrongIndices.contains(index)) {
                      textColor = AppTheme.darkError;
                    } else {
                      textColor = AppTheme.goldYellow;
                    }
                  } else {
                    displayText = '—';
                    textColor = AppTheme.goldYellow;
                  }
                }

                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    displayText,
                    style: TextThemeManager.gameNumber.copyWith(
                      color: textColor,
                      fontWeight: FontWeight.bold,
                      fontSize: _getDigitFontSize(gameState.level),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
        const SizedBox(width: AppConstants.smallSpacing),
        if (gameState.isWaitingForInput)
          _buildInlineDeleteButton(context, gameState, provider),
      ],
    );
  }

  double _getDigitFontSize(int level) {
    if (level <= 3) return 48;
    if (level <= 5) return 42;
    if (level <= 7) return 36;
    if (level <= 9) return 32;
    if (level <= 12) return 28;
    return 24;
  }

  Widget _buildKeypad(
    BuildContext context,
    NumberMemoryGameState gameState,
    NumberMemoryProvider provider,
  ) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 260),
      child: Column(
        children: [
          // Row 1: 1, 2, 3
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:
                [1, 2, 3]
                    .map(
                      (number) => _buildKeypadButton(
                        context,
                        number,
                        gameState,
                        provider,
                      ),
                    )
                    .toList(),
          ),
          const SizedBox(height: AppConstants.smallSpacing),
          // Row 2: 4, 5, 6
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:
                [4, 5, 6]
                    .map(
                      (number) => _buildKeypadButton(
                        context,
                        number,
                        gameState,
                        provider,
                      ),
                    )
                    .toList(),
          ),
          const SizedBox(height: AppConstants.smallSpacing),
          // Row 3: 7, 8, 9
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:
                [7, 8, 9]
                    .map(
                      (number) => _buildKeypadButton(
                        context,
                        number,
                        gameState,
                        provider,
                      ),
                    )
                    .toList(),
          ),
          const SizedBox(height: AppConstants.smallSpacing),
        ],
      ),
    );
  }

  Widget _buildKeypadButton(
    BuildContext context,
    int number,
    NumberMemoryGameState gameState,
    NumberMemoryProvider provider,
  ) {
    final isEnabled =
        gameState.isWaitingForInput &&
        gameState.userInput.length < gameState.level;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isEnabled ? () => provider.onNumberPressed(number) : null,
          borderRadius: BorderRadius.circular(AppConstants.mediumRadius),
          splashColor: Colors.white.withValues(alpha: 0.3),
          highlightColor: Colors.white.withValues(alpha: 0.1),
          child: Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppTheme.darkPrimary,
                  AppTheme.darkPrimary.withValues(alpha: 0.85),
                ],
              ),
              borderRadius: BorderRadius.circular(AppConstants.mediumRadius),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.darkPrimary.withValues(alpha: 0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Text(
                number.toString(),
                style: TextThemeManager.gameNumber.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInlineDeleteButton(
    BuildContext context,
    NumberMemoryGameState gameState,
    NumberMemoryProvider provider,
  ) {
    final bool isEnabled =
        gameState.isWaitingForInput && gameState.userInput.isNotEmpty;

    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 150),
      tween: Tween(begin: 1.0, end: isEnabled ? 1.0 : 0.6),
      builder: (context, value, child) {
        return Transform.scale(scale: value, child: child!);
      },
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isEnabled ? () => provider.onDeletePressed() : null,
          borderRadius: BorderRadius.circular(AppConstants.mediumRadius),
          splashColor: Colors.white.withValues(alpha: 0.3),
          highlightColor: Colors.white.withValues(alpha: 0.1),
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppTheme.darkError,
                  AppTheme.darkError.withValues(alpha: 0.85),
                ],
              ),
              borderRadius: BorderRadius.circular(AppConstants.mediumRadius),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.darkError.withValues(alpha: 0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Center(
              child: Icon(AppIcons.backspace, color: Colors.white, size: 22),
            ),
          ),
        ),
      ),
    );
  }
}
