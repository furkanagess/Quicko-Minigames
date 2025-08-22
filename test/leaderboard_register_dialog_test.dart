import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quicko_app/l10n/app_localizations.dart';
import 'package:quicko_app/shared/widgets/dialog/leaderboard_register_dialog.dart';

void main() {
  group('LeaderboardRegisterDialog Localization Tests', () {
    testWidgets('should display localized text in English', (
      WidgetTester tester,
    ) async {
      // Build the dialog with English localization
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
                            (context) => const LeaderboardRegisterDialog(
                              gameTitle: 'Test Game',
                              score: 100,
                              onSubmit: _dummySubmit,
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

      // Verify that English text is displayed
      expect(find.text('Congratulations!'), findsOneWidget);
      expect(find.text('Register for the leaderboard'), findsOneWidget);
      expect(find.text('Name'), findsOneWidget);
      expect(find.text('Country'), findsOneWidget);
      expect(find.text('Save'), findsOneWidget);
      expect(find.text('Give Up'), findsOneWidget);
    });

    testWidgets('should display localized text in Turkish', (
      WidgetTester tester,
    ) async {
      // Build the dialog with Turkish localization
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('tr'),
          home: Scaffold(
            body: Builder(
              builder:
                  (context) => ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder:
                            (context) => const LeaderboardRegisterDialog(
                              gameTitle: 'Test Game',
                              score: 100,
                              onSubmit: _dummySubmit,
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

      // Verify that Turkish text is displayed
      expect(find.text('Tebrikler!'), findsOneWidget);
      expect(find.text('Lider tablosuna kayıt olun'), findsOneWidget);
      expect(find.text('İsim'), findsOneWidget);
      expect(find.text('Ülke'), findsOneWidget);
      expect(find.text('Kaydet'), findsOneWidget);
      expect(find.text('Vazgeç'), findsOneWidget);
    });

    testWidgets('should display localized text in Spanish', (
      WidgetTester tester,
    ) async {
      // Build the dialog with Spanish localization
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('es'),
          home: Scaffold(
            body: Builder(
              builder:
                  (context) => ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder:
                            (context) => const LeaderboardRegisterDialog(
                              gameTitle: 'Test Game',
                              score: 100,
                              onSubmit: _dummySubmit,
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

      // Verify that Spanish text is displayed
      expect(find.text('¡Felicitaciones!'), findsOneWidget);
      expect(find.text('Regístrate en la tabla de posiciones'), findsOneWidget);
      expect(find.text('Nombre'), findsOneWidget);
      expect(find.text('País'), findsOneWidget);
      expect(find.text('Guardar'), findsOneWidget);
      expect(find.text('Renunciar'), findsOneWidget);
    });
  });
}

void _dummySubmit({required String name, required String countryCode}) {
  // Dummy function for testing
}
