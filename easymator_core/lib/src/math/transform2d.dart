import 'dart:math' as math;
import 'package:vector_math/vector_math_64.dart';

/// Optimized, zero-allocation 2D transformation math operating directly on [Matrix4].
///
/// In skeletal animation, allocating new [Matrix4] instances on every frame causes
/// severe garbage collection thrashing. [Transform2D] mutates existing [Float64List]
/// storage buffers directly.
class Transform2D {
  Transform2D._();

  /// Composes a 2D Translation-Rotation-Scale transformation directly into [target]'s
  /// internal storage buffer without intermediate object creation.
  ///
  /// [rotation] is in radians around the Z-axis.
  static void composeInto(
    Matrix4 target, {
    required double tx,
    required double ty,
    double tz = 0.0,
    required double rotation,
    required double sx,
    required double sy,
    double sz = 1.0,
  }) {
    final s = target.storage;
    final c = math.cos(rotation);
    final sin = math.sin(rotation);

    // Column 0: X-axis vector
    s[0] = sx * c;
    s[1] = sx * sin;
    s[2] = 0.0;
    s[3] = 0.0;

    // Column 1: Y-axis vector
    s[4] = -sy * sin;
    s[5] = sy * c;
    s[6] = 0.0;
    s[7] = 0.0;

    // Column 2: Z-axis vector
    s[8] = 0.0;
    s[9] = 0.0;
    s[10] = sz;
    s[11] = 0.0;

    // Column 3: Translation vector
    s[12] = tx;
    s[13] = ty;
    s[14] = tz;
    s[15] = 1.0;
  }

  /// Multiplies matrix [a] by matrix [b] ($a \times b$) and writes the result into [result].
  static void multiplyInto(Matrix4 a, Matrix4 b, Matrix4 result) {
    result.setFrom(a);
    result.multiply(b);
  }

  /// Transforms a 2D point ([x], [y]) by [matrix] into [result].
  static Vector3 transformPoint(Matrix4 matrix, double x, double y, [Vector3? result]) {
    final out = result ?? Vector3.zero();
    final s = matrix.storage;
    out.x = s[0] * x + s[4] * y + s[12];
    out.y = s[1] * x + s[5] * y + s[13];
    out.z = s[2] * x + s[6] * y + s[14];
    return out;
  }

  /// Inverts [matrix] and writes the result into [result].
  ///
  /// Returns `true` if the matrix was successfully inverted, `false` if singular.
  static bool invertInto(Matrix4 matrix, Matrix4 result) {
    result.setFrom(matrix);
    final det = result.invert();
    return det != 0.0;
  }

  /// Extracts the 2D world rotation in radians from a transformation matrix.
  static double extractRotationZ(Matrix4 matrix) {
    final s = matrix.storage;
    // Rotation is atan2 of the Y component over the X component of column 0
    return math.atan2(s[1], s[0]);
  }

  /// Extracts the 2D world scale factors from a transformation matrix.
  static Vector3 extractScale(Matrix4 matrix, [Vector3? result]) {
    final out = result ?? Vector3.zero();
    final s = matrix.storage;
    out.x = math.sqrt(s[0] * s[0] + s[1] * s[1] + s[2] * s[2]);
    out.y = math.sqrt(s[4] * s[4] + s[5] * s[5] + s[6] * s[6]);
    out.z = math.sqrt(s[8] * s[8] + s[9] * s[9] + s[10] * s[10]);
    return out;
  }

  /// Extracts the 2D world translation from a transformation matrix.
  static Vector3 extractTranslation(Matrix4 matrix, [Vector3? result]) {
    final out = result ?? Vector3.zero();
    final s = matrix.storage;
    out.x = s[12];
    out.y = s[13];
    out.z = s[14];
    return out;
  }
}
