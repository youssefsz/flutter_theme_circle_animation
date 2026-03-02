import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'circle_reveal_clipper.dart';

/// A widget that enables circle-reveal theme animations.
///
/// Wrap your app content with this widget to enable the circle reveal
/// animation when switching themes.
///
/// ```dart
/// MaterialApp(
///   theme: isDark ? ThemeData.dark() : ThemeData.light(),
///   home: ThemeCircleAnimation(
///     child: MyHomePage(),
///   ),
/// );
/// ```
///
/// Then trigger the animation from anywhere:
/// ```dart
/// ThemeCircleAnimation.of(context)?.toggle(
///   onToggle: () => setState(() => isDark = !isDark),
/// );
/// ```
class ThemeCircleAnimation extends StatefulWidget {
  /// The child widget to wrap.
  final Widget child;

  /// Default duration of the circle reveal animation.
  final Duration duration;

  /// Default curve of the circle reveal animation.
  final Curve curve;

  const ThemeCircleAnimation({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 500),
    this.curve = Curves.easeInOutCubic,
  });

  /// Access the [ThemeCircleAnimationState] from the widget tree.
  ///
  /// Returns `null` if no [ThemeCircleAnimation] ancestor is found.
  static ThemeCircleAnimationState? of(BuildContext context) {
    return context.findAncestorStateOfType<ThemeCircleAnimationState>();
  }

  @override
  ThemeCircleAnimationState createState() => ThemeCircleAnimationState();
}

