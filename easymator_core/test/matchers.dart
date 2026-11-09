import 'package:test/test.dart';
import 'package:vector_math/vector_math_64.dart';

/// Custom matcher to verify two [Vector3] instances match within [delta].
Matcher closeToVector(Vector3 expected, [double delta = 1e-4]) => _CloseToVectorMatcher(expected, delta);

class _CloseToVectorMatcher extends Matcher {
  final Vector3 expected;
  final double delta;

  _CloseToVectorMatcher(this.expected, this.delta);

  @override
  bool matches(dynamic item, Map matchState) {
    if (item is! Vector3) return false;
    return (item.x - expected.x).abs() <= delta &&
        (item.y - expected.y).abs() <= delta &&
        (item.z - expected.z).abs() <= delta;
  }

  @override
  Description describe(Description description) =>
      description.add('Vector3 close to $expected within delta $delta');

  @override
  Description describeMismatch(
    dynamic item,
    Description mismatchDescription,
    Map matchState,
    bool verbose,
  ) {
    if (item is! Vector3) {
      return mismatchDescription.add('is not a Vector3');
    }
    return mismatchDescription.add(
      'differed by (${(item.x - expected.x).abs()}, ${(item.y - expected.y).abs()}, ${(item.z - expected.z).abs()})',
    );
  }
}

/// Custom matcher to verify two [Matrix4] instances match within [delta].
Matcher closeToMatrix(Matrix4 expected, [double delta = 1e-4]) => _CloseToMatrixMatcher(expected, delta);

class _CloseToMatrixMatcher extends Matcher {
  final Matrix4 expected;
  final double delta;

  _CloseToMatrixMatcher(this.expected, this.delta);

  @override
  bool matches(dynamic item, Map matchState) {
    if (item is! Matrix4) return false;
    final a = expected.storage;
    final b = item.storage;
    for (int i = 0; i < 16; i++) {
      if ((a[i] - b[i]).abs() > delta) return false;
    }
    return true;
  }

  @override
  Description describe(Description description) =>
      description.add('Matrix4 matching storage within delta $delta');
}
