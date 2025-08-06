import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../shared/models/leaderboard_entry.dart';
import '../providers/leaderboard_provider.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/games_config.dart';
import '../../../core/theme/text_theme_manager.dart';
import '../../../core/utils/share_utils.dart';
import '../../../core/routes/app_router.dart';
import '../../../core/providers/app_providers.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  @override
  void initState() {
    super.initState();
    // Liderlik tablosunu yükle
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LeaderboardProvider>().loadLeaderboard();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'leaderboard'.tr(),
          style: TextThemeManager.appTitlePrimary(context),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_rounded,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          onPressed: () => AppRouter.pop(context),
        ),
      ),
      body: Consumer<LeaderboardProvider>(
        builder: (context, leaderboardProvider, child) {
          if (leaderboardProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!leaderboardProvider.hasEntries) {
            return _buildEmptyState();
          }

          return _buildLeaderboardContent(leaderboardProvider);
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.emoji_events_outlined,
            size: 80,
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.5),
          ),
          const SizedBox(height: AppConstants.largeSpacing),
          Text(
            'no_leaderboard_data'.tr(),
            style: TextThemeManager.screenTitle.copyWith(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppConstants.mediumSpacing),
          Text(
            'play_games_to_see_scores'.tr(),
            style: TextThemeManager.bodyMedium.copyWith(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.5),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppConstants.extraLargeSpacing),
          ElevatedButton.icon(
            onPressed: () => AppRouter.pop(context),
            icon: const Icon(Icons.games_rounded),
            label: Text('play_games'.tr()),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppConstants.mediumRadius),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeaderboardContent(LeaderboardProvider leaderboardProvider) {
    return Column(
      children: [
        // İstatistikler
        _buildStatistics(leaderboardProvider),

        const SizedBox(height: AppConstants.largeSpacing),

        // Liderlik tablosu listesi
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(AppConstants.mediumSpacing),
            itemCount: leaderboardProvider.entries.length,
            itemBuilder: (context, index) {
              final entry = leaderboardProvider.entries[index];
              return _buildLeaderboardCard(entry, index + 1);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildStatistics(LeaderboardProvider leaderboardProvider) {
    return Container(
      margin: const EdgeInsets.all(AppConstants.mediumSpacing),
      padding: const EdgeInsets.all(AppConstants.mediumSpacing),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppConstants.mediumRadius),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            'total_games'.tr(),
            leaderboardProvider.totalEntries.toString(),
            Icons.games_rounded,
          ),
          _buildStatItem(
            'highest_score'.tr(),
            leaderboardProvider.highestScore.toString(),
            Icons.emoji_events_rounded,
          ),
          _buildStatItem(
            'average_score'.tr(),
            leaderboardProvider.averageScore.toStringAsFixed(1),
            Icons.analytics_rounded,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary, size: 24),
        const SizedBox(height: AppConstants.smallSpacing),
        Text(
          value,
          style: TextThemeManager.subtitleMedium.copyWith(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextThemeManager.bodySmall.copyWith(
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.7),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildLeaderboardCard(LeaderboardEntry entry, int rank) {
    final gameConfig = GamesConfig.getGameById(entry.gameId);
    final leaderboardProvider = AppProviders.getProvider<LeaderboardProvider>(
      context,
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.06),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, 6),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.03),
            blurRadius: 40,
            offset: const Offset(0, 12),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Stack(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap:
                  () => AppRouter.pushNamed(
                    context,
                    gameConfig?.route ?? AppRouter.home,
                  ),
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Theme.of(context).colorScheme.surface,
                      Theme.of(
                        context,
                      ).colorScheme.surface.withValues(alpha: 0.92),
                    ],
                  ),
                ),
                child: Row(
                  children: [
                    // Sıralama
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: _getRankColor(rank),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: _getRankColor(rank).withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          rank.toString(),
                          style: TextThemeManager.subtitleMedium.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),

                    // Oyun ikonu
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(
                              context,
                            ).colorScheme.primary.withValues(alpha: 0.15),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: Icon(
                        gameConfig != null
                            ? GamesConfig.getGameIcon(gameConfig.icon)
                            : Icons.games_rounded,
                        color: Theme.of(context).colorScheme.primary,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),

                    // Oyun bilgileri
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            entry.gameTitle.tr(),
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontWeight: FontWeight.w800,
                              fontSize: 16,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Skor
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: _getRankColor(rank).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _getRankColor(rank).withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        entry.highScore.toString(),
                        style: TextStyle(
                          color: _getRankColor(rank),
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Sil butonu
          Positioned(
            top: 8,
            right: 8,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder:
                        (context) => AlertDialog(
                          title: Text('Delete High Score'),
                          content: Text(
                            'Are you sure you want to delete the high score for this game?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => AppRouter.pop(context, false),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => AppRouter.pop(context, true),
                              child: const Text(
                                'Delete',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                  );
                  if (confirm == true) {
                    await leaderboardProvider.removeHighScore(entry.gameId);
                  }
                },
                child: Tooltip(
                  message: 'Delete High Score',
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.08),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.delete_outline_rounded,
                      color: Colors.red,
                      size: 22,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getRankColor(int rank) {
    switch (rank) {
      case 1:
        return Colors.amber;
      case 2:
        return Colors.grey;
      case 3:
        return Colors.brown;
      default:
        return Theme.of(context).colorScheme.primary;
    }
  }

  String _formatDate(DateTime date) {
    // Format: DD.MM.YY (e.g., "22.03.25")
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = (date.year % 100).toString().padLeft(2, '0');

    return '$day.$month.$year';
  }

  void _showSortDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Consumer<LeaderboardProvider>(
          builder: (context, leaderboardProvider, child) {
            return AlertDialog(
              title: Text('sort_by'.tr()),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RadioListTile<String>(
                    title: Text('sort_by_score'.tr()),
                    value: 'score',
                    groupValue: leaderboardProvider.sortBy,
                    onChanged: (value) {
                      leaderboardProvider.changeSortBy(value!);
                      AppRouter.pop(context);
                    },
                  ),
                  RadioListTile<String>(
                    title: Text('sort_by_last_played'.tr()),
                    value: 'lastPlayed',
                    groupValue: leaderboardProvider.sortBy,
                    onChanged: (value) {
                      leaderboardProvider.changeSortBy(value!);
                      AppRouter.pop(context);
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showShareOptions(BuildContext context) {
    final leaderboardProvider = context.read<LeaderboardProvider>();

    if (!leaderboardProvider.hasEntries) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('share_no_data'.tr()),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'share_achievements'.tr(),
                style: TextThemeManager.subtitleMedium.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: Icon(
                  Icons.preview_rounded,
                  color: Theme.of(context).colorScheme.primary,
                ),
                title: Text('preview_image'.tr()),
                onTap: () {
                  AppRouter.pop(context);
                  _previewAchievementImage(context, leaderboardProvider);
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.share_rounded,
                  color: Theme.of(context).colorScheme.primary,
                ),
                title: Text('share_image'.tr()),
                onTap: () {
                  AppRouter.pop(context);
                  _shareAchievementImage(context, leaderboardProvider);
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  void _previewAchievementImage(
    BuildContext context,
    LeaderboardProvider leaderboardProvider,
  ) {
    ShareUtils.showAchievementPreview(
      context: context,
      entries: leaderboardProvider.entries,
      totalGames: leaderboardProvider.totalEntries,
      highestScore: leaderboardProvider.highestScore,
      averageScore: leaderboardProvider.averageScore,
    );
  }

  void _shareAchievementImage(
    BuildContext context,
    LeaderboardProvider leaderboardProvider,
  ) async {
    try {
      await ShareUtils.shareAchievementImage(
        entries: leaderboardProvider.entries,
        totalGames: leaderboardProvider.totalEntries,
        highestScore: leaderboardProvider.highestScore,
        averageScore: leaderboardProvider.averageScore,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('share_error'.tr()),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }
}
