import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/app_icons.dart';
import '../../core/theme/app_theme.dart';
import '../../core/routes/app_router.dart';
import '../../core/theme/text_theme_manager.dart';
import '../../core/utils/sound_utils.dart';
import '../../core/utils/global_context.dart';
import '../../features/favorites/providers/favorites_provider.dart';
import '../../l10n/app_localizations.dart';
import 'continue_game_dialog.dart';
import 'game_action_button.dart';
import 'game_in_progress_dialog.dart';

class GameScreenBase extends StatefulWidget {
  final String title;
  final String descriptionKey;
  final String gameId;
  final Widget child;
  final Widget? descriptionIcon;
  final bool isWaiting;
  final GameResult? gameResult;
  final VoidCallback? onTryAgain;
  final VoidCallback? onBackToMenu;
  final VoidCallback? onStartGame;
  final VoidCallback? onResetGame;
  final Future<bool> Function()? onContinueGame;
  final Future<bool> Function()? canContinueGame;
  final VoidCallback? onGameResultCleared;
  final bool isGameInProgress;
  final VoidCallback? onPauseGame;
  final VoidCallback? onResumeGame;

  const GameScreenBase({
    super.key,
    required this.title,
    required this.descriptionKey,
    required this.gameId,
    required this.child,
    this.descriptionIcon,
    this.isWaiting = false,
    this.gameResult,
    this.onTryAgain,
    this.onBackToMenu,
    this.onStartGame,
    this.onResetGame,
    this.onContinueGame,
    this.canContinueGame,
    this.onGameResultCleared,
    this.isGameInProgress = false,
    this.onPauseGame,
    this.onResumeGame,
  });

  @override
  State<GameScreenBase> createState() => _GameScreenBaseState();
}

class GameResult {
  final bool isWin;
  final int score;
  final String? subtitle;
  final String title;
  final String? customIcon;
  final String? lossReason; // New field for explaining why player lost

  const GameResult({
    required this.isWin,
    required this.score,
    this.subtitle,
    required this.title,
    this.customIcon,
    this.lossReason,
  });
}

class GameResultField {
  final String label;
  final IconData? icon;
  final Color? color;

  const GameResultField({required this.label, this.icon, this.color});
}

