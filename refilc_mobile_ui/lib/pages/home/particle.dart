// MIT License

// Copyright (c) 2018 Norbert Kozsir

// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:

// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

// ignore_for_file: invalid_use_of_protected_member

import 'dart:math';
import 'package:flutter/material.dart';

typedef ParticleBuilder = Particle Function(int index);

abstract class Particle {
  void paint(Canvas canvas, Size size, double progress, int seed);
}

class FourRandomSlotParticle extends Particle {
  final List<Particle> children;

  final double relativeDistanceToMiddle;

  FourRandomSlotParticle(
      {required this.children, this.relativeDistanceToMiddle = 2.0});

  @override
  void paint(Canvas canvas, Size size, double progress, int seed) {
    Random random = Random(seed);
    int side = 0;
    for (Particle particle in children) {
      PositionedParticle(
        position: sideToOffset(side, size, random) * relativeDistanceToMiddle,
        child: particle,
      ).paint(canvas, size, progress, seed);
      side++;
    }
  }

  Offset sideToOffset(int side, Size size, Random random) {
    if (side == 0) {
      return Offset(-random.nextDouble() * (size.width / 2),
          -random.nextDouble() * (size.height / 2));
    } else if (side == 1) {
      return Offset(random.nextDouble() * (size.width / 2),
          -random.nextDouble() * (size.height / 2));
    } else if (side == 2) {
      return Offset(random.nextDouble() * (size.width / 2),
          random.nextDouble() * (size.height / 2));
    } else if (side == 3) {
      return Offset(-random.nextDouble() * (size.width / 2),
          random.nextDouble() * (size.height / 2));
    } else {
      throw Exception();
    }
  }

  double randomOffset(Random random, int range) {
    return range / 2 - random.nextInt(range);
  }
}

class PoppingCircle extends Particle {
  final Color color;

  PoppingCircle({required this.color});

  final double radius = 3.0;

  @override
  void paint(Canvas canvas, Size size, double progress, seed) {
    if (progress < 0.5) {
      canvas.drawCircle(
          Offset.zero,
          radius + (progress * 8),
          Paint()
            ..color = color
            ..style = PaintingStyle.stroke
            ..strokeWidth = 5.0 - progress * 2);
    } else {
      CircleMirror(
        numberOfParticles: 4,
        child: AnimatedPositionedParticle(
            begin: const Offset(0.0, 5.0),
            end: const Offset(0.0, 15.0),
            child: FadingRect(
              color: color,
              height: 7.0,
              width: 2.0,
            )),
        initialRotation: pi / 4,
      ).paint(canvas, size, progress, seed);
    }
  }
}

class Firework extends Particle {
  @override
  void paint(Canvas canvas, Size size, double progress, int seed) {
    FourRandomSlotParticle(children: [
      IntervalParticle(
        interval: const Interval(0.0, 0.5, curve: Curves.easeIn),
        child: PoppingCircle(
          color: Colors.deepOrangeAccent,
        ),
      ),
      IntervalParticle(
        interval: const Interval(0.2, 0.5, curve: Curves.easeIn),
        child: PoppingCircle(
          color: Colors.green,
        ),
      ),
      IntervalParticle(
        interval: const Interval(0.4, 0.8, curve: Curves.easeIn),
        child: PoppingCircle(
          color: Colors.indigo,
        ),
      ),
      IntervalParticle(
        interval: const Interval(0.5, 1.0, curve: Curves.easeIn),
        child: PoppingCircle(
          color: Colors.teal,
        ),
      ),
    ]).paint(canvas, size, progress, seed);
  }
}

/// Mirrors a given particle around a circle.
///
/// When using the default constructor you specify one [Particle], this particle
/// is going to be used on its own, this implies that
/// all mirrored particles are identical (expect for the rotation around the circle)
class CircleMirror extends Particle {
  final ParticleBuilder particleBuilder;

  final double initialRotation;

  final int numberOfParticles;

  CircleMirror.builder(
      {required this.particleBuilder,
      required this.initialRotation,
      required this.numberOfParticles});

  CircleMirror(
      {required Particle child,
      required this.initialRotation,
      required this.numberOfParticles})
      : particleBuilder = ((index) => child);

