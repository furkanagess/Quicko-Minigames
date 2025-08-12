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
      duration: const Duration(milliseconds: 1500),
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

    // Add a delay to make the flip more noticeable and understandable
    Future.delayed(const Duration(milliseconds: 300), () {
      // Flip animasyonunu başlat
      _flipController.forward();
    });

    // Skor animasyonunu başlat - after flip completes
    Future.delayed(const Duration(milliseconds: 900), () {
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
    return AnimatedBuilder(
      animation: _flipAnimation,
      builder: (context, child) {
        final flipValue = _flipAnimation.value;
        final isFlipped = flipValue > 0.5;

        // Add scale effect during flip - modern and subtle
        final scale = 1.0 + (flipValue * 0.03); // Scale up to 1.03 during flip

        // Add bounce effect - modern and subtle
        final bounce =
            flipValue > 0.5 ? (1.0 - flipValue) * 0.03 : flipValue * 0.03;

        // Add flash effect during the middle of the flip - modern and subtle
        final flashOpacity = flipValue > 0.48 && flipValue < 0.52 ? 0.1 : 0.0;

        return Stack(
          children: [
            // Flash effect
            if (flashOpacity > 0)
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: flashOpacity),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            // Main flip content
            Transform(
              alignment: Alignment.center,
              transform:
                  Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..rotateY(flipValue * 3.14159)
                    ..scale(scale + bounce),
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()..rotateY(isFlipped ? 3.14159 : 0),
                child: isFlipped ? _buildGameResult() : widget.child,
              ),
            ),
          ],
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
        result.customIcon != null
            ? IconData(
              int.parse(result.customIcon!),
              fontFamily: 'MaterialIcons',
            )
            : (result.isWin
                ? AppIcons.trophy
                : Icons.sentiment_dissatisfied_rounded);

    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Theme.of(context).colorScheme.surface,
            Theme.of(context).colorScheme.surface.withValues(alpha: 0.98),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: accentColor.withValues(alpha: 0.3),
          width: 2.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 25,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: accentColor.withValues(alpha: 0.12),
            blurRadius: 40,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Modern header with animated icon and title
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  accentColor.withValues(alpha: 0.15),
                  accentColor.withValues(alpha: 0.08),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: accentColor.withValues(alpha: 0.2),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: accentColor.withValues(alpha: 0.1),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: [
                // Animated icon container
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [accentColor, accentColor.withValues(alpha: 0.8)],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: accentColor.withValues(alpha: 0.4),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Icon(icon, color: Colors.white, size: 32),
                ),
                const SizedBox(width: 20),
                // Title and subtitle
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        result.title,
                        style: TextThemeManager.screenTitle.copyWith(
                          color: accentColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                      if (result.subtitle != null) ...[
                        const SizedBox(height: 6),
                        Text(
                          result.subtitle!,
                          style: TextThemeManager.bodyMedium.copyWith(
                            color: accentColor.withValues(alpha: 0.9),
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Modern score display with animation
          AnimatedBuilder(
            animation: _scoreAnimation,
            builder: (context, child) {
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.12),
                      Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.06),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.2),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.15),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Animated trophy icon
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Theme.of(context).colorScheme.primary,
                            Theme.of(
                              context,
                            ).colorScheme.primary.withValues(alpha: 0.8),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(
                              context,
                            ).colorScheme.primary.withValues(alpha: 0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        AppIcons.trophy,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Score content
                    Column(
                      children: [
                        Text(
                          AppLocalizations.of(context)!.score,
                          style: TextThemeManager.bodyMedium.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          (result.score * _scoreAnimation.value)
                              .round()
                              .toString(),
                          style: TextThemeManager.gameNumber.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),

          // Loss reason section (only show when game is lost)
          if (!result.isWin && result.lossReason != null) ...[
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppTheme.darkError.withValues(alpha: 0.08),
                    AppTheme.darkError.withValues(alpha: 0.04),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppTheme.darkError.withValues(alpha: 0.2),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.darkError.withValues(alpha: 0.1),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppTheme.darkError.withValues(alpha: 0.15),
                          AppTheme.darkError.withValues(alpha: 0.08),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.darkError.withValues(alpha: 0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.info_outline_rounded,
                      color: AppTheme.darkError,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          LocalizationUtils.getStringWithContext(
                            context,
                            'whyYouLost',
                          ),
                          style: TextThemeManager.bodySmall.copyWith(
                            color: AppTheme.darkError.withValues(alpha: 0.8),
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          result.lossReason!,
                          style: TextThemeManager.bodyMedium.copyWith(
                            color: AppTheme.darkError,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 12),

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

  Widget _buildAdditionalField(BuildContext context, GameResultField field) {
    final fieldColor = field.color ?? Theme.of(context).colorScheme.primary;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            fieldColor.withValues(alpha: 0.1),
            fieldColor.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: fieldColor.withValues(alpha: 0.15),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: fieldColor.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          if (field.icon != null) ...[
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: fieldColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(field.icon, color: fieldColor, size: 20),
            ),
            const SizedBox(width: 12),
          ],
        ],
      ),
    );
  }

  Widget _buildCompactField(BuildContext context, GameResultField field) {
    final fieldColor = field.color ?? Theme.of(context).colorScheme.primary;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            fieldColor.withValues(alpha: 0.1),
            fieldColor.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: fieldColor.withValues(alpha: 0.15), width: 1),
      ),
      child: Row(
        children: [
          if (field.icon != null) ...[
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: fieldColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(field.icon, color: fieldColor, size: 16),
            ),
            const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }

  Widget _buildModernField(BuildContext context, GameResultField field) {
    final fieldColor = field.color ?? Theme.of(context).colorScheme.primary;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            fieldColor.withValues(alpha: 0.08),
            fieldColor.withValues(alpha: 0.04),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: fieldColor.withValues(alpha: 0.15),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          if (field.icon != null) ...[
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    fieldColor.withValues(alpha: 0.2),
                    fieldColor.withValues(alpha: 0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: fieldColor.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(field.icon, color: fieldColor, size: 20),
            ),
            const SizedBox(width: 14),
          ],
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
