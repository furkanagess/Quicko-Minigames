import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import '../widgets/game_card.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/games_config.dart';
import '../../../core/theme/text_theme_manager.dart';
import '../../../core/theme/app_theme.dart';
import '../../favorites/providers/favorites_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.mediumSpacing),
          child: Column(
            children: [
              // Header
              _buildHeader(context),

              const SizedBox(height: AppConstants.largeSpacing),

              // Games Grid
              Expanded(child: _buildGamesGrid(context)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        // App Title
        Expanded(
          child: Text(
            'app_name'.tr(),
            style: TextThemeManager.appTitlePrimary(context),
          ),
        ),

        // Favorites Button
        Consumer<FavoritesProvider>(
          builder: (context, favoritesProvider, child) {
            return Stack(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/favorites');
                  },
                  icon: Icon(
                    Icons.favorite_rounded,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                if (favoritesProvider.favoritesCount > 0)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.darkError,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        favoritesProvider.favoritesCount.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),

        // Leaderboard Button
        IconButton(
          onPressed: () {
            Navigator.of(context).pushNamed('/leaderboard');
          },
          icon: Icon(
            Icons.emoji_events_rounded,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _buildGamesGrid(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 0.75,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      children:
          GamesConfig.allGames.map((game) {
            return GameCard(
              title: game.titleKey.tr(),
              icon: GamesConfig.getGameIcon(game.icon),
              color: GamesConfig.getGameColor(game.id),
              gameId: game.id,
              onTap: () {
                Navigator.of(context).pushNamed(game.route);
              },
            );
          }).toList(),
    );
  }
}