  @override
  void paint(Canvas canvas, Size size, double progress, seed) {
    canvas.save();
    canvas.rotate(initialRotation);
    for (int i = 0; i < numberOfParticles; i++) {
      particleBuilder(i).paint(canvas, size, progress, seed);
      canvas.rotate(pi / (numberOfParticles / 2));
    }
    canvas.restore();
  }
}

/// Mirrors a given particle around a circle.
///
/// When using the default constructor you specify one [Particle], this particle
/// is going to be used on its own, this implies that
/// all mirrored particles are identical (expect for the rotation around the circle)
class RectangleMirror extends Particle {
  final ParticleBuilder particleBuilder;

  /// Position of the first particle on the rect
  final double initialDistance;

  final int numberOfParticles;

  RectangleMirror.builder(
      {required this.particleBuilder,
      required this.initialDistance,
      required this.numberOfParticles});

  RectangleMirror(
      {required Particle child,
      required this.initialDistance,
      required this.numberOfParticles})
      : particleBuilder = ((index) => child);

  @override
  void paint(Canvas canvas, Size size, double progress, seed) {
    canvas.save();
    double totalLength = size.width * 2 + size.height * 2;
    double distanceBetweenParticles = totalLength / numberOfParticles;

    bool onHorizontalAxis = true;
    int side = 0;

    assert((distanceBetweenParticles * numberOfParticles).round() ==
        totalLength.round());

    canvas.translate(-size.width / 2, -size.height / 2);

    double currentDistance = initialDistance;
    for (int i = 0; i < numberOfParticles; i++) {
      while (true) {
        if (onHorizontalAxis
            ? currentDistance > size.width
            : currentDistance > size.height) {
          currentDistance -= onHorizontalAxis ? size.width : size.height;
          onHorizontalAxis = !onHorizontalAxis;
          side = (++side) % 4;
        } else {
          if (side == 0) {
            assert(onHorizontalAxis);
            moveTo(canvas, size, 0, currentDistance, 0.0, () {
              particleBuilder(i).paint(canvas, size, progress, seed);
            });
          } else if (side == 1) {
            assert(!onHorizontalAxis);
            moveTo(canvas, size, 1, size.width, currentDistance, () {
              particleBuilder(i).paint(canvas, size, progress, seed);
            });
          } else if (side == 2) {
            assert(onHorizontalAxis);
            moveTo(canvas, size, 2, size.width - currentDistance, size.height,
                () {
              particleBuilder(i).paint(canvas, size, progress, seed);
            });
          } else if (side == 3) {
            assert(!onHorizontalAxis);
            moveTo(canvas, size, 3, 0.0, size.height - currentDistance, () {
              particleBuilder(i).paint(canvas, size, progress, seed);
            });
          }
          break;
        }
      }
      currentDistance += distanceBetweenParticles;
    }

    canvas.restore();
  }

  void moveTo(Canvas canvas, Size size, int side, double x, double y,
      VoidCallback painter) {
    canvas.save();
    canvas.translate(x, y);
    canvas.rotate(-atan2(size.width / 2 - x, size.height / 2 - y));
    painter();
    canvas.restore();
  }
}

/// Offsets a child by a given [Offset]
class PositionedParticle extends Particle {
  PositionedParticle({required this.position, required this.child});

  final Particle child;

  final Offset position;

  @override
  void paint(Canvas canvas, Size size, double progress, seed) {
    canvas.save();
    canvas.translate(position.dx, position.dy);
    child.paint(canvas, size, progress, seed);
    canvas.restore();
  }
}

/// Animates a childs position based on a Tween<Offset>
class AnimatedPositionedParticle extends Particle {
  AnimatedPositionedParticle(
      {required Offset begin, required Offset end, required this.child})
      : offsetTween = Tween<Offset>(begin: begin, end: end);

  final Particle child;

  final Tween<Offset> offsetTween;

  @override
  void paint(Canvas canvas, Size size, double progress, seed) {
    canvas.save();
    canvas.translate(
        offsetTween.lerp(progress).dx, offsetTween.lerp(progress).dy);
    child.paint(canvas, size, progress, seed);
    canvas.restore();
  }
}

/// Specifies an [Interval] for its child.
///
/// Instead of applying a curve the the input parameters of the paint method,
/// apply it with this Particle.
///
/// If you want you child to only animate from 0.0 - 0.5 (relative), specify an [Interval] with those values.
class IntervalParticle extends Particle {
  final Interval interval;

  final Particle child;

  IntervalParticle({required this.child, required this.interval});

