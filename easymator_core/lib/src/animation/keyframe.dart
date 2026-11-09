/// Easing curve applied between keyframes.
enum EasingCurve {
  linear,
  easeIn,
  easeOut,
  easeInOut,
  stepped,
}

/// Helper methods to evaluate easing curves.
class CurveEvaluator {
  CurveEvaluator._();

  /// Evaluates normalized time [t] ($0.0 \dots 1.0$) according to [curve].
  static double evaluate(double t, EasingCurve curve) {
    t = t.clamp(0.0, 1.0);
    switch (curve) {
      case EasingCurve.linear:
        return t;
      case EasingCurve.easeIn:
        return t * t;
      case EasingCurve.easeOut:
        return t * (2.0 - t);
      case EasingCurve.easeInOut:
        return t < 0.5 ? 2.0 * t * t : -1.0 + (4.0 - 2.0 * t) * t;
      case EasingCurve.stepped:
        return t < 1.0 ? 0.0 : 1.0;
    }
  }
}

/// A single timestamped value in an animation track.
class Keyframe<T> {
  /// Time position in seconds.
  final double time;

  /// Value at this timestamp.
  final T value;

  /// Easing transition from this keyframe to the next adjacent keyframe.
  final EasingCurve curve;

  const Keyframe({
    required this.time,
    required this.value,
    this.curve = EasingCurve.linear,
  });
}
