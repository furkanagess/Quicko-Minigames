import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/services/admob_service.dart';
import '../../core/services/in_app_purchase_service.dart';
import '../../core/providers/test_mode_provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/text_theme_manager.dart';
import '../../l10n/app_localizations.dart';
import 'banner_ad_widget.dart';

class ContinueGameDialog extends StatefulWidget {
  final String gameId;
  final String gameTitle;
  final int currentScore;
  final VoidCallback onContinue;
  final VoidCallback onRestart;
  final VoidCallback onExit;
  final bool canOneTimeContinue;

  const ContinueGameDialog({
    super.key,
    required this.gameId,
    required this.gameTitle,
    required this.currentScore,
    required this.onContinue,
    required this.onRestart,
    required this.onExit,
    required this.canOneTimeContinue,
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
  bool _isAdFree = false;

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
    _checkAdFreeStatus();
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

  Future<void> _checkAdFreeStatus() async {
    final purchaseService = InAppPurchaseService();
    final isAdFree = purchaseService.isAdFree;

    if (mounted) {
      setState(() {
        _isAdFree = isAdFree;
      });
    }
  }

  /// Check if ad-free mode is enabled (combines actual subscription + test mode)
  bool _isAdFreeEnabled() {
    final purchaseService = InAppPurchaseService();
    final testModeProvider = TestModeProvider();
    return purchaseService.isAdFree || testModeProvider.shouldBehaveAsAdFree;
  }

  Future<void> _showRewardedAd() async {
    if (_isAdFreeEnabled()) {
      // For ad-free users, directly continue the game
      widget.onContinue();
      Navigator.of(context).pop();
      return;
    }

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
        _showAdNotAvailableDialog();
      },
    );

    if (!success) {
      setState(() {
        _isLoading = false;
      });
      _showAdNotAvailableDialog();
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
                Theme.of(context).colorScheme.surface.withValues(alpha: 0.98),
              ],
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 20,
                offset: const Offset(0, 10),
                spreadRadius: 1,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Game Over Title
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 12,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.darkError.withValues(alpha: 0.1),
                      AppTheme.darkError.withValues(alpha: 0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppTheme.darkError.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: Text(
                  localizations.gameOver,
                  style: TextThemeManager.headlineSmall.copyWith(
                    fontWeight: FontWeight.w800,
                    color: AppTheme.darkError,
                    letterSpacing: -0.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 20),

              // Game Info Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Theme.of(
                      context,
                    ).colorScheme.outline.withValues(alpha: 0.08),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Game Title
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.darkPrimary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        widget.gameTitle,
                        style: TextThemeManager.titleMedium.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppTheme.darkPrimary,
                        ),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Score Row
                    Row(
                      children: [
                        Expanded(
                          child: _buildInfoItem(
                            Icons.emoji_events_rounded,
                            localizations.score,
                            widget.currentScore.toString(),
                            AppTheme.darkSuccess,
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
                  return _isAdFreeEnabled()
                      ? (widget.canOneTimeContinue
                          ? Transform.scale(
                            scale: _pulseAnimation.value,
                            child: Container(
                              width: double.infinity,
                              height: 56,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    AppTheme.darkSuccess,
                                    AppTheme.darkSuccess.withValues(alpha: 0.9),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppTheme.darkSuccess.withValues(
                                      alpha: 0.3,
                                    ),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                              child: ElevatedButton(
                                onPressed:
                                    !_isLoading
                                        ? () {
                                          widget.onContinue();
                                          Navigator.of(context).pop();
                                        }
                                        : null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  foregroundColor: Colors.white,
                                  shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  elevation: 0,
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Icon(
                                              Icons.play_arrow_rounded,
                                              size: 24,
                                            ),
                                            const SizedBox(width: 8),
                                            Flexible(
                                              child: Text(
                                                _isAdFreeEnabled()
                                                    ? localizations
                                                        .oneTimeContinue
                                                    : localizations
                                                        .watchAdToContinue,
                                                style: TextThemeManager
                                                    .bodyLarge
                                                    .copyWith(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w700,
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
                          )
                          : const SizedBox.shrink())
                      : _isAdAvailable
                      ? Transform.scale(
                        scale: _pulseAnimation.value,
                        child: Container(
                          width: double.infinity,
                          height: 56,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppTheme.darkSuccess,
                                AppTheme.darkSuccess.withValues(alpha: 0.9),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.darkSuccess.withValues(
                                  alpha: 0.3,
                                ),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: !_isLoading ? _showRewardedAd : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              foregroundColor: Colors.white,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 0,
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.play_arrow_rounded,
                                          size: 24,
                                        ),
                                        const SizedBox(width: 8),
                                        Flexible(
                                          child: Text(
                                            localizations.watchAdToContinue,
                                            style: TextThemeManager.bodyLarge
                                                .copyWith(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w700,
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
                      )
                      : const SizedBox.shrink();
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
                      icon: Icons.exit_to_app_rounded,
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
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withValues(alpha: 0.2), width: 1),
          ),
          child: Icon(icon, color: color, size: 22),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextThemeManager.bodySmall.copyWith(
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.6),
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextThemeManager.titleSmall.copyWith(
            color: color,
            fontWeight: FontWeight.w800,
            fontSize: 15,
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
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.15), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          foregroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                style: TextThemeManager.bodyMedium.copyWith(
                  fontWeight: FontWeight.w700,
                  color: color,
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
