import 'package:flutter/material.dart';
import 'package:quicko_app/core/constants/app_icons.dart';
import 'package:quicko_app/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/game_screen_base.dart';
import '../../../shared/models/game_state.dart';
import '../models/color_hunt_game_state.dart';
import '../providers/color_hunt_provider.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/text_theme_manager.dart';

class ColorHuntScreen extends StatelessWidget {
  const ColorHuntScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ColorHuntProvider(),
      child: const _ColorHuntView(),
    );
  }
}

class _ColorHuntView extends StatelessWidget {
  const _ColorHuntView();

  @override
  Widget build(BuildContext context) {
    return Consumer<ColorHuntProvider>(
      builder: (context, provider, child) {
        final gameState = provider.gameState;

        // Create game result when game is over
        GameResult? gameResult;
        if (gameState.showGameOver) {
          gameResult = GameResult(
            isWin: gameState.status == GameStatus.won,
            score: gameState.score,
            title:
                gameState.status == GameStatus.won
                    ? 'Congratulations!'
                    : AppLocalizations.of(context)!.gameOver,
            subtitle:
                gameState.status == GameStatus.won
                    ? 'You found all colors!'
                    : 'Time ran out!',
          );
        }

        return GameScreenBase(
          title: 'color_hunt',
          descriptionKey: 'color_hunt_description',
          gameId: 'color_hunt',
          gameResult: gameResult,
          onTryAgain: () {
            provider.hideGameOver();
            provider.resetGame();
          },
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
          child: _buildGameContent(context, gameState, provider),
        );
      },
    );
  }

  Widget _buildGameContent(
    BuildContext context,
    ColorHuntGameState gameState,
    ColorHuntProvider provider,
  ) {
    return Opacity(
      opacity: gameState.isWaiting ? 0.4 : 1.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Skor ve zaman gösterimi
          _buildScoreTimeDisplay(context, gameState),

          const SizedBox(height: AppConstants.extraLargeSpacing),

          // Hedef renk gösterimi
          _buildTargetDisplay(context, gameState),

          const SizedBox(height: AppConstants.extraLargeSpacing),

          // Renk kutuları
          _buildColorBoxes(context, gameState, provider),
        ],
      ),
    );
  }

  Widget _buildScoreTimeDisplay(
    BuildContext context,
    ColorHuntGameState gameState,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.largeSpacing,
        vertical: AppConstants.mediumSpacing,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppConstants.mediumRadius),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            AppIcons.score,
            color: Theme.of(context).colorScheme.primary,
            size: 24,
          ),
          const SizedBox(width: AppConstants.smallSpacing),
          Text(
            '${AppLocalizations.of(context)!.score}: ${gameState.score}',
            style: TextThemeManager.gameScorePrimary(context),
          ),
          const SizedBox(width: AppConstants.mediumSpacing),
          Icon(
            AppIcons.timer,
            color: Theme.of(context).colorScheme.primary,
            size: 24,
          ),
          const SizedBox(width: AppConstants.smallSpacing),
          Text(
            '${AppLocalizations.of(context)!.time}: ${gameState.timeLeft}s',
            style: TextThemeManager.gameScorePrimary(context),
          ),
        ],
      ),
    );
  }

  Widget _buildTargetDisplay(
    BuildContext context,
    ColorHuntGameState gameState,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.largeSpacing,
        vertical: AppConstants.mediumSpacing,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppConstants.mediumRadius),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Text(
            AppLocalizations.of(context)!.target,
            style: TextThemeManager.subtitleMedium.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppConstants.smallSpacing),
          Text(
            gameState.targetColorName,
            style: TextThemeManager.gameNumber.copyWith(
              fontSize: 32,
              color: gameState.textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColorBoxes(
    BuildContext context,
    ColorHuntGameState gameState,
    ColorHuntProvider provider,
  ) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 400),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(4, (index) {
          return _buildColorBox(
            context,
            gameState.availableColors[index],
            index,
            gameState.wrongTapIndex == index,
            gameState.isGameActive,
            () => provider.onColorTap(index),
          );
        }),
      ),
    );
  }

  Widget _buildColorBox(
    BuildContext context,
    Color color,
    int index,
    bool isWrong,
    bool isActive,
    VoidCallback? onTap,
  ) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 150),
      tween: Tween(begin: 1.0, end: onTap != null ? 1.0 : 0.6),
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: isWrong ? AppTheme.darkError : color,
              borderRadius: BorderRadius.circular(AppConstants.mediumRadius),
              boxShadow: [
                BoxShadow(
                  color: (isWrong ? AppTheme.darkError : color).withValues(
                    alpha: 0.4,
                  ),
                  blurRadius: 8,
                  spreadRadius: 0,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(AppConstants.mediumRadius),
                splashColor: Colors.white.withValues(alpha: 0.3),
                highlightColor: Colors.white.withValues(alpha: 0.1),
                child: _AnimatedColorBoxContent(
                  color: color,
                  isWrong: isWrong,
                  onTap: onTap,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _AnimatedColorBoxContent extends StatefulWidget {
  final Color color;
  final bool isWrong;
  final VoidCallback? onTap;

  const _AnimatedColorBoxContent({
    required this.color,
    required this.isWrong,
    required this.onTap,
  });

  @override
  State<_AnimatedColorBoxContent> createState() =>
      _AnimatedColorBoxContentState();
}

class _AnimatedColorBoxContentState extends State<_AnimatedColorBoxContent>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown() {
    if (widget.onTap != null) {
      _controller.forward();
    }
  }

  void _onTapUp() {
    if (widget.onTap != null) {
      _controller.reverse();
      widget.onTap!();
    }
  }

  void _onTapCancel() {
    if (widget.onTap != null) {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _onTapDown(),
      onTapUp: (_) => _onTapUp(),
      onTapCancel: () => _onTapCancel(),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppConstants.mediumRadius),
              ),
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: widget.isWrong ? AppTheme.darkError : widget.color,
                  borderRadius: BorderRadius.circular(
                    AppConstants.mediumRadius,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
