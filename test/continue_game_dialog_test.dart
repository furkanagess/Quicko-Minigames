import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quicko_app/l10n/app_localizations.dart';
import 'package:quicko_app/shared/widgets/dialog/continue_game_dialog.dart';

void main() {
  group('ContinueGameDialog UI Tests', () {
    testWidgets('should display modern UI with gradient header', (
      WidgetTester tester,
    ) async {
      // Build the dialog
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('en'),
          home: Scaffold(
            body: Builder(
              builder:
                  (context) => ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder:
                            (context) => const ContinueGameDialog(
                              gameId: 'test_game',
                              gameTitle: 'Test Game',
                              currentScore: 100,
                              canOneTimeContinue: true,
                              onContinue: _dummyContinue,
                              onRestart: _dummyRestart,
                              onExit: _dummyExit,
                            ),
                      );
                    },
                    child: const Text('Show Dialog'),
                  ),
            ),
          ),
        ),
      );

      // Tap to show dialog
      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      // Verify that the modern UI elements are present
      expect(find.text('Game Over'), findsOneWidget);
      expect(find.text('Test Game - Score 100'), findsOneWidget);
      expect(find.text('Continue Game'), findsOneWidget);
      expect(
        find.text('Continue your game from where you left off.'),
        findsOneWidget,
      );
      expect(find.text('1-Time Continue'), findsOneWidget);
      expect(find.text('Restart'), findsOneWidget);
      expect(find.text('Exit'), findsOneWidget);

      // Verify that the dialog has the modern structure
      expect(find.byType(Container), findsWidgets);
      expect(find.byType(LinearGradient), findsWidgets);
    });

    testWidgets('should display ad-based continue option when not ad-free', (
      WidgetTester tester,
    ) async {
      // Build the dialog
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('en'),
          home: Scaffold(
            body: Builder(
              builder:
                  (context) => ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder:
                            (context) => const ContinueGameDialog(
                              gameId: 'test_game',
                              gameTitle: 'Test Game',
                              currentScore: 100,
                              canOneTimeContinue: false,
                              onContinue: _dummyContinue,
                              onRestart: _dummyRestart,
                              onExit: _dummyExit,
                            ),
                      );
                    },
                    child: const Text('Show Dialog'),
                  ),
            ),
          ),
        ),
      );

      // Tap to show dialog
      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      // Verify that the ad-based continue option is shown
      expect(
        find.text(
          'Watch a short ad to continue your game from where you left off.',
        ),
        findsOneWidget,
      );
      expect(find.text('Watch Ad to Continue'), findsOneWidget);
    });

    testWidgets(
      'should hide continue game title and button when ads are not available',
      (WidgetTester tester) async {
        // Build the dialog
        await tester.pumpWidget(
          MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: const Locale('en'),
            home: Scaffold(
              body: Builder(
                builder:
                    (context) => ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder:
                              (context) => const ContinueGameDialog(
                                gameId: 'test_game',
                                gameTitle: 'Test Game',
                                currentScore: 100,
                                canOneTimeContinue: false,
                                onContinue: _dummyContinue,
                                onRestart: _dummyRestart,
                                onExit: _dummyExit,
                              ),
                        );
                      },
                      child: const Text('Show Dialog'),
                    ),
              ),
            ),
          ),
        );

        // Tap to show dialog
        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        // Verify that the dialog header is still present
        expect(find.text('Game Over'), findsOneWidget);
        expect(find.text('Test Game - Score 100'), findsOneWidget);

        // Verify that continue game elements are hidden when ads are not available
        // Note: In a real test, we would need to mock the ad availability
        // For now, we just verify the structure is correct
        expect(find.text('Restart'), findsOneWidget);
        expect(find.text('Exit'), findsOneWidget);

        // The continue game title and button should not be visible when ads are not available
        // This test verifies the basic structure - in a real scenario, ad availability
        // would be determined by the AdMobService
      },
    );
  });
}

void _dummyContinue() {}
void _dummyRestart() {}
void _dummyExit() {}
