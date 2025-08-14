import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/services/admob_service.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/text_theme_manager.dart';
import '../../l10n/app_localizations.dart';

class ContinueGameDialog extends StatefulWidget {
  final String gameId;
  final String gameTitle;
  final int currentScore;
  final int currentLevel;
  final VoidCallback onContinue;
  final VoidCallback onRestart;
  final VoidCallback onExit;

  const ContinueGameDialog({
    super.key,
    required this.gameId,
    required this.gameTitle,
    required this.currentScore,
    required this.currentLevel,
    required this.onContinue,
    required this.onRestart,
    required this.onExit,
  });

  @override
  State<ContinueGameDialog> createState() => _ContinueGameDialogState();
}

class _ContinueGameDialogState extends State<ContinueGameDialog>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _pulseController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation;

  bool _isLoading = false;
  bool _isAdAvailable = false;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _animationController.forward();
    _pulseController.repeat(reverse: true);

    _checkAdAvailability();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _checkAdAvailability() async {
    final adService = AdMobService();
    final available = await adService.loadRewardedAd();

    if (mounted) {
      setState(() {
        _isAdAvailable = available;
      });
    }
  }

  Future<void> _showRewardedAd() async {
    if (!_isAdAvailable) {
      _showAdNotAvailableDialog();
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final adService = AdMobService();
    final success = await adService.showRewardedAd(
      onRewarded: () {
        // Ad successfully watched, continue game with reward
        // The reward is continuing from the lost score/level
        widget.onContinue();
        Navigator.of(context).pop();
      },
      onAdClosed: () {
        setState(() {
          _isLoading = false;
        });
      },
      onAdFailed: (error) {
        setState(() {
          _isLoading = false;
        });
        _showAdFailedDialog(error);
      },
    );

    if (!success) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showAdNotAvailableDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(AppLocalizations.of(context)!.adNotAvailable),
            content: Text(AppLocalizations.of(context)!.adNotAvailableMessage),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(AppLocalizations.of(context)!.ok),
              ),
            ],
          ),
    );
  }

  void _showAdFailedDialog(String error) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(AppLocalizations.of(context)!.adFailed),
            content: Text(
              '${AppLocalizations.of(context)!.adFailedMessage}\n$error',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(AppLocalizations.of(context)!.ok),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return ScaleTransition(
      scale: _scaleAnimation,
      child: Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          constraints: const BoxConstraints(maxWidth: 400, minWidth: 280),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).colorScheme.surface,
                Theme.of(context).colorScheme.surface.withValues(alpha: 0.95),
              ],
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Game Info
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Theme.of(
                      context,
                    ).colorScheme.outline.withValues(alpha: 0.1),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.gameTitle,
                      style: TextThemeManager.titleMedium.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: _buildInfoItem(
                            Icons.score,
                            localizations.score,
                            widget.currentScore.toString(),
                            AppTheme.darkSuccess,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildInfoItem(
                            Icons.trending_up,
                            localizations.level,
                            widget.currentLevel.toString(),
                            AppTheme.darkPrimary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Continue Button
              AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _isAdAvailable ? _pulseAnimation.value : 1.0,
                    child: Container(
                      width: double.infinity,
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors:
                              _isAdAvailable
                                  ? [
                                    AppTheme.darkSuccess,
                                    AppTheme.darkSuccess.withValues(alpha: 0.8),
                                  ]
                                  : [
                                    Colors.grey,
                                    Colors.grey.withValues(alpha: 0.8),
                                  ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: (_isAdAvailable
                                    ? AppTheme.darkSuccess
                                    : Colors.grey)
                                .withValues(alpha: 0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed:
                            _isAdAvailable && !_isLoading
                                ? _showRewardedAd
                                : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          foregroundColor: Colors.white,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child:
                            _isLoading
                                ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                                : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.play_arrow_rounded, size: 24),
                                    const SizedBox(width: 8),
                                    Flexible(
                                      child: Text(
                                        localizations.watchAdToContinue,
                                        style: TextThemeManager.bodyLarge
                                            .copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                      ),
                                    ),
                                  ],
                                ),
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 16),

              // Other Options
              Row(
                children: [
                  Expanded(
                    child: _buildActionButton(
                      icon: Icons.refresh_rounded,
                      label: localizations.restart,
                      color: AppTheme.darkWarning,
                      onPressed: () {
                        widget.onRestart();
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildActionButton(
                      icon: Icons.close_rounded,
                      label: localizations.exit,
                      color: AppTheme.darkError,
                      onPressed: () {
                        widget.onExit();
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem(
    IconData icon,
    String label,
    String value,
    Color color,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextThemeManager.bodySmall.copyWith(
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.7),
          ),
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        Text(
          value,
          style: TextThemeManager.titleSmall.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          foregroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                label,
                style: TextThemeManager.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