  @override
  void paint(Canvas canvas, Size size, double progress, seed) {
    if (progress < interval.begin || progress > interval.end) return;
    child.paint(canvas, size, interval.transform(progress), seed);
  }
}

/// Does nothing else than holding a list of particles and painting them in that order
class CompositeParticle extends Particle {
  final List<Particle> children;

  CompositeParticle({required this.children});

  @override
  void paint(Canvas canvas, Size size, double progress, seed) {
    for (Particle particle in children) {
      particle.paint(canvas, size, progress, seed);
    }
  }
}

/// A particle which rotates the child.
///
/// Does not animate.
class RotationParticle extends Particle {
  final Particle child;

  final double rotation;

  RotationParticle({required this.child, required this.rotation});

  @override
  void paint(Canvas canvas, Size size, double progress, int seed) {
    canvas.save();
    canvas.rotate(rotation);
    child.paint(canvas, size, progress, seed);
    canvas.restore();
  }
}

/// A particle which rotates a child along a given [Tween]
class AnimatedRotationParticle extends Particle {
  final Particle child;

  final Tween<double> rotation;

  AnimatedRotationParticle(
      {required this.child, required double begin, required double end})
      : rotation = Tween<double>(begin: begin, end: end);

  @override
  void paint(Canvas canvas, Size size, double progress, int seed) {
    canvas.save();
    canvas.rotate(rotation.lerp(progress));
    child.paint(canvas, size, progress, seed);
    canvas.restore();
  }
}

/// Geometry
///
/// These are some basic geometric classes which also fade out as time goes on.
/// Each primitive should draw itself at the origin. If the orientation matters it should be directed to the top
/// (negative y)
///
/// A rectangle which also fades out over time.
class FadingRect extends Particle {
  final Color color;
  final double width;
  final double height;

  FadingRect({required this.color, required this.width, required this.height});

  @override
  void paint(Canvas canvas, Size size, double progress, seed) {
    canvas.drawRect(Rect.fromLTWH(0.0, 0.0, width, height),
        Paint()..color = color.withValues(alpha: 1 - progress));
  }
}

/// A circle which fades out over time
class FadingCircle extends Particle {
  final Color color;
  final double radius;

  FadingCircle({required this.color, required this.radius});

  @override
  void paint(Canvas canvas, Size size, double progress, seed) {
    canvas.drawCircle(Offset.zero, radius,
        Paint()..color = color.withValues(alpha: 1 - progress));
  }
}

/// A triangle which also fades out over time
class FadingTriangle extends Particle {
  /// This controls the shape of the triangle.
  ///
  /// Value between 0 and 1
  final double variation;

  final Color color;

  /// The size of the base side of the triangle.
  final double baseSize;

  /// This is the factor of how much bigger then length than the width is
  final double heightToBaseFactor;

  FadingTriangle(
      {required this.variation,
      required this.color,
      required this.baseSize,
      required this.heightToBaseFactor});

  @override
  void paint(Canvas canvas, Size size, double progress, int seed) {
    Path path = Path();
    path.moveTo(0.0, 0.0);
    path.lineTo(baseSize * variation, baseSize * heightToBaseFactor);
    path.lineTo(baseSize, 0.0);
    path.close();
    canvas.drawPath(
        path, Paint()..color = color.withValues(alpha: 1 - progress));
  }
}

/// An ugly looking "snake"
///
/// See for yourself
class FadingSnake extends Particle {
  final double width;
  final double segmentLength;
  final int segments;
  final double curvyness;

  final Color color;

  FadingSnake(
      {required this.width,
      required this.segmentLength,
      required this.segments,
      required this.curvyness,
      required this.color});

  @override
  void paint(Canvas canvas, Size size, double progress, int seed) {
    canvas.save();
    canvas.rotate(pi / 6);
    Path path = Path();
    for (int i = 0; i < segments; i++) {
      path.quadraticBezierTo(curvyness * i, segmentLength * (i + 1),
          curvyness * (i + 1), segmentLength * (i + 1));
    }
    for (int i = segments - 1; i >= 0; i--) {
      path.quadraticBezierTo(curvyness * (i + 1), segmentLength * i - curvyness,
          curvyness * i, segmentLength * i - curvyness);
    }
    path.close();
    canvas.drawPath(path, Paint()..color = color);
    canvas.restore();
  }
}