class _GameScreenBaseState extends State<GameScreenBase>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));

    _fadeController.forward();
    _slideController.forward();

    // Eğer game result varsa, continue dialog'unu göster
    if (widget.gameResult != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showContinueDialog();
      });
    }
  }

  @override
  void didUpdateWidget(GameScreenBase oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.gameResult != null && oldWidget.gameResult == null) {
      _showContinueDialog();
    }
  }

  void _showContinueDialog() {
    // Ses çal
    if (widget.gameResult!.isWin) {
      SoundUtils.playWinnerSound();
    } else {
      SoundUtils.playGameOverSound();
    }

    // Continue dialog'unu göster
    Future.delayed(const Duration(milliseconds: 500), () {
      if (context.mounted) {
        _checkAndShowContinueDialog(context);
      }
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  String _getLocalizedTitle(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    switch (widget.title) {
      case 'pattern_memory':
        return localizations.patternMemory;
      case 'blind_sort':
        return localizations.blindSort;
      case 'higher_lower':
        return localizations.higherLower;
      case 'color_hunt':
        return localizations.colorHunt;
      case 'aim_trainer':
        return localizations.aimTrainer;
      case 'number_memory':
        return localizations.numberMemory;
      case 'find_difference':
        return localizations.findDifference;
      case 'rock_paper_scissors':
        return localizations.rockPaperScissors;
      case 'twenty_one':
        return localizations.twentyOne;
      case 'reaction_time':
        return localizations.reactionTime;
      default:
        return widget.title;
    }
  }

  String _getLocalizedDescription(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    switch (widget.descriptionKey) {
      case 'pattern_memory_description':
        return localizations.patternMemoryDescription;
      case 'blind_sort_description':
        return localizations.blindSortDescription;
      case 'higher_lower_description':
        return localizations.higherLowerDescription;
      case 'color_hunt_description':
        return localizations.colorHuntDescription;
      case 'aim_trainer_description':
        return localizations.aimTrainerDescription;
      case 'number_memory_description':
        return localizations.numberMemoryDescription;
      case 'find_difference_description':
        return localizations.findDifferenceDescription;
      case 'rock_paper_scissors_description':
        return localizations.rockPaperScissorsDescription;
      case 'twenty_one_description':
        return localizations.twentyOneDescription;
      case 'reactionTimeDescription':
        return localizations.reactionTimeDescription;
      default:
        return widget.descriptionKey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: _buildAppBar(),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.mediumSpacing,
                vertical: AppConstants.smallSpacing,
              ),
              child: Column(
                children: [
                  // Game description - SABİT
                  if (widget.descriptionIcon != null)
                    _buildGameDescription()
                  else
                    _buildSimpleDescription(),

                  const SizedBox(height: AppConstants.largeSpacing),

                  // Main game content - FLIP ANİMASYONU SADECE BURADA
                  Expanded(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxWidth: 500,
                            maxHeight: 600, // Rapor için daha az yer
                          ),
                          child: AnimatedOpacity(
                            duration: const Duration(milliseconds: 200),
                            opacity: widget.isWaiting ? 0.5 : 1.0,
                            child: IgnorePointer(
                              ignoring: widget.isWaiting,
                              child: _buildFlipContent(),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Bottom actions - SABİT (her zaman göster)
                  const SizedBox(height: AppConstants.mediumSpacing),
                  _buildBottomActions(context),
                  const SizedBox(height: AppConstants.smallSpacing),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFlipContent() {
    // Simple content without flip animation
    return widget.child;
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(
        _getLocalizedTitle(context),
        style: TextThemeManager.appBarTitle.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
      foregroundColor: Theme.of(context).colorScheme.onPrimary,
      elevation: 0,
      centerTitle: true,
      actions: [
        // Favori butonu (sadece gameId varsa göster)
        if (widget.gameId != null)
          Consumer<FavoritesProvider>(
            builder: (context, favoritesProvider, child) {
              return Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: IconButton(
                  onPressed:
                      () => favoritesProvider.toggleFavorite(widget.gameId!),
                  icon: Icon(
                    favoritesProvider.isFavorite(widget.gameId!)
                        ? AppIcons.favoriteFilled
                        : AppIcons.favoriteOutline,
                    color:
                        favoritesProvider.isFavorite(widget.gameId!)
                            ? AppTheme.darkError
                            : Colors.white,
                  ),
                ),
              );
            },
          ),
        // Diğer action'lar kaldırıldı
      ],
      leading: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: IconButton(
          onPressed: () => _handleBackButtonPress(context),
          icon: const Icon(AppIcons.back, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildBottomActions(BuildContext context) {
    return GameActionButton(
      isWaiting: widget.isWaiting,
      onPressed: () {
        if (widget.gameResult != null) {
          // Check if game can be continued
          _checkAndShowContinueDialog(context);
        } else if (widget.isWaiting) {
          // Oyun bekliyor, start game
          widget.onStartGame?.call();
        } else {
          // Oyun aktif, reset game
          widget.onResetGame?.call();
        }
      },
    );
  }

  Future<void> _checkAndShowContinueDialog(BuildContext context) async {
    debugPrint('GameScreenBase: Checking if continue game is available...');

    // Check if continue game is available
    if (widget.canContinueGame != null && widget.onContinueGame != null) {
      final canContinue = await widget.canContinueGame!();

      if (context.mounted) {
        debugPrint(
          'GameScreenBase: Showing continue game dialog (canContinue=$canContinue)',
        );

        // Show continue game dialog always; button visibility handled inside
        showDialog(
          context: context,
          barrierDismissible: false,
          builder:
              (context) => ContinueGameDialog(
                gameId: widget.gameId,
                gameTitle: _getLocalizedTitle(context),
                currentScore: widget.gameResult?.score ?? 0,
                onContinue: () async {
                  debugPrint('GameScreenBase: User chose to continue game');
                  final success = await widget.onContinueGame!();
                  if (success) {
                    debugPrint('GameScreenBase: Continue game successful');
                    // Don't call onGameResultCleared when continue is successful
                    // because the game should continue from where it left off
                  } else {
                    debugPrint('GameScreenBase: Continue game failed');
                  }
                },
                onRestart: () {
                  debugPrint('GameScreenBase: User chose to restart game');
                  widget.onTryAgain?.call();
                },
                onExit: () {
                  debugPrint('GameScreenBase: User chose to exit game');
                  widget.onBackToMenu?.call();
                },
                canOneTimeContinue: canContinue,
              ),
        );
      }
    } else {
      debugPrint(
        'GameScreenBase: No continue game support, using normal try again',
      );
      // No continue game support, use normal try again
      widget.onTryAgain?.call();
    }
  }

  void _handleBackButtonPress(BuildContext context) async {
    if (widget.isGameInProgress) {
      // Pause the game when dialog shows
      widget.onPauseGame?.call();

      // Show game in progress dialog
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder:
            (context) => GameInProgressDialog(
              onStayInGame: () {
                // Resume the game when staying
                widget.onResumeGame?.call();
              },
              onExitGame: () {
                // Clean up game state first
                widget.onGameResultCleared?.call();

                // Exit like normal back button (dialog will close automatically)
                AppRouter.pop(context); // Exit game like normal back button
              },
            ),
      );
    } else {
      // No game in progress, exit normally
      AppRouter.pop(context);
    }
  }

  Widget _buildGameDescription() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppConstants.mediumSpacing),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
            Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(AppConstants.largeRadius),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.8),
                ],
              ),
              borderRadius: BorderRadius.circular(AppConstants.mediumRadius),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(child: widget.descriptionIcon!),
          ),
          const SizedBox(width: AppConstants.mediumSpacing),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getLocalizedDescription(context),
                  style: TextThemeManager.bodyMedium.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSimpleDescription() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.mediumSpacing,
        vertical: AppConstants.smallSpacing,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
            Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        _getLocalizedDescription(context),
        style: TextThemeManager.bodyMedium.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
