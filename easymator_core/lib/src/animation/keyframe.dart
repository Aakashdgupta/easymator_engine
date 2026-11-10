import 'package:vector_math/vector_math_64.dart';

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

  /// Serializes this keyframe to JSON.
  Map<String, dynamic> toJson([Object? Function(T)? valueToJson]) {
    return {
      'time': double.parse(time.toStringAsFixed(4)),
      'value': valueToJson != null ? valueToJson(value) : _serializeValue(value),
      'curve': curve.name,
    };
  }

  static Object? _serializeValue(dynamic val) {
    if (val is Vector3) {
      return [
        double.parse(val.x.toStringAsFixed(4)),
        double.parse(val.y.toStringAsFixed(4)),
        double.parse(val.z.toStringAsFixed(4)),
      ];
    } else if (val is double) {
      return double.parse(val.toStringAsFixed(4));
    }
    return val;
  }

  /// Deserializes a [Keyframe<double>] from JSON.
  static Keyframe<double> fromJsonDouble(Map<String, dynamic> json) {
    final curveStr = json['curve'] as String? ?? 'linear';
    return Keyframe<double>(
      time: (json['time'] as num).toDouble(),
      value: (json['value'] as num).toDouble(),
      curve: EasingCurve.values.firstWhere(
        (e) => e.name == curveStr,
        orElse: () => EasingCurve.linear,
      ),
    );
  }

  /// Deserializes a [Keyframe<Vector3>] from JSON.
  static Keyframe<Vector3> fromJsonVector3(Map<String, dynamic> json) {
    final rawVal = json['value'] as List<dynamic>;
    final curveStr = json['curve'] as String? ?? 'linear';
    return Keyframe<Vector3>(
      time: (json['time'] as num).toDouble(),
      value: Vector3(
        (rawVal[0] as num).toDouble(),
        (rawVal[1] as num).toDouble(),
        rawVal.length > 2 ? (rawVal[2] as num).toDouble() : 0.0,
      ),
      curve: EasingCurve.values.firstWhere(
        (e) => e.name == curveStr,
        orElse: () => EasingCurve.linear,
      ),
    );
  }
}
