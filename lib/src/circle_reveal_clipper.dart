import 'package:flutter/material.dart';

/// A clipper that creates a circular hole in the UI.
/// Used to reveal the layer underneath.
class CircleRevealClipper extends CustomClipper<Path> {
  final Offset center;
  final double radius;

  final bool isReverse;

  CircleRevealClipper({
    required this.center,
    required this.radius,
    this.isReverse = false,
  });

  @override
  Path getClip(Size size) {
    if (isReverse) {
      return Path()..addOval(Rect.fromCircle(center: center, radius: radius));
    }
    return Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addOval(Rect.fromCircle(center: center, radius: radius))
      ..fillType = PathFillType.evenOdd;
  }

  @override
  bool shouldReclip(covariant CircleRevealClipper oldClipper) {
    return center != oldClipper.center ||
        radius != oldClipper.radius ||
        isReverse != oldClipper.isReverse;
  }
}
