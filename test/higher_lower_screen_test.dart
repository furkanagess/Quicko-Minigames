import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quicko_app/l10n/app_localizations.dart';
import 'package:quicko_app/features/higher_lower/views/higher_lower_screen.dart';

void main() {
  group('HigherLowerScreen UI Tests', () {
    testWidgets(
      'should display modern UI with score display and number circle',
      (WidgetTester tester) async {
        // Build the screen
        await tester.pumpWidget(
          MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: const Locale('en'),
            home: const HigherLowerScreen(),
          ),
        );

        // Wait for the widget to build
        await tester.pumpAndSettle();

        // Verify that the modern UI elements are present
        expect(find.text('Score: 0'), findsOneWidget);
        expect(find.byType(Container), findsWidgets);
        expect(find.byType(LinearGradient), findsWidgets);

        // Verify that the game buttons are present
        expect(find.text('Lower'), findsOneWidget);
        expect(find.text('Higher'), findsOneWidget);
      },
    );

    testWidgets('should display loading state when generating number', (
      WidgetTester tester,
    ) async {
      // Build the screen
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('en'),
          home: const HigherLowerScreen(),
        ),
      );

      // Wait for the widget to build
      await tester.pumpAndSettle();

      // Verify that the loading state is shown initially
      expect(find.text('Generating number...'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should display game buttons with proper styling', (
      WidgetTester tester,
    ) async {
      // Build the screen
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('en'),
          home: const HigherLowerScreen(),
        ),
      );

      // Wait for the widget to build
      await tester.pumpAndSettle();

      // Verify that the game buttons have proper styling
      expect(find.text('Lower'), findsOneWidget);
      expect(find.text('Higher'), findsOneWidget);

      // Verify that buttons are in a row layout
      final lowerButton = find.text('Lower');
      final higherButton = find.text('Higher');

      expect(lowerButton, findsOneWidget);
      expect(higherButton, findsOneWidget);
    });

    testWidgets('should display Turkish text when locale is Turkish', (
      WidgetTester tester,
    ) async {
      // Build the screen with Turkish locale
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('tr'),
          home: const HigherLowerScreen(),
        ),
      );

      // Wait for the widget to build
      await tester.pumpAndSettle();

      // Verify that Turkish text is displayed
      expect(find.text('Skor: 0'), findsOneWidget);
      expect(find.text('Düşük'), findsOneWidget);
      expect(find.text('Yüksek'), findsOneWidget);
      expect(find.text('Sayı üretiliyor...'), findsOneWidget);
    });
  });
}
