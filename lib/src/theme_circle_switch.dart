import 'package:flutter/material.dart';

import 'theme_circle_animation_wrapper.dart';

/// A pre-built toggle button that triggers the [ThemeCircleAnimation].
///
/// Place this anywhere inside a [ThemeCircleAnimation] widget tree.
///
/// ```dart
/// ThemeCircleSwitch(
///   isDarkMode: isDark,
///   onToggle: () => setState(() => isDark = !isDark),
/// )
/// ```
class ThemeCircleSwitch extends StatelessWidget {
  /// Whether dark mode is currently active.
  final bool isDarkMode;

  /// Called to toggle the theme. Update your theme state here.
  final VoidCallback onToggle;

  /// Icon shown when in dark mode.
  /// Defaults to [Icons.dark_mode_rounded] in white.
  final Widget? darkModeIcon;

  /// Icon shown when in light mode.
  /// Defaults to [Icons.light_mode_rounded] in amber.
  final Widget? lightModeIcon;

  /// Duration of the icon switch animation.
  final Duration iconTransitionDuration;

  /// Size of the icon.
  final double? iconSize;

  /// Tooltip for the button.
  final String? tooltip;

  /// Whether to play the animation in reverse when switching back to light mode.
  /// Defaults to true.
  final bool enableReverseAnimation;

  const ThemeCircleSwitch({
    super.key,
    required this.isDarkMode,
    required this.onToggle,
    this.darkModeIcon,
    this.lightModeIcon,
    this.iconTransitionDuration = const Duration(milliseconds: 300),
    this.iconSize,
    this.tooltip,
    this.enableReverseAnimation = true,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: tooltip ?? 'Toggle theme',
      iconSize: iconSize,
      icon: AnimatedSwitcher(
        duration: iconTransitionDuration,
        transitionBuilder: (child, animation) {
          return ScaleTransition(scale: animation, child: child);
        },
        child: isDarkMode
            ? (darkModeIcon ??
                  Icon(
                    Icons.dark_mode_rounded,
                    key: const ValueKey('theme_dark'),
                    color: Colors.white,
                    size: iconSize,
                  ))
            : (lightModeIcon ??
                  Icon(
                    Icons.light_mode_rounded,
                    key: const ValueKey('theme_light'),
                    color: Colors.amber,
                    size: iconSize,
                  )),
      ),
      onPressed: () {
        final animState = ThemeCircleAnimation.of(context);
        if (animState != null) {
          animState.toggleFromWidget(
            context: context,
            onToggle: onToggle,
            isReverse: enableReverseAnimation ? isDarkMode : false,
          );
        } else {
          // No ThemeCircleAnimation ancestor — just toggle directly
          onToggle();
          debugPrint(
            'ThemeCircleSwitch: No ThemeCircleAnimation ancestor found. '
            'Wrap your content with ThemeCircleAnimation to enable '
            'the circle reveal animation.',
          );
        }
      },
    );
  }
}
