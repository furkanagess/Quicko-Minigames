import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quicko_app/l10n/app_localizations.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/constants/games_config.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/text_theme_manager.dart';
import '../../../core/routes/app_router.dart';
import '../../../core/constants/app_icons.dart';
import '../widgets/game_card.dart';
import '../../favorites/providers/favorites_provider.dart';
import '../../../shared/widgets/banner_ad_widget.dart';
import '../../../shared/widgets/inline_banner_ad_widget.dart';
import '../../../shared/widgets/rating_bottom_sheet.dart';
import '../../../core/mixins/screen_animation_mixin.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin, ScreenAnimationMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: buildAnimatedBody(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.mediumSpacing),
            child: Column(
              children: [
                // Header
                _buildHeader(context),
                const SizedBox(height: AppConstants.mediumSpacing),
                // Games Grid with inline ads
                Expanded(child: _buildGamesGridWithInlineAds(context)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
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
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          // App Title with Star Icon
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    AppLocalizations.of(context)!.appName,
                    style: TextThemeManager.appTitlePrimary(context),
                  ),
                ),
                const SizedBox(width: AppConstants.smallSpacing),
                // Star Icon for Rating
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 12,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _showRatingBottomSheet,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        child: Icon(
                          Icons.star_rounded,
                          size: 24,
                          color: Colors.amber,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppConstants.smallSpacing),

          // Favorites Button
          Consumer<FavoritesProvider>(
            builder: (context, favoritesProvider, child) {
              return Stack(
                children: [
                  // Main button container
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Theme.of(context).colorScheme.surface,
                          Theme.of(
                            context,
                          ).colorScheme.surface.withValues(alpha: 0.95),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),

                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                        BoxShadow(
                          color: Theme.of(
                            context,
                          ).colorScheme.primary.withValues(alpha: 0.05),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          AppRouter.pushNamed(context, AppRouter.favorites);
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          child:
                              favoritesProvider.isLoading
                                  ? SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Theme.of(context).colorScheme.primary,
                                      ),
                                    ),
                                  )
                                  : Icon(
                                    favoritesProvider.hasFavorites
                                        ? AppIcons.favoriteFilled
                                        : AppIcons.favoriteOutline,
                                    color:
                                        favoritesProvider.hasFavorites
                                            ? AppTheme.darkError
                                            : Theme.of(context)
                                                .colorScheme
                                                .onSurface
                                                .withValues(alpha: 0.7),
                                    size: 24,
                                  ),
                        ),
                      ),
                    ),
                  ),

                  // Animated badge
                  if (favoritesProvider.favoritesCount > 0)
                    Positioned(
                      right: 6,
                      top: 6,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOutCubic,
                        padding: EdgeInsets.symmetric(
                          horizontal:
                              favoritesProvider.favoritesCount > 9 ? 6 : 4,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppTheme.darkError,
                              AppTheme.darkError.withValues(alpha: 0.8),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.3),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.darkError.withValues(alpha: 0.4),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        constraints: BoxConstraints(
                          minWidth:
                              favoritesProvider.favoritesCount > 9 ? 20 : 16,
                          minHeight: 16,
                        ),
                        child: AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 200),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize:
                                favoritesProvider.favoritesCount > 9 ? 9 : 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                          child: Text(
                            favoritesProvider.favoritesCount > 99
                                ? '99+'
                                : favoritesProvider.favoritesCount.toString(),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),

          const SizedBox(width: AppConstants.smallSpacing),

          // Leaderboard Button
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 12,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              onPressed: () {
                AppRouter.pushNamed(context, AppRouter.leaderboard);
              },
              icon: Image.asset(
                'assets/icon/winner.png',
                width: 24,
                height: 24,
              ),
            ),
          ),

          const SizedBox(width: AppConstants.smallSpacing),

          // Settings Button
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 12,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              onPressed: () {
                AppRouter.pushNamed(context, AppRouter.settings);
              },
              icon: Image.asset(
                'assets/icon/settings.png',
                width: 24,
                height: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showRatingBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const RatingBottomSheet(),
    );
  }

  Widget _buildGamesGridWithInlineAds(BuildContext context) {
    // Sort games by order
    final games = List.of(GamesConfig.allGames)
      ..sort((a, b) => a.order.compareTo(b.order));

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: EdgeInsets.zero,
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              // Banner Ad at the top of the scrollable content
              Padding(
                padding: const EdgeInsets.only(top: 24.0, bottom: 8),
                child: const BannerAdWidget(),
              ),

              // The grid wrapped as a sliver list of sections
              _GamesGridWithAdsSection(
                games: games,
                gamesPerAd: 6, // 3 rows
                gamesPerRow: 2,
                fadeAnimation: fadeAnimation,
                fadeController: fadeController,
              ),
            ]),
          ),
        ),
      ],
    );
  }
}

class _GamesGridWithAdsSection extends StatelessWidget {
  final List<dynamic> games; // Using dynamic to avoid importing GameModel here
  final int gamesPerAd;
  final int gamesPerRow;
  final Animation<double> fadeAnimation;
  final AnimationController fadeController;

  const _GamesGridWithAdsSection({
    required this.games,
    required this.gamesPerAd,
    required this.gamesPerRow,
    required this.fadeAnimation,
    required this.fadeController,
  });

  @override
  Widget build(BuildContext context) {
    final List<Widget> sections = [];
    int processed = 0;

    while (processed < games.length) {
      final remaining = games.length - processed;
      final take = remaining >= gamesPerAd ? gamesPerAd : remaining;
      final int chunkStart = processed;

      // Add grid chunk
      sections.add(
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.75,
          ),
          padding: EdgeInsets.zero,
          itemCount: take,
          itemBuilder: (context, idx) {
            final game = games[chunkStart + idx];
            return AnimatedBuilder(
              animation: fadeController,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, 10 * (1 - fadeAnimation.value)),
                  child: Opacity(
                    opacity: fadeAnimation.value,
                    child: GameCard(
                      title: game.getTitle(context),
                      iconPath: GamesConfig.getGameIconPath(game.icon),
                      color: GamesConfig.getGameColor(game.id),
                      gameId: game.id,
                      onTap: () {
                        AppRouter.pushNamed(context, game.route);
                      },
                    ),
                  ),
                );
              },
            );
          },
        ),
      );

      processed += take;

      // Insert inline ad after each chunk, except after the last chunk if exact fit
      if (processed < games.length) {
        // Use custom spacing to match the 16px mainAxisSpacing between grid rows
        sections.add(
          const InlineBannerAdWidget(
            verticalPadding: 8.0, // Reduced padding to match grid spacing
          ),
        );
      }
    }

    return Column(children: sections);
  }
}
