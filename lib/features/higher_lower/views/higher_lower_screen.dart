import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../shared/widgets/game_screen_base.dart';
import '../../../shared/widgets/game_over_dialog.dart';
import '../../../shared/models/higher_lower_game_state.dart';
import '../providers/higher_lower_provider.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/text_theme_manager.dart';

class HigherLowerScreen extends StatelessWidget {
  const HigherLowerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HigherLowerProvider(),
      child: const _HigherLowerView(),
    );
  }
}

class _HigherLowerView extends StatelessWidget {
  const _HigherLowerView();

  @override
  Widget build(BuildContext context) {
    return Consumer<HigherLowerProvider>(
      builder: (context, provider, child) {
        final gameState = provider.gameState;

        // Show game over dialog when needed
        if (gameState.showGameOver) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _showGameOverDialog(context, gameState, provider);
          });
        }

        return GameScreenBase(
          title: 'higher_lower',
          descriptionKey: 'higher_lower_description',
          gameId: 'higher_lower',
          bottomActions: _buildBottomActions(context, gameState, provider),
          child: _buildGameContent(context, gameState, provider),
        );
      },
    );
  }

  Widget _buildGameContent(
    BuildContext context,
    HigherLowerGameState gameState,
    HigherLowerProvider provider,
  ) {
    return Opacity(
      opacity: gameState.isWaiting ? 0.4 : 1.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Sabit sayı gösterimi alanı
          _buildNumberDisplayArea(context, gameState, provider),

          const SizedBox(height: AppConstants.extraLargeSpacing),

          // Sabit oyun butonları alanı
          _buildGameButtonsArea(context, gameState, provider),

          // Dinamik içerik alanı (skor gösterimi, uyarı mesajları)
          Expanded(child: _buildDynamicContent(context, gameState, provider)),
        ],
      ),
    );
  }

  Widget _buildNumberDisplayArea(
    BuildContext context,
    HigherLowerGameState gameState,
    HigherLowerProvider provider,
  ) {
    return Container(
      constraints: const BoxConstraints(
        maxWidth: 300, // Maksimum genişlik
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Skor rozeti
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
            width: 120,
            height: 120,
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
            child: Center(child: _buildNumberContent(context, gameState)),
          ),
          const SizedBox(height: AppConstants.smallSpacing),
        ],
      ),
    );
  }

  Color _getNumberDisplayColor(
    BuildContext context,
    HigherLowerGameState gameState,
  ) {
    if (gameState.isWaiting) {
      return Theme.of(context).colorScheme.primary;
    }
    return AppTheme.darkWarning;
  }

  Widget _buildNumberContent(
    BuildContext context,
    HigherLowerGameState gameState,
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
              gameState.isAnimating
                  ? gameState.animatedNumber.toString()
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

  Widget _buildGameButtonsArea(
    BuildContext context,
    HigherLowerGameState gameState,
    HigherLowerProvider provider,
  ) {
    return Container(
      constraints: const BoxConstraints(
        maxWidth: 350, // Maksimum genişlik
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Lower Button
          Expanded(
            child: _buildModernGameButton(
              context,
              'lower'.tr(),
              Icons.keyboard_arrow_down_rounded,
              AppTheme.darkError,
              gameState.isGameActive && !gameState.isAnimating
                  ? () => provider.guessLower()
                  : null,
            ),
          ),

          const SizedBox(width: AppConstants.mediumSpacing),

          // Higher Button
          Expanded(
            child: _buildModernGameButton(
              context,
              'higher'.tr(),
              Icons.keyboard_arrow_up_rounded,
              AppTheme.darkSuccess,
              gameState.isGameActive && !gameState.isAnimating
                  ? () => provider.guessHigher()
                  : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernGameButton(
    BuildContext context,
    String text,
    IconData icon,
    Color color,
    VoidCallback? onPressed,
  ) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 150),
      tween: Tween(begin: 1.0, end: onPressed != null ? 1.0 : 0.6),
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Container(
            height: 70,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [color, color.withValues(alpha: 0.8)],
              ),
              borderRadius: BorderRadius.circular(AppConstants.mediumRadius),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.4),
                  blurRadius: 12,
                  spreadRadius: 0,
                  offset: const Offset(0, 4),
                ),
                BoxShadow(
                  color: color.withValues(alpha: 0.2),
                  blurRadius: 20,
                  spreadRadius: 0,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onPressed,
                borderRadius: BorderRadius.circular(AppConstants.mediumRadius),
                splashColor: Colors.white.withValues(alpha: 0.3),
                highlightColor: Colors.white.withValues(alpha: 0.1),
                child: _ModernButtonContent(
                  text: text,
                  icon: icon,
                  onPressed: onPressed,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDynamicContent(
    BuildContext context,
    HigherLowerGameState gameState,
    HigherLowerProvider provider,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Skor gösterimi kaldırıldı
        // const SizedBox(height: AppConstants.largeSpacing),
        const SizedBox(height: AppConstants.largeSpacing),
        // Oyun durumu mesajları (opsiyonel)
      ],
    );
  }

  Widget _buildScoreDisplay(
    BuildContext context,
    HigherLowerGameState gameState,
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
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
            blurRadius: 8,
            spreadRadius: 0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.emoji_events_rounded,
            color: Theme.of(context).colorScheme.primary,
            size: 24,
          ),
          const SizedBox(width: AppConstants.smallSpacing),
          Text(
            '${'score'.tr()}: ${gameState.score}',
            style: TextThemeManager.gameScorePrimary(context),
          ),
        ],
      ),
    );
  }

  void _showGameOverDialog(
    BuildContext context,
    HigherLowerGameState gameState,
    HigherLowerProvider provider,
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
            subtitle: 'better_luck_next_time'.tr(),
            score: finalScore,
            isWin: false,
            losingNumber:
                gameState.previousNumber != null &&
                        gameState.currentNumber != null
                    ? '${gameState.previousNumber} → ${gameState.currentNumber}'
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

  Widget _buildBottomActions(
    BuildContext context,
    HigherLowerGameState gameState,
    HigherLowerProvider provider,
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

class _ModernButtonContent extends StatefulWidget {
  final String text;
  final IconData icon;
  final VoidCallback? onPressed;

  const _ModernButtonContent({
    required this.text,
    required this.icon,
    required this.onPressed,
  });

  @override
  State<_ModernButtonContent> createState() => _ModernButtonContentState();
}

class _ModernButtonContentState extends State<_ModernButtonContent>
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
    if (widget.onPressed != null) {
      setState(() {
        _isPressed = true;
      });
      _controller.forward();
    }
  }

  void _onTapUp() {
    if (widget.onPressed != null) {
      setState(() {
        _isPressed = false;
      });
      _controller.reverse();
      widget.onPressed!();
    }
  }

  void _onTapCancel() {
    if (widget.onPressed != null) {
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
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.mediumSpacing,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedScale(
                    duration: const Duration(milliseconds: 100),
                    scale: _isPressed ? 0.9 : 1.0,
                    child: Icon(widget.icon, color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: AppConstants.smallSpacing),
                  AnimatedScale(
                    duration: const Duration(milliseconds: 100),
                    scale: _isPressed ? 0.95 : 1.0,
                    child: Text(
                      widget.text,
                      style: TextThemeManager.buttonMedium.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