/// State for [ThemeCircleAnimation].
///
/// Use [toggle] to trigger the circle reveal animation.
class ThemeCircleAnimationState extends State<ThemeCircleAnimation>
    with SingleTickerProviderStateMixin {
  final GlobalKey _repaintBoundaryKey = GlobalKey();

  late AnimationController _controller;
  late Animation<double> _animation;

  ui.Image? _capturedImage;
  Offset _animationOrigin = Offset.zero;
  bool _isAnimating = false;
  bool _isReversed = false;
  double _maxRadius = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation = CurvedAnimation(parent: _controller, curve: widget.curve);
  }

  @override
  void didUpdateWidget(ThemeCircleAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_isAnimating) {
      if (widget.duration != oldWidget.duration) {
        _controller.duration = widget.duration;
      }
      if (widget.curve != oldWidget.curve) {
        _animation = CurvedAnimation(parent: _controller, curve: widget.curve);
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _capturedImage?.dispose();
    super.dispose();
  }

  /// Whether an animation is currently in progress.
  bool get isAnimating => _isAnimating;

  /// Capture the current screen content as an image.
  Future<ui.Image?> _captureScreen() async {
    try {
      final boundary =
          _repaintBoundaryKey.currentContext?.findRenderObject()
              as RenderRepaintBoundary?;
      if (boundary == null) return null;

      final pixelRatio = MediaQuery.of(context).devicePixelRatio;
      return await boundary.toImage(pixelRatio: pixelRatio);
    } catch (e) {
      debugPrint('ThemeCircleAnimation: Error capturing screen: $e');
      return null;
    }
  }

  /// Calculate the max radius needed to cover the entire screen from [origin].
  double _calculateMaxRadius(Size screenSize, Offset origin) {
    final corners = [
      Offset.zero,
      Offset(screenSize.width, 0),
      Offset(0, screenSize.height),
      Offset(screenSize.width, screenSize.height),
    ];
    return corners.map((c) => (origin - c).distance).reduce(max);
  }

  /// Computes the center position of a widget in global coordinates.
  ///
  /// Returns `null` if the render object cannot be found or has no size.
  static Offset? originFromContext(BuildContext context) {
    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return null;
    return box.localToGlobal(Offset(box.size.width / 2, box.size.height / 2));
  }

  /// Toggle the theme with a circle reveal animation originating from
  /// the given widget's position.
  ///
  /// This is a convenience wrapper around [toggle] that automatically
  /// computes the animation origin from the widget's [BuildContext].
  ///
  /// ```dart
  /// ElevatedButton(
  ///   onPressed: () {
  ///     ThemeCircleAnimation.of(context)?.toggleFromWidget(
  ///       context: context,
  ///       onToggle: () => setState(() => isDark = !isDark),
  ///     );
  ///   },
  ///   child: Text('Switch Theme'),
  /// )
  /// ```
  Future<void> toggleFromWidget({
    required BuildContext context,
    required VoidCallback onToggle,
    Duration? duration,
    Curve? curve,
    bool isReverse = false,
  }) {
    return toggle(
      onToggle: onToggle,
      origin: originFromContext(context),
      duration: duration,
      curve: curve,
      isReverse: isReverse,
    );
  }

  /// Toggle the theme with a circle reveal animation.
  ///
  /// [onToggle] is called to switch the theme. This is where you update
  /// your theme state. Works with any state management solution.
  ///
  /// [origin] is the screen position from which the circle expands.
  /// Defaults to the center of the screen if not provided.
  ///
  /// [duration] overrides the default animation duration for this toggle.
  ///
  /// [curve] overrides the default animation curve for this toggle.
  ///
  /// [isReverse] when true shrinks the circle revealing the new theme, instead of expanding.
  Future<void> toggle({
    required VoidCallback onToggle,
    Offset? origin,
    Duration? duration,
    Curve? curve,
    bool isReverse = false,
  }) async {
    if (_isAnimating) return;
    _isAnimating = true;

    // 1. Wait for the current frame to finish painting, then capture
    await WidgetsBinding.instance.endOfFrame;
    if (!mounted) {
      _isAnimating = false;
      return;
    }

    final image = await _captureScreen();
    if (image == null || !mounted) {
      onToggle();
      _isAnimating = false;
      return;
    }

    // 2. Calculate animation parameters
    final screenSize = MediaQuery.of(context).size;
    _animationOrigin =
        origin ?? Offset(screenSize.width / 2, screenSize.height / 2);
    _maxRadius = _calculateMaxRadius(screenSize, _animationOrigin);
    _capturedImage = image;
    _isReversed = isReverse;

    // 3. Apply per-call overrides
    if (duration != null) _controller.duration = duration;
    if (curve != null) {
      _animation = CurvedAnimation(parent: _controller, curve: curve);
    }

    // 4. Toggle the theme (user switches their state)
    onToggle();

    // 5. Show the overlay
    setState(() {});

    // 6. Wait for the new theme to render one frame
    await WidgetsBinding.instance.endOfFrame;

    // 7. Run the circle reveal animation
    try {
      await _controller.forward(from: 0.0);
    } on TickerCanceled {
      // Widget was disposed during animation — clean up silently
    }

    // 8. Cleanup
    _cleanup(duration, curve);
  }

  void _cleanup(Duration? overrideDuration, Curve? overrideCurve) {
    _capturedImage?.dispose();
    _capturedImage = null;
    _isAnimating = false;
    _isReversed = false;
    _controller.reset();

    // Restore defaults if overrides were applied
    if (overrideDuration != null) _controller.duration = widget.duration;
    if (overrideCurve != null) {
      _animation = CurvedAnimation(parent: _controller, curve: widget.curve);
    }

    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Bottom layer: actual content (shows NEW theme after toggle)
        RepaintBoundary(key: _repaintBoundaryKey, child: widget.child),

        // Top layer: screenshot overlay (shows OLD theme)
        // A growing circular hole reveals the new theme underneath
        if (_isAnimating && _capturedImage != null)
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return ClipPath(
                  clipper: CircleRevealClipper(
                    center: _animationOrigin,
                    radius: _isReversed
                        ? _maxRadius * (1 - _animation.value)
                        : _maxRadius * _animation.value,
                    isReverse: _isReversed,
                  ),
                  child: child,
                );
              },
              child: IgnorePointer(
                child: _ScreenshotWidget(image: _capturedImage!),
              ),
            ),
          ),
      ],
    );
  }
}

/// Renders a captured [ui.Image] to fill the entire available space.
class _ScreenshotWidget extends LeafRenderObjectWidget {
  final ui.Image image;

  const _ScreenshotWidget({required this.image});

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderScreenshot(image: image);
  }

  @override
  void updateRenderObject(
    BuildContext context,
    _RenderScreenshot renderObject,
  ) {
    renderObject.image = image;
  }
}

class _RenderScreenshot extends RenderBox {
  ui.Image _image;

  _RenderScreenshot({required ui.Image image}) : _image = image;

  set image(ui.Image value) {
    if (_image == value) return;
    _image = value;
    markNeedsPaint();
  }

  @override
  bool get sizedByParent => true;

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    return constraints.biggest;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final src = Rect.fromLTWH(
      0,
      0,
      _image.width.toDouble(),
      _image.height.toDouble(),
    );
    final dst = offset & size;
    context.canvas.drawImageRect(_image, src, dst, Paint());
  }
}
