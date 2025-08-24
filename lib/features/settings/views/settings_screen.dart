import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/in_app_purchase_provider.dart';
import '../../../core/providers/language_provider.dart';
import '../../../core/providers/theme_provider.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/managers/settings_manager.dart';
import '../../../core/services/navigation_service.dart';
import '../../../shared/widgets/app_bars.dart';
import '../../../shared/widgets/settings_option_widget.dart';
import '../../../shared/widgets/animated_screen_widget.dart';
import '../../../core/services/animation_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: _buildAppBar(),
      body: _buildAnimatedBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBars.settingsAppBar(
      context: context,
      title: 'Settings', // This will be localized by the app bar
    );
  }

  Widget _buildAnimatedBody() {
    return Consumer3<LanguageProvider, ThemeProvider, InAppPurchaseProvider>(
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
        ).withScreenAnimation(
          animationConfig: AnimationConfig.screen,
          onAnimationComplete: () {
            // Animation completed callback if needed
          },
        );
      },
    );
  }

  Widget _buildSettingsOptions(
    BuildContext context,
    LanguageProvider languageProvider,
    ThemeProvider themeProvider,
    InAppPurchaseProvider purchaseProvider,
  ) {
    final settingsOptions = SettingsManager.getSettingsOptions(
      context,
      languageProvider,
      themeProvider,
      purchaseProvider,
    );

    return Column(
      children:
          settingsOptions.map((option) {
            return Column(
              children: [
                SettingsOptionWidget(
                  optionData: option,
                  onTap: () => _handleSettingsOptionTap(context, option.route),
                ),
                const SizedBox(height: AppConstants.mediumSpacing),
              ],
            );
          }).toList(),
    );
  }

  void _handleSettingsOptionTap(BuildContext context, String route) {
    switch (route) {
      case '/language-settings':
        NavigationService.navigateToLanguageSettings(context);
        break;
      case '/theme-settings':
        NavigationService.navigateToThemeSettings(context);
        break;
      case '/sound-settings':
        NavigationService.navigateToSoundSettings(context);
        break;
      case '/leaderboard-profile':
        NavigationService.navigateToLeaderboardProfile(context);
        break;
      case '/ad-free-subscription':
        NavigationService.navigateToAdFreeSubscription(context);
        break;
      case '/feedback':
        NavigationService.navigateToFeedback(context);
        break;
    }
  }
}
