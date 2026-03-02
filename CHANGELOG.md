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
