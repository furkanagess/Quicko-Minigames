import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:quicko_app/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:quicko_app/core/constants/app_icons.dart';
import '../../../shared/widgets/game_screen_base.dart';
import '../models/higher_lower_game_state.dart';
import '../providers/higher_lower_provider.dart';
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

        // Create game result when game is over
        GameResult? gameResult;
        if (gameState.showGameOver) {
          final isWin = gameState.status == HigherLowerGameStatus.won;
          gameResult = GameResult(
            isWin: isWin,
            score: gameState.score,
            title:
                isWin
                    ? AppLocalizations.of(context)!.congratulations
                    : AppLocalizations.of(context)!.gameOver,
            subtitle:
                isWin
                    ? AppLocalizations.of(context)!.youGuessedCorrectly
                    : null,
            lossReason:
                isWin ? null : AppLocalizations.of(context)!.betterLuckNextTime,
          );
        }

        return GameScreenBase(
          title: 'higher_lower',
          descriptionKey: 'higher_lower_description',
          gameId: 'higher_lower',
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
    );
  }

  Widget _buildGameContent(
    BuildContext context,
    HigherLowerGameState gameState,
    HigherLowerProvider provider,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          // Score Display
          _buildScoreDisplay(context, gameState),

          const SizedBox(height: 32),

          // Main Number Display
          _buildMainNumberDisplay(context, gameState),

          const SizedBox(height: 48),

          // Game Buttons
          _buildGameButtons(context, gameState, provider),

          const SizedBox(height: 32),

          // Game Status Info
        ],
      ),
    );
  }

  Widget _buildScoreDisplay(
    BuildContext context,
    HigherLowerGameState gameState,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.primary.withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(AppIcons.trophy, size: 20, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Text(
            '${AppLocalizations.of(context)!.score}: ${gameState.score}',
            style: TextThemeManager.titleMedium.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainNumberDisplay(
    BuildContext context,
    HigherLowerGameState gameState,
  ) {
    return Container(
      width: 160,
      height: 160,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _getNumberDisplayColor(context, gameState),
            _getNumberDisplayColor(context, gameState).withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(80),
        boxShadow: [
          BoxShadow(
            color: _getNumberDisplayColor(
              context,
              gameState,
            ).withValues(alpha: 0.4),
            blurRadius: 20,
            spreadRadius: 0,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: _getNumberDisplayColor(
              context,
              gameState,
            ).withValues(alpha: 0.2),
            blurRadius: 40,
            spreadRadius: 0,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: const Center(child: _NumberSpinner()),
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

  // Localized performant spinner to avoid provider-wide rebuilds

  Widget _buildGameButtons(
    BuildContext context,
    HigherLowerGameState gameState,
    HigherLowerProvider provider,
  ) {
    return Row(
      children: [
        // Lower Button
        Expanded(
          child: _buildGameButton(
            context,
            AppLocalizations.of(context)!.lower,
            AppIcons.arrowDown,
            AppTheme.darkError,
            gameState.isGameActive && !gameState.isAnimating
                ? () => provider.guessLower()
                : null,
          ),
        ),

        const SizedBox(width: 20),

        // Higher Button
        Expanded(
          child: _buildGameButton(
            context,
            AppLocalizations.of(context)!.higher,
            AppIcons.arrowUp,
            AppTheme.darkSuccess,
            gameState.isGameActive && !gameState.isAnimating
                ? () => provider.guessHigher()
                : null,
          ),
        ),
      ],
    );
  }

  Widget _buildGameButton(
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
            height: 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [color, color.withValues(alpha: 0.8)],
              ),
              borderRadius: BorderRadius.circular(20),
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
                borderRadius: BorderRadius.circular(20),
                splashColor: Colors.white.withValues(alpha: 0.3),
                highlightColor: Colors.white.withValues(alpha: 0.1),
                child: _GameButtonContent(
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
}

class _GameButtonContent extends StatefulWidget {
  final String text;
  final IconData icon;
  final VoidCallback? onPressed;

  const _GameButtonContent({
    required this.text,
    required this.icon,
    required this.onPressed,
  });

  @override
  State<_GameButtonContent> createState() => _GameButtonContentState();
}

class _GameButtonContentState extends State<_GameButtonContent>
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
    if (widget.onPressed != null) {
      _controller.forward();
    }
  }

  void _onTapUp() {
    if (widget.onPressed != null) {
      _controller.reverse();
      widget.onPressed!();
    }
  }

  void _onTapCancel() {
    if (widget.onPressed != null) {
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
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(widget.icon, color: Colors.white, size: 28),
                  const SizedBox(height: 8),
                  Text(
                    widget.text,
                    style: TextThemeManager.buttonMedium.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
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

class _NumberSpinner extends StatefulWidget {
  const _NumberSpinner();

  @override
  State<_NumberSpinner> createState() => _NumberSpinnerState();
}

class _NumberSpinnerState extends State<_NumberSpinner> {
  final Random _random = Random();
  Timer? _spinTimer;
  int _displayNumber = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncWithProvider();
  }

  @override
  void didUpdateWidget(covariant _NumberSpinner oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncWithProvider();
  }

  void _syncWithProvider() {
    final provider = Provider.of<HigherLowerProvider>(context);
    final state = provider.gameState;

    // Waiting state: no spin, show question UI handled in build
    if (state.isWaiting) {
      _stopSpin();
      return;
    }

    if (state.isAnimating) {
      _startSpin();
    } else {
      _stopSpin();
      setState(() {
        _displayNumber = state.currentNumber;
      });
    }
  }

  void _startSpin() {
    if (_spinTimer != null) return;
    // Update locally at 60hz/30hz for smoothness but low cost
    _spinTimer = Timer.periodic(const Duration(milliseconds: 50), (_) {
      setState(() {
        _displayNumber = _random.nextInt(50) + 1;
      });
    });
  }

  void _stopSpin() {
    _spinTimer?.cancel();
    _spinTimer = null;
  }

  @override
  void dispose() {
    _stopSpin();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HigherLowerProvider>(context);
    final state = provider.gameState;

    if (state.isWaiting) {
      return TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 2000),
        tween: Tween(begin: 0.0, end: 1.0),
        builder: (context, value, child) {
          return Transform.scale(
            scale: 0.8 + (0.2 * value),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(40),
              ),
              child: Icon(AppIcons.question, size: 48, color: Colors.white),
            ),
          );
        },
      );
    }

    final numberToShow =
        state.isAnimating ? _displayNumber : state.currentNumber;

    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 250),
      tween: Tween(begin: 0.9, end: 1.0),
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(40),
            ),
            child: Text(
              numberToShow.toString(),
              style: TextThemeManager.headlineSmall.copyWith(
                fontSize: 48,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }
}
