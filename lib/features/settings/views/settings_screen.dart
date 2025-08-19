import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/in_app_purchase_provider.dart';
import '../../../core/providers/language_provider.dart';
import '../../../core/providers/test_mode_provider.dart';
import '../../../core/providers/theme_provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/text_theme_manager.dart';
import '../../../core/constants/app_icons.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/routes/app_router.dart';
import 'sound_settings_screen.dart';
import 'ad_free_subscription_screen.dart';
import 'language_settings_screen.dart';
import 'theme_settings_screen.dart';
import 'feedback_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Getter for testing ad-free status (combines real and test mode)
  bool _isAdFreeForTesting(
    InAppPurchaseProvider purchaseProvider,
    TestModeProvider testModeProvider,
  ) {
    return purchaseProvider.isSubscriptionActive ||
        testModeProvider.testAdFreeMode;
  }

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
      begin: const Offset(0, 0.05),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
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
          child:
              Consumer3<LanguageProvider, ThemeProvider, InAppPurchaseProvider>(
                builder: (
                  context,
                  languageProvider,
                  themeProvider,
                  purchaseProvider,
                  child,
                ) {
                  return SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(AppConstants.mediumSpacing),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Settings Header

                            // Settings Options
                            _buildSettingsOptions(
                              context,
                              languageProvider,
                              themeProvider,
                              purchaseProvider,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(
        AppLocalizations.of(context)!.settings,
        style: TextThemeManager.appTitlePrimary(context),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
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
          icon: Icon(
            AppIcons.back,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          onPressed: () => AppRouter.pop(context),
        ),
      ),
    );
  }

  Widget _buildSettingsHeader(BuildContext context) {
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
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Image.asset(
              'assets/icon/settings.png',
              width: 24,
              height: 24,
            ),
          ),
          const SizedBox(width: AppConstants.mediumSpacing),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.appSettings,
                  style: TextThemeManager.sectionTitle.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  AppLocalizations.of(context)!.customizeAppExperience,
                  style: TextThemeManager.bodySmall.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsOptions(
    BuildContext context,
    LanguageProvider languageProvider,
    ThemeProvider themeProvider,
    InAppPurchaseProvider purchaseProvider,
  ) {
    return Consumer<TestModeProvider>(
      builder: (context, testModeProvider, child) {
        return Column(
          children: [
            // Language Setting Option
            _buildSettingOption(
              context,
              title: AppLocalizations.of(context)!.language,
              subtitle: _getLanguageDisplayName(
                languageProvider.currentLocale.languageCode,
              ),
              icon: Icons.language_rounded,
              emoji: _getLanguageEmoji(
                languageProvider.currentLocale.languageCode,
              ),
              onTap: () => _navigateToLanguageSettings(context),
            ),

            const SizedBox(height: AppConstants.mediumSpacing),

            // Theme Setting Option
            _buildSettingOption(
              context,
              title: AppLocalizations.of(context)!.theme,
              subtitle: _getCurrentThemeDisplay(themeProvider),
              icon: Icons.palette_rounded,
              emoji: _getThemeEmoji(themeProvider),
              onTap: () => _navigateToThemeSettings(context),
            ),

            const SizedBox(height: AppConstants.mediumSpacing),

            // Sound Settings Option
            _buildSettingOption(
              context,
              title: AppLocalizations.of(context)!.soundSettings,
              subtitle: AppLocalizations.of(context)!.soundSettingsMenuSubtitle,
              icon: Icons.volume_up_rounded,
              emoji: '🔊',
              onTap: () => _navigateToSoundSettings(context),
            ),

            const SizedBox(height: AppConstants.mediumSpacing),

            // Ad-Free Subscription Option
            _buildSettingOption(
              context,
              title: AppLocalizations.of(context)!.removeAds,
              subtitle: _getAdFreeStatusDisplay(purchaseProvider),
              icon: Icons.block_rounded,
              emoji:
                  _isAdFreeForTesting(purchaseProvider, testModeProvider)
                      ? '✅'
                      : '🚫',
              onTap: () => _navigateToAdFreeSubscription(context),
            ),

            const SizedBox(height: AppConstants.mediumSpacing),

            // Feedback Option
            _buildSettingOption(
              context,
              title: AppLocalizations.of(context)!.feedbackAndSuggestions,
              subtitle:
                  AppLocalizations.of(context)!.feedbackAndSuggestionsSubtitle,
              icon: Icons.feedback_rounded,
              emoji: '💬',
              onTap: () => _navigateToFeedback(context),
            ),

            const SizedBox(height: AppConstants.largeSpacing),

            // Test Section Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.mediumSpacing,
                vertical: AppConstants.smallSpacing,
              ),
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.secondary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Theme.of(
                    context,
                  ).colorScheme.secondary.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.science_rounded,
                    color: Theme.of(context).colorScheme.secondary,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Test Mode',
                    style: TextThemeManager.bodySmall.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppConstants.mediumSpacing),

            // Test Ad-Free Experience
            _buildTestOption(
              context,
              title: 'Test Ad-Free Experience',
              subtitle: 'Toggle to test ad-free user experience',
              icon: Icons.toggle_on_rounded,
              emoji: '🧪',
              isEnabled: testModeProvider.testAdFreeMode,
              onToggle:
                  (value) =>
                      _toggleTestAdFree(context, value, testModeProvider),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSettingOption(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required String emoji,
    required VoidCallback onTap,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.mediumSpacing),
            child: Row(
              children: [
                // Icon Container
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                  child: Text(emoji, style: const TextStyle(fontSize: 24)),
                ),
                const SizedBox(width: AppConstants.mediumSpacing),

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextThemeManager.subtitleMedium.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextThemeManager.bodySmall.copyWith(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                ),

                // Arrow Icon
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.4),
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Returns the display name for the given language code
  /// This is a static method for better performance and reusability
  static String _getLanguageDisplayName(String languageCode) {
    switch (languageCode) {
      case 'en':
        return 'English';
      case 'tr':
        return 'Türkçe';
      case 'es':
        return 'Español';
      case 'pt':
        return 'Português';
      case 'ar':
        return 'العربية';
      case 'de':
        return 'Deutsch';
      case 'fr':
        return 'Français';
      case 'id':
        return 'Bahasa Indonesia';
      case 'hi':
        return 'हिंदी';
      case 'az':
        return 'Azərbaycan';
      case 'it':
        return 'Italiano';
      default:
        return '';
    }
  }

  /// Returns the emoji flag for the given language code
  /// This is a static method for better performance and reusability
  static String _getLanguageEmoji(String languageCode) {
    switch (languageCode) {
      case 'en':
        return '🇺🇸';
      case 'tr':
        return '🇹🇷';
      case 'es':
        return '🇪🇸';
      case 'pt':
        return '🇧🇷';
      case 'ar':
        return '🇸🇦';
      case 'de':
        return '🇩🇪';
      case 'fr':
        return '🇫🇷';
      case 'id':
        return '🇮🇩';
      case 'hi':
        return '🇮🇳';
      case 'az':
        return '🇦🇿';
      case 'it':
        return '🇮🇹';
      default:
        return '🌐';
    }
  }

  String _getCurrentThemeDisplay(ThemeProvider themeProvider) {
    switch (themeProvider.currentThemeMode) {
      case AppThemeMode.light:
        return AppLocalizations.of(context)!.lightTheme;
      case AppThemeMode.dark:
        return AppLocalizations.of(context)!.darkTheme;
      case AppThemeMode.system:
        return AppLocalizations.of(context)!.systemTheme;
    }
  }

  String _getThemeEmoji(ThemeProvider themeProvider) {
    return themeProvider.getThemeModeEmoji(themeProvider.currentThemeMode);
  }

  String _getAdFreeStatusDisplay(InAppPurchaseProvider purchaseProvider) {
    if (purchaseProvider.isSubscriptionActive) {
      return AppLocalizations.of(context)!.lifetimeAccess;
    } else {
      return AppLocalizations.of(context)!.subscriptionPrice;
    }
  }

  void _navigateToLanguageSettings(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const LanguageSettingsScreen()),
    );
  }

  void _navigateToThemeSettings(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const ThemeSettingsScreen()),
    );
  }

  void _navigateToAdFreeSubscription(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const AdFreeSubscriptionScreen()),
    );
  }

  void _navigateToSoundSettings(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const SoundSettingsScreen()),
    );
  }

  void _navigateToFeedback(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const FeedbackScreen()));
  }

  Widget _buildTestOption(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required String emoji,
    required bool isEnabled,
    required Function(bool) onToggle,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onToggle(!isEnabled),
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.mediumSpacing),
            child: Row(
              children: [
                // Icon Container
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                  child: Text(emoji, style: const TextStyle(fontSize: 24)),
                ),
                const SizedBox(width: AppConstants.mediumSpacing),

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextThemeManager.subtitleMedium.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextThemeManager.bodySmall.copyWith(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                ),

                // Toggle Switch
                Switch(
                  value: isEnabled,
                  onChanged: (value) => onToggle(value),
                  activeColor: Theme.of(context).colorScheme.primary,
                  inactiveThumbColor: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.3),
                  inactiveTrackColor: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.1),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _toggleTestAdFree(
    BuildContext context,
    bool value,
    TestModeProvider testModeProvider,
  ) {
    testModeProvider.setTestAdFreeMode(value);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          value
              ? '🧪 Test Mode: Ad-Free experience enabled! You can now test ad-free features.'
              : '🧪 Test Mode: Ad-Free experience disabled! You can now test normal user experience.',
        ),
        duration: const Duration(seconds: 3),
        backgroundColor:
            value
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.secondary,
      ),
    );
  }
}
