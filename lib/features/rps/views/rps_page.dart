import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quicko_app/l10n/app_localizations.dart';
import '../../../shared/widgets/game_screen_base.dart';
import '../../../shared/widgets/game_action_button.dart';
import '../../../shared/models/game_state.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_icons.dart';
import '../../../core/theme/app_theme.dart';
import '../providers/rps_provider.dart';
import '../models/rps_game_state.dart';

class RpsPage extends StatelessWidget {
  const RpsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RpsProvider(),
      child: const _RpsView(),
    );
  }
}

class _RpsView extends StatelessWidget {
  const _RpsView();

  @override
  Widget build(BuildContext context) {
    return Consumer<RpsProvider>(
      builder: (context, provider, child) {
        final state = provider.state;

        // Create game result when game is over
        GameResult? gameResult;
        if (state.showGameOver) {
          gameResult = GameResult(
            isWin: state.youWon,
            score: state.youScore,
            title:
                state.youWon
                    ? AppLocalizations.of(context)!.congratulations
                    : AppLocalizations.of(context)!.gameOver,
            subtitle:
                state.youWon
                    ? AppLocalizations.of(context)!.youWonTheGame
                    : AppLocalizations.of(context)!.betterLuckNextTime,
            lossReason:
                state.youWon
                    ? null
                    : AppLocalizations.of(context)!.betterLuckNextTime,
          );
        }

        return GameScreenBase(
          title: 'rock_paper_scissors',
          descriptionKey: 'rock_paper_scissors_description',
          gameId: 'rps',
          gameResult: gameResult,
          onTryAgain: () {
            provider.reset();
          },
          onContinueGame: () => provider.continueGame(),
          canContinueGame: () => provider.canContinueGame(),
          onBackToMenu: () {
            Navigator.of(context).pop();
          },
          onStartGame: () {
            provider.start();
          },
          onResetGame: () {
            provider.reset();
          },
          isWaiting: state.isWaiting,
          child: _buildGameContent(context, state, provider),
        );
      },
    );
  }

  String _getLocalizedBannerText(BuildContext context, String? bannerTextKey) {
    final localizations = AppLocalizations.of(context)!;
    switch (bannerTextKey) {
      case 'youWin':
        return localizations.youWin;
      case 'youLose':
        return localizations.youLose;
      case 'tie':
        return localizations.tie;
      default:
        return '';
    }
  }

  Widget _buildGameContent(
    BuildContext context,
    RpsGameState state,
    RpsProvider provider,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Score cards
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Row(
            children: [
              Expanded(
                child: _ScoreCard(
                  title: AppLocalizations.of(context)!.you,
                  emoji: _emojiFor(state.playerPick, false, state.cpuAnimEmoji),
                  score: state.youScore,
                  accent: AppTheme.darkSuccess,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ScoreCard(
                  title: AppLocalizations.of(context)!.cpu,
                  emoji:
                      state.isCpuAnimating
                          ? state.cpuAnimEmoji
                          : _emojiFor(state.cpuPick, true, '❓'),
                  score: state.cpuScore,
                  accent: AppTheme.darkError,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: AppConstants.largeSpacing),

        // Banner message
        if (state.showBanner)
          AnimatedOpacity(
            opacity: state.showBanner ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 200),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppTheme.darkPrimary.withValues(alpha: 0.15),
                    AppTheme.darkPrimary.withValues(alpha: 0.08),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppTheme.darkPrimary.withValues(alpha: 0.3),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.darkPrimary.withValues(alpha: 0.2),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    state.bannerTextKey == 'youWin'
                        ? Icons.celebration_rounded
                        : state.bannerTextKey == 'youLose'
                        ? Icons.sentiment_dissatisfied_rounded
                        : Icons.handshake_rounded,
                    color: AppTheme.darkPrimary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _getLocalizedBannerText(context, state.bannerTextKey),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.darkPrimary,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ),

        const SizedBox(height: AppConstants.largeSpacing),

        // Choice buttons
        if (!state.isWaiting)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _ChoiceButton(
                emoji: '✊',
                onTap:
                    state.isPlayerSelectionLocked
                        ? null
                        : () => provider.onPick(RpsChoice.rock),
                isDisabled: state.isPlayerSelectionLocked,
              ),
              _ChoiceButton(
                emoji: '✋',
                onTap:
                    state.isPlayerSelectionLocked
                        ? null
                        : () => provider.onPick(RpsChoice.paper),
                isDisabled: state.isPlayerSelectionLocked,
              ),
              _ChoiceButton(
                emoji: '✌️',
                onTap:
                    state.isPlayerSelectionLocked
                        ? null
                        : () => provider.onPick(RpsChoice.scissors),
                isDisabled: state.isPlayerSelectionLocked,
              ),
            ],
          ),
      ],
    );
  }

  String _emojiFor(RpsChoice? choice, bool isCpu, String animEmoji) {
    if (choice == null) return '❓';
    switch (choice) {
      case RpsChoice.rock:
        return '✊';
      case RpsChoice.paper:
        return '✋';
      case RpsChoice.scissors:
        return '✌️';
    }
  }
}

