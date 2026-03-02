import 'package:flutter/material.dart';
import 'package:flutter_theme_circle_animation/flutter_theme_circle_animation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false;
  bool _enableReverseAnimation = true;

  ThemeData get _lightTheme => ThemeData(
    brightness: Brightness.light,
    colorSchemeSeed: Colors.blue,
    useMaterial3: true,
  );

  ThemeData get _darkTheme => ThemeData(
    brightness: Brightness.dark,
    colorSchemeSeed: Colors.blue,
    useMaterial3: true,
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Theme Circle Animation Demo',
      debugShowCheckedModeBanner: false,
      theme: _isDarkMode ? _darkTheme : _lightTheme,
      home: ThemeCircleAnimation(
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
        child: _HomeScreen(
          isDarkMode: _isDarkMode,
          enableReverseAnimation: _enableReverseAnimation,
          onToggle: () => setState(() => _isDarkMode = !_isDarkMode),
          onToggleReverseAnimation: (value) =>
              setState(() => _enableReverseAnimation = value),
        ),
      ),
    );
  }
}

class _HomeScreen extends StatelessWidget {
  final bool isDarkMode;
  final bool enableReverseAnimation;
  final VoidCallback onToggle;
  final ValueChanged<bool> onToggleReverseAnimation;

  const _HomeScreen({
    required this.isDarkMode,
    required this.enableReverseAnimation,
    required this.onToggle,
    required this.onToggleReverseAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Theme Circle Animation'),
        actions: [
          // Option 1: Use the pre-built ThemeCircleSwitch
          ThemeCircleSwitch(
            isDarkMode: isDarkMode,
            onToggle: onToggle,
            enableReverseAnimation: enableReverseAnimation,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isDarkMode ? Icons.nightlight_round : Icons.wb_sunny,
              size: 80,
              color: isDarkMode ? Colors.amber : Colors.orange,
            ),
            const SizedBox(height: 24),
            Text(
              isDarkMode ? 'Dark Mode' : 'Light Mode',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            Text(
              'Tap the icon in the app bar\nor the button below',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withAlpha(153),
              ),
            ),
            const SizedBox(height: 24),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: SwitchListTile(
                title: const Text('Reverse Animation'),
                subtitle: const Text(
                  'Shrink circle when returning to Light Mode',
                ),
                value: enableReverseAnimation,
                onChanged: onToggleReverseAnimation,
              ),
            ),
            const SizedBox(height: 24),

            // Option 2: Trigger programmatically from any widget
            Builder(
              builder: (buttonContext) {
                return FilledButton.icon(
                  onPressed: () {
                    ThemeCircleAnimation.of(buttonContext)?.toggleFromWidget(
                      context: buttonContext,
                      onToggle: onToggle,
                      isReverse: enableReverseAnimation ? isDarkMode : false,
                    );
                  },
                  icon: const Icon(Icons.palette),
                  label: const Text('Switch Theme'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
