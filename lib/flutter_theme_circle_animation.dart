/// A Flutter package that provides a beautiful circle reveal animation
/// for theme switching, similar to Telegram's theme transition effect.
///
/// ## Quick Start
///
/// 1. Wrap your content with [ThemeCircleAnimation]:
/// ```dart
/// ThemeCircleAnimation(
///   child: Scaffold(...),
/// )
/// ```
///
/// 2. Use [ThemeCircleSwitch] or trigger manually:
/// ```dart
/// ThemeCircleAnimation.of(context)?.toggle(
///   onToggle: () => setState(() => isDark = !isDark),
/// );
/// ```
library;

export 'src/theme_circle_animation_wrapper.dart'
    show ThemeCircleAnimation, ThemeCircleAnimationState;
export 'src/theme_circle_switch.dart' show ThemeCircleSwitch;
