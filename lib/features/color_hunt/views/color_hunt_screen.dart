import 'package:flutter/material.dart';
import 'package:quicko_app/core/constants/app_icons.dart';
import 'package:quicko_app/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/text_theme_manager.dart';
import '../../../shared/widgets/game_screen_base.dart';
import '../models/color_hunt_game_state.dart';
import '../providers/color_hunt_provider.dart';

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
          // Color Hunt doesn't have a win condition, only game over
          final isWin = false; // Always false since there's no win condition
          gameResult = GameResult(
            isWin: isWin,
            score: gameState.score,
            title: AppLocalizations.of(context)!.gameOver,
            lossReason: AppLocalizations.of(context)!.wrongColorSelection,
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
          onContinueGame: () => provider.continueGame(),
          canContinueGame: () => provider.canContinueGame(),
          onGameResultCleared: () {
            provider.cleanupGame();
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

  String _getLocalizedColorName(BuildContext context, String? colorKey) {
    if (colorKey == null) return '';

    switch (colorKey) {
      case 'red':
        return AppLocalizations.of(context)!.red;
      case 'green':
        return AppLocalizations.of(context)!.green;
      case 'blue':
        return AppLocalizations.of(context)!.blue;
      case 'purple':
        return AppLocalizations.of(context)!.purple;
      case 'orange':
        return AppLocalizations.of(context)!.orange;
      case 'yellow':
        return AppLocalizations.of(context)!.yellow;
      case 'pink':
        return AppLocalizations.of(context)!.pink;
      case 'brown':
        return AppLocalizations.of(context)!.brown;
      case 'cyan':
        return AppLocalizations.of(context)!.cyan;
      case 'lime':
        return AppLocalizations.of(context)!.lime;
      case 'magenta':
        return AppLocalizations.of(context)!.magenta;
      case 'teal':
        return AppLocalizations.of(context)!.teal;
      case 'indigo':
        return AppLocalizations.of(context)!.indigo;
      case 'amber':
        return AppLocalizations.of(context)!.amber;
      case 'deep_purple':
        return AppLocalizations.of(context)!.deep_purple;
      case 'light_blue':
        return AppLocalizations.of(context)!.light_blue;
      default:
        return colorKey;
    }
  }

  Widget _buildScoreTimeDisplay(
    BuildContext context,
    ColorHuntGameState gameState,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.mediumSpacing,
        vertical: AppConstants.smallSpacing,
      ),
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppConstants.mediumRadius),
        border: Border.all(
          color: colorScheme.primary.withValues(alpha: 0.25),
          width: 1,
        ),
      ),
      child: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: AppConstants.mediumSpacing,
        runSpacing: AppConstants.smallSpacing,
        children: [
          _InfoPill(
            icon: AppIcons.score,
            label: AppLocalizations.of(context)!.score,
            value: '${gameState.score}',
            color: colorScheme.primary,
          ),
          _InfoPill(
            icon: AppIcons.timer,
            label: AppLocalizations.of(context)!.time,
            value: '${gameState.timeLeft}s',
            color: colorScheme.primary,
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
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            spreadRadius: 0,
            offset: const Offset(0, 2),
          ),
        ],
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
          _AnimatedTargetText(
            colorName: _getLocalizedColorName(
              context,
              gameState.targetColorKey,
            ),
            textColor: gameState.textColor,
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
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate box size based on available width
        final availableWidth = constraints.maxWidth;
        final boxSize =
            (availableWidth - 60) / 4; // 60px for spacing (15px * 4)
        final finalBoxSize = boxSize.clamp(70.0, 90.0); // Min 70px, max 90px

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(4, (index) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: _buildColorBox(
                  context,
                  gameState.availableColors[index],
                  index,
                  gameState.wrongTapIndex == index,
                  gameState.isGameActive,
                  () => provider.onColorTap(index),
                  boxSize: finalBoxSize,
                ),
              );
            }),
          ),
        );
      },
    );
  }

  Widget _buildColorBox(
    BuildContext context,
    Color color,
    int index,
    bool isWrong,
    bool isActive,
    VoidCallback? onTap, {
    double boxSize = 100,
  }) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 150),
      tween: Tween(begin: 1.0, end: onTap != null ? 1.0 : 0.6),
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Container(
            width: boxSize,
            height: boxSize,
            decoration: BoxDecoration(
              color: color, // Always use the original color
              borderRadius: BorderRadius.circular(AppConstants.mediumRadius),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(
                    alpha: 0.6, // Increased shadow opacity
                  ), // Use original color for shadow
                  blurRadius: 12, // Increased blur radius
                  spreadRadius: 2, // Added spread radius
                  offset: const Offset(0, 4), // Increased offset
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 4,
                  spreadRadius: 0,
                  offset: const Offset(0, 2),
                ),
              ],
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.2),
                width: 2,
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(AppConstants.mediumRadius),
                splashColor: Colors.white.withValues(alpha: 0.4),
                highlightColor: Colors.white.withValues(alpha: 0.2),
                child: _AnimatedColorBoxContent(
                  color: color,
                  onTap: onTap,
                  boxSize: boxSize,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _InfoPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _InfoPill({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.25), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 6),
          Text(
            '$label:',
            style: TextThemeManager.bodySmall.copyWith(
              color: onSurface.withValues(alpha: 0.75),
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            value,
            overflow: TextOverflow.ellipsis,
            style: TextThemeManager.subtitleMedium.copyWith(
              color: onSurface,
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

class _AnimatedColorBoxContent extends StatefulWidget {
  final Color color;
  final VoidCallback? onTap;
  final double boxSize;

  const _AnimatedColorBoxContent({
    required this.color,
    required this.onTap,
    this.boxSize = 100,
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
                width: widget.boxSize,
                height: widget.boxSize,
                decoration: BoxDecoration(
                  color: widget.color, // Always use the original color
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

class _AnimatedTargetText extends StatefulWidget {
  final String colorName;
  final Color textColor;

  const _AnimatedTargetText({required this.colorName, required this.textColor});

  @override
  State<_AnimatedTargetText> createState() => _AnimatedTargetTextState();
}

class _AnimatedTargetTextState extends State<_AnimatedTargetText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.mediumSpacing,
              vertical: AppConstants.smallSpacing,
            ),
            decoration: BoxDecoration(
              color: widget.textColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppConstants.smallRadius),
              border: Border.all(
                color: widget.textColor.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Text(
              widget.colorName,
              style: TextThemeManager.gameNumber.copyWith(
                fontSize: 36,
                color: widget.textColor,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    offset: const Offset(1, 1),
                    blurRadius: 2,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
