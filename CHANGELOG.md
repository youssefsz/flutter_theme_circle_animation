## 1.0.2

* Updated `homepage` URL in `pubspec.yaml` to point to the new interactive landing page.

## 1.0.1

* **Fix**: Restrict supported platforms to Android and iOS in `pubspec.yaml` to prevent pub.dev from displaying unsupported platform badges like Linux, macOS, web, and Windows.

## 1.0.0

* **New Feature**: Added support for reverse animation! Shrinking circles can now be used when switching back to light mode.
* Added `isReverse` parameter to `ThemeCircleAnimation.of(context)?.toggle()` and `toggleFromWidget()`.
* Added `enableReverseAnimation` parameter to `ThemeCircleSwitch` (defaults to `true`).
* Updated example to showcase forward and reverse animations.

## 0.0.1

Initial release.

* Circle reveal animation for theme switching on Android and iOS.
* `ThemeCircleAnimation` wrapper widget with configurable duration and curve.
* `ThemeCircleSwitch` toggle button with animated sun/moon icon.
* Programmatic API via `toggle()` and `toggleFromWidget()`.
* Screenshot-based transition using `RepaintBoundary`.
* Zero external dependencies.
