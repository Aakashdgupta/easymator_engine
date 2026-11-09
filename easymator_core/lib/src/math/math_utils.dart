import 'dart:math' as math;
import 'package:vector_math/vector_math_64.dart';

/// Fundamental math utilities and tolerances for 2D skeletal animation.
class MathUtils {
  MathUtils._();

  /// Standard epsilon tolerance for floating-point comparisons.
  static const double epsilon = 1e-6;

  /// Full turn in radians ($2\pi$).
  static const double twoPi = math.pi * 2.0;

  /// Half turn in radians ($\pi$).
  static const double pi = math.pi;

  /// Converts degrees to radians.
  static double degToRad(double deg) => deg * (math.pi / 180.0);

  /// Converts radians to degrees.
  static double radToDeg(double rad) => rad * (180.0 / math.pi);

  /// Clamps a radian value to $[-\pi, \pi]$.
  static double normalizeAngle(double angle) {
    angle = angle % twoPi;
    if (angle > pi) {
      angle -= twoPi;
    } else if (angle < -pi) {
      angle += twoPi;
    }
    return angle;
  }

  /// Calculates the shortest angular difference between [from] and [to] in radians.
  /// Result is in $[-\pi, \pi]$.
  static double shortestAngleDiff(double from, double to) {
    return normalizeAngle(to - from);
  }

  /// Interpolates between two angles [a] and [b] by [t] along the shortest arc.
  static double slerpAngle(double a, double b, double t) {
    final diff = shortestAngleDiff(a, b);
    return normalizeAngle(a + diff * t);
  }

  /// Standard linear interpolation for doubles.
  static double lerpDouble(double a, double b, double t) {
    return a + (b - a) * t;
  }

  /// Linear interpolation between two [Vector3] instances, storing the result in [result]
  /// to avoid heap allocation.
  static Vector3 lerpVector3(Vector3 a, Vector3 b, double t, [Vector3? result]) {
    final out = result ?? Vector3.zero();
    out.x = a.x + (b.x - a.x) * t;
    out.y = a.y + (b.y - a.y) * t;
    out.z = a.z + (b.z - a.z) * t;
    return out;
  }

  /// Returns true if two floating-point numbers are equal within [delta].
  static bool closeTo(double a, double b, [double delta = epsilon]) {
    return (a - b).abs() <= delta;
  }
}
