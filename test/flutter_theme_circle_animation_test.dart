import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_theme_circle_animation/flutter_theme_circle_animation.dart';

void main() {
  group('ThemeCircleAnimation', () {
    testWidgets('can be found via .of(context)', (tester) async {
      ThemeCircleAnimationState? foundState;

      await tester.pumpWidget(
        MaterialApp(
          home: ThemeCircleAnimation(
            child: Builder(
              builder: (context) {
                foundState = ThemeCircleAnimation.of(context);
                return const SizedBox();
              },
            ),
          ),
        ),
      );

      expect(foundState, isNotNull);
      expect(foundState!.isAnimating, isFalse);
    });

    testWidgets('renders child widget', (tester) async {
      await tester.pumpWidget(
        MaterialApp(home: ThemeCircleAnimation(child: const Text('Hello'))),
      );

      expect(find.text('Hello'), findsOneWidget);
    });
  });

  group('ThemeCircleSwitch', () {
    testWidgets('renders light mode icon', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ThemeCircleAnimation(
            child: ThemeCircleSwitch(isDarkMode: false, onToggle: () {}),
          ),
        ),
      );

      expect(find.byIcon(Icons.light_mode_rounded), findsOneWidget);
    });

    testWidgets('renders dark mode icon', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ThemeCircleAnimation(
            child: ThemeCircleSwitch(isDarkMode: true, onToggle: () {}),
          ),
        ),
      );

      expect(find.byIcon(Icons.dark_mode_rounded), findsOneWidget);
    });
  });
}
