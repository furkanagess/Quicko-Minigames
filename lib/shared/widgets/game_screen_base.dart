import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/text_theme_manager.dart';
import '../../core/theme/app_theme.dart';
import '../../core/routes/app_router.dart';
import '../../core/providers/app_providers.dart';
import '../../features/favorites/providers/favorites_provider.dart';
import 'game_description.dart';

class GameScreenBase extends StatelessWidget {
  final String title;
  final String descriptionKey;
  final Widget child;
  final Widget? bottomActions;
  final IconData? descriptionIcon;
  final List<Widget>? actions;
  final String? gameId;

  const GameScreenBase({
    super.key,
    required this.title,
    required this.descriptionKey,
    required this.child,
    this.bottomActions,
    this.descriptionIcon,
    this.actions,
    this.gameId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          title.tr(),
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
          if (gameId != null)
            Consumer<FavoritesProvider>(
              builder: (context, favoritesProvider, child) {
                return IconButton(
                  onPressed: () => favoritesProvider.toggleFavorite(gameId!),
                  icon: Icon(
                    favoritesProvider.isFavorite(gameId!)
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    color:
                        favoritesProvider.isFavorite(gameId!)
                            ? AppTheme.darkError
                            : Colors.white,
                  ),
                );
              },
            ),
          // Diğer action'lar
          if (actions != null) ...actions!,
        ],
        leading: IconButton(
          onPressed: () => AppRouter.pop(context),
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.mediumSpacing),
          child: Column(
            children: [
              // Oyun açıklaması
              GameDescription(
                descriptionKey: descriptionKey,
                icon: descriptionIcon,
              ),

              const SizedBox(height: AppConstants.largeSpacing),

              // Oyun içeriği - ortalanmış ve aşağıya kaydırılmış
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20), // Üstten boşluk
                    Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: 350, // Maksimum genişlik
                          maxHeight: 400, // Maksimum yükseklik
                        ),
                        child: child,
                      ),
                    ),
                  ],
                ),
              ),

              // Bottom Actions (opsiyonel)
              if (bottomActions != null) ...[
                const SizedBox(height: AppConstants.mediumSpacing),
                bottomActions!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
