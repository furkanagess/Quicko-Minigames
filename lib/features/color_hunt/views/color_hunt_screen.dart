import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../shared/widgets/game_screen_base.dart';
import '../../../shared/widgets/game_over_dialog.dart';
import '../../../shared/widgets/time_up_dialog.dart';
import '../../../shared/models/color_hunt_game_state.dart';
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

        // Show game over or time up dialog when needed
        if (gameState.showGameOver) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (gameState.timeLeft == 0) {
              _showTimeUpDialog(context, gameState, provider);
            } else {
              _showGameOverDialog(context, gameState, provider);
            }
          });
        }

        return GameScreenBase(
          title: 'color_hunt',
          descriptionKey: 'color_hunt_description',
          gameId: 'color_hunt',
          bottomActions: _buildBottomActions(context, gameState, provider),
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
            Icons.score_rounded,
            color: Theme.of(context).colorScheme.primary,
            size: 24,
          ),
          const SizedBox(width: AppConstants.smallSpacing),
          Text(
            '${'score'.tr()}: ${gameState.score}',
            style: TextThemeManager.gameScorePrimary(context),
          ),
          const SizedBox(width: AppConstants.mediumSpacing),
          Icon(
            Icons.timer_rounded,
            color: Theme.of(context).colorScheme.primary,
            size: 24,
          ),
          const SizedBox(width: AppConstants.smallSpacing),
          Text(
            '${'time'.tr()}: ${gameState.timeLeft}s',
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
            'target'.tr(),
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
              color: isWrong ? Colors.red : color,
              borderRadius: BorderRadius.circular(AppConstants.mediumRadius),
              boxShadow: [
                BoxShadow(
                  color: (isWrong ? Colors.red : color).withValues(alpha: 0.4),
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

  void _showGameOverDialog(
    BuildContext context,
    ColorHuntGameState gameState,
    ColorHuntProvider provider,
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
            title: 'game_over'.tr(),
            score: finalScore,
            isWin: false,
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

  void _showTimeUpDialog(
    BuildContext context,
    ColorHuntGameState gameState,
    ColorHuntProvider provider,
  ) {
    final finalScore = gameState.score;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return PopScope(
          canPop: false,
          child: TimeUpDialog(
            score: finalScore,
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

  Widget _buildBottomActions(
    BuildContext context,
    ColorHuntGameState gameState,
    ColorHuntProvider provider,
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
  bool _isPressed = false;

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
      setState(() {
        _isPressed = true;
      });
      _controller.forward();
    }
  }

  void _onTapUp() {
    if (widget.onTap != null) {
      setState(() {
        _isPressed = false;
      });
      _controller.reverse();
      widget.onTap!();
    }
  }

  void _onTapCancel() {
    if (widget.onTap != null) {
      setState(() {
        _isPressed = false;
      });
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
              child: AnimatedScale(
                duration: const Duration(milliseconds: 100),
                scale: _isPressed ? 0.9 : 1.0,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: widget.isWrong ? Colors.red : widget.color,
                    borderRadius: BorderRadius.circular(
                      AppConstants.mediumRadius,
                    ),
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
