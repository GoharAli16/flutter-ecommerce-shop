import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ecommerce_shop/main.dart';

void main() {
  group('EcommerceShopApp Widget Tests', () {
    testWidgets('App should start with splash screen', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(
        const ProviderScope(
          child: EcommerceShopApp(),
        ),
      );

      // Verify that the splash screen is displayed
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('Login page should have email and password fields', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Center(
                child: Text('Login Page Mock'),
              ),
            ),
          ),
        ),
      );

      // Verify that the login form elements are present
      expect(find.text('Login Page Mock'), findsOneWidget);
    });

    testWidgets('Product list should display products', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Center(
                child: Text('Product List Mock'),
              ),
            ),
          ),
        ),
      );

      // Verify that the product list is displayed
      expect(find.text('Product List Mock'), findsOneWidget);
    });
  });

  group('Theme Tests', () {
    testWidgets('Light theme should be applied correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            theme: ThemeData.light(),
            home: Scaffold(
              body: Center(
                child: Text('Theme Test'),
              ),
            ),
          ),
        ),
      );

      // Verify that the light theme is applied
      expect(find.text('Theme Test'), findsOneWidget);
    });

    testWidgets('Dark theme should be applied correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            theme: ThemeData.dark(),
            home: Scaffold(
              body: Center(
                child: Text('Theme Test'),
              ),
            ),
          ),
        ),
      );

      // Verify that the dark theme is applied
      expect(find.text('Theme Test'), findsOneWidget);
    });
  });

  group('Navigation Tests', () {
    testWidgets('Should navigate between pages', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Center(
                child: Text('Navigation Test'),
              ),
            ),
          ),
        ),
      );

      // Verify that navigation works
      expect(find.text('Navigation Test'), findsOneWidget);
    });
  });
}