class _ScoreCard extends StatelessWidget {
  final String title;
  final String emoji;
  final int score;
  final Color accent;

  const _ScoreCard({
    required this.title,
    required this.emoji,
    required this.score,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.surface,
            Theme.of(context).colorScheme.surface.withValues(alpha: 0.95),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: accent.withValues(alpha: 0.3), width: 2),
        boxShadow: [
          BoxShadow(
            color: accent.withValues(alpha: 0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Title and Score
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: accent,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: accent.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Text(
                  score.toString(),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: accent,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Emoji with enhanced styling
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: accent.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Text(emoji, style: const TextStyle(fontSize: 36)),
          ),
        ],
      ),
    );
  }
}

class _ChoiceButton extends StatefulWidget {
  final String emoji;
  final VoidCallback? onTap;
  final bool isDisabled;

  const _ChoiceButton({
    required this.emoji,
    required this.onTap,
    this.isDisabled = false,
  });

  @override
  State<_ChoiceButton> createState() => _ChoiceButtonState();
}

class _ChoiceButtonState extends State<_ChoiceButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _elevationAnimation = Tween<double>(begin: 8.0, end: 2.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    setState(() {
      _isPressed = true;
    });
    _animationController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    setState(() {
      _isPressed = false;
    });
    _animationController.reverse();
  }

  void _onTapCancel() {
    setState(() {
      _isPressed = false;
    });
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors:
                    widget.isDisabled
                        ? [
                          Colors.grey.withValues(alpha: 0.1),
                          Colors.grey.withValues(alpha: 0.05),
                        ]
                        : [
                          Theme.of(
                            context,
                          ).colorScheme.primary.withValues(alpha: 0.1),
                          Theme.of(
                            context,
                          ).colorScheme.primary.withValues(alpha: 0.05),
                        ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color:
                    widget.isDisabled
                        ? Colors.grey.withValues(alpha: 0.3)
                        : Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: 0.3),
                width: 2,
              ),
              boxShadow:
                  widget.isDisabled
                      ? [
                        BoxShadow(
                          color: Colors.grey.withValues(alpha: 0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ]
                      : [
                        BoxShadow(
                          color: Theme.of(
                            context,
                          ).colorScheme.primary.withValues(alpha: 0.2),
                          blurRadius: _elevationAnimation.value,
                          offset: Offset(0, _elevationAnimation.value / 2),
                        ),
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: widget.isDisabled ? null : widget.onTap,
                onTapDown: widget.isDisabled ? null : _onTapDown,
                onTapUp: widget.isDisabled ? null : _onTapUp,
                onTapCancel: widget.isDisabled ? null : _onTapCancel,
                borderRadius: BorderRadius.circular(20),
                splashColor:
                    widget.isDisabled
                        ? Colors.transparent
                        : Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: 0.3),
                highlightColor:
                    widget.isDisabled
                        ? Colors.transparent
                        : Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: 0.1),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.emoji,
                        style: TextStyle(
                          fontSize: 36,
                          color:
                              widget.isDisabled
                                  ? Colors.grey.withValues(alpha: 0.5)
                                  : null,
                        ),
                      ),
                      const SizedBox(height: 4),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
