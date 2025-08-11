import 'package:flutter/material.dart';
import 'package:quicko_app/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/text_theme_manager.dart';
import '../../core/theme/app_theme.dart';
import '../../core/routes/app_router.dart';
import '../../core/constants/app_icons.dart';
import '../../core/providers/app_providers.dart';
import '../../features/favorites/providers/favorites_provider.dart';
import 'game_description.dart';
import 'game_action_button.dart';
import '../../core/utils/localization_utils.dart';
import '../../core/utils/sound_utils.dart';

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
  });

  @override
  State<GameScreenBase> createState() => _GameScreenBaseState();
}

class GameResult {
  final bool isWin;
  final int score;
  final String? losingNumber;
  final String? subtitle;
  final String title;

  const GameResult({
    required this.isWin,
    required this.score,
    this.losingNumber,
    this.subtitle,
    required this.title,
  });
}

class _GameScreenBaseState extends State<GameScreenBase>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _flipController;
  late AnimationController _scoreController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _flipAnimation;
  late Animation<double> _scoreAnimation;
  bool _showingResult = false;

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
    _flipController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _scoreController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.05),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));

    _flipAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _flipController, curve: Curves.easeInOut),
    );

    _scoreAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scoreController, curve: Curves.easeOutCubic),
    );

    _fadeController.forward();
    _slideController.forward();

    // Eğer game result varsa, flip animasyonunu başlat
    if (widget.gameResult != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showGameResult();
      });
    }
  }

  @override
  void didUpdateWidget(GameScreenBase oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.gameResult != null && oldWidget.gameResult == null) {
      _showGameResult();
    }
  }

  void _showGameResult() {
    setState(() {
      _showingResult = true;
    });

    // Ses çal
    if (widget.gameResult!.isWin) {
      SoundUtils.playWinnerSound();
    } else {
      SoundUtils.playGameOverSound();
    }

    // Flip animasyonunu başlat
    _flipController.forward();

    // Skor animasyonunu başlat
    Future.delayed(const Duration(milliseconds: 400), () {
      _scoreController.forward();
    });
  }

  void _hideGameResult() {
    _flipController.reverse();
    _scoreController.reset();
    setState(() {
      _showingResult = false;
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _flipController.dispose();
    _scoreController.dispose();
    super.dispose();
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
    return AnimatedBuilder(
      animation: _flipAnimation,
      builder: (context, child) {
        final flipValue = _flipAnimation.value;
        final isFlipped = flipValue > 0.5;

        return Transform(
          alignment: Alignment.center,
          transform:
              Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateY(flipValue * 3.14159),
          child: Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()..rotateY(isFlipped ? 3.14159 : 0),
            child: isFlipped ? _buildGameResult() : widget.child,
          ),
        );
      },
    );
  }

  Widget _buildGameResult() {
    if (widget.gameResult == null) return widget.child;

    final result = widget.gameResult!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentColor =
        result.isWin ? AppTheme.darkSuccess : AppTheme.darkError;
    final icon =
        result.isWin ? AppIcons.trophy : Icons.sentiment_dissatisfied_rounded;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            accentColor.withValues(alpha: 0.1),
            accentColor.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: accentColor.withValues(alpha: 0.2), width: 2),
        boxShadow: [
          BoxShadow(
            color: accentColor.withValues(alpha: 0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: accentColor.withValues(alpha: 0.1),
            blurRadius: 40,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Header - daha kompakt
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  accentColor.withValues(alpha: 0.15),
                  accentColor.withValues(alpha: 0.08),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [accentColor, accentColor.withValues(alpha: 0.8)],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: accentColor.withValues(alpha: 0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(icon, color: Colors.white, size: 30),
                ),
                const SizedBox(height: 12),
                Text(
                  result.title,
                  style: TextThemeManager.screenTitle.copyWith(
                    color: accentColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
                if (result.subtitle != null) ...[
                  const SizedBox(height: 6),
                  Text(
                    result.subtitle!,
                    style: TextThemeManager.bodyMedium.copyWith(
                      color: accentColor.withValues(alpha: 0.8),
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Score display - daha kompakt
          AnimatedBuilder(
            animation: _scoreAnimation,
            builder: (context, child) {
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.1),
                      Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.15),
                    width: 1.5,
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).colorScheme.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            AppIcons.trophy,
                            color: Theme.of(context).colorScheme.primary,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          AppLocalizations.of(context)!.score,
                          style: TextThemeManager.bodyMedium.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      (result.score * _scoreAnimation.value).round().toString(),
                      style: TextThemeManager.gameNumber.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          // Losing number (if provided) - daha kompakt
          if (result.losingNumber != null) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    accentColor.withValues(alpha: 0.1),
                    accentColor.withValues(alpha: 0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: accentColor.withValues(alpha: 0.15),
                  width: 1.5,
                ),
              ),
              child: Column(
                children: [
                  Text(
                    AppLocalizations.of(context)!.lastNumber,
                    style: TextThemeManager.bodySmall.copyWith(
                      color: accentColor.withValues(alpha: 0.9),
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: accentColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      result.losingNumber!,
                      style: TextThemeManager.subtitleMedium.copyWith(
                        color: accentColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 16),

          // Action buttons - kaldırıldı, bottom actions kullanılıyor
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //   children: [
          //     // Back to menu button
          //     Expanded(
          //       child: Container(
          //         height: 44,
          //         margin: const EdgeInsets.only(right: 6),
          //         decoration: BoxDecoration(
          //           color:
          //               isDark
          //                   ? Colors.white.withValues(alpha: 0.1)
          //                   : Colors.black.withValues(alpha: 0.05),
          //           borderRadius: BorderRadius.circular(12),
          //           border: Border.all(
          //             color:
          //                 isDark
          //                     ? Colors.white.withValues(alpha: 0.2)
          //                     : Colors.black.withValues(alpha: 0.1),
          //             width: 1.5,
          //           ),
          //         ),
          //         child: Material(
          //           color: Colors.transparent,
          //           child: InkWell(
          //             onTap:
          //                 widget.onBackToMenu ??
          //                 () => AppRouter.pop(context),
          //             borderRadius: BorderRadius.circular(12),
          //             child: Center(
          //               child: Row(
          //                 mainAxisAlignment: MainAxisAlignment.center,
          //                 children: [
          //                   Icon(
          //                     Icons.home_rounded,
          //                     color:
          //                         Theme.of(context).colorScheme.onSurface,
          //                     size: 18,
          //                   ),
          //                   const SizedBox(width: 6),
          //                   Text(
          //                     'Back to Menu',
          //                     style: TextThemeManager.buttonMedium
          //                         .copyWith(
          //                           color:
          //                               Theme.of(
          //                                 context,
          //                               ).colorScheme.onSurface,
          //                           fontSize: 13,
          //                         ),
          //                   ),
          //                 ],
          //               ),
          //             ),
          //           ),
          //         ),
          //       ),
          //     ),

          //     // Try again button
          //     Expanded(
          //       child: Container(
          //         height: 44,
          //         margin: const EdgeInsets.only(left: 6),
          //         decoration: BoxDecoration(
          //           gradient: LinearGradient(
          //             begin: Alignment.topLeft,
          //             end: Alignment.bottomRight,
          //             colors: [accentColor, accentColor.withValues(alpha: 0.8)],
          //           ),
          //           borderRadius: BorderRadius.circular(12),
          //           boxShadow: [
          //             BoxShadow(
          //               color: accentColor.withValues(alpha: 0.3),
          //               blurRadius: 8,
          //               offset: const Offset(0, 3),
          //             ),
          //           ],
          //         ),
          //         child: Material(
          //           color: Colors.transparent,
          //           child: InkWell(
          //             onTap: widget.onTryAgain ?? _hideGameResult,
          //             borderRadius: BorderRadius.circular(12),
          //             child: Center(
          //               child: Row(
          //                 mainAxisAlignment: MainAxisAlignment.center,
          //                 children: [
          //                   Icon(
          //                     Icons.refresh_rounded,
          //                     color: Colors.white,
          //                     size: 18,
          //                   ),
          //                   const SizedBox(width: 6),
          //                   Text(
          //                     AppLocalizations.of(context)!.tryAgain,
          //                     style: TextThemeManager.buttonMedium
          //                         .copyWith(
          //                           color: Colors.white,
          //                           fontSize: 13,
          //                         ),
          //                   ),
          //                 ],
          //               ),
          //             ),
          //           ),
          //         ),
          //       ),
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(
        LocalizationUtils.getStringWithContext(context, widget.title),
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
          onPressed: () => AppRouter.pop(context),
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
          // Rapor gösterilirken onTryAgain callback'ini kullan
          widget.onTryAgain?.call();
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
                  LocalizationUtils.getString(widget.descriptionKey),
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
        LocalizationUtils.getStringWithContext(context, widget.descriptionKey),
        style: TextThemeManager.bodyMedium.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
