import 'package:vector_math/vector_math_64.dart';
import '../math/math_utils.dart';
import 'keyframe.dart';

/// Animation track controlling a single bone's translation, rotation, and scale over time.
class BoneAnimationTrack {
  /// Target bone ID.
  final String boneId;

  /// Ordered keyframes for local translation.
  final List<Keyframe<Vector3>> positionKeys;

  /// Ordered keyframes for local rotation (in radians).
  final List<Keyframe<double>> rotationKeys;

  /// Ordered keyframes for local scale.
  final List<Keyframe<Vector3>> scaleKeys;

  BoneAnimationTrack({
    required this.boneId,
    List<Keyframe<Vector3>>? positionKeys,
    List<Keyframe<double>>? rotationKeys,
    List<Keyframe<Vector3>>? scaleKeys,
  })  : positionKeys = positionKeys ?? [],
        rotationKeys = rotationKeys ?? [],
        scaleKeys = scaleKeys ?? [] {
    _sortKeys();
  }

  void _sortKeys() {
    positionKeys.sort((a, b) => a.time.compareTo(b.time));
    rotationKeys.sort((a, b) => a.time.compareTo(b.time));
    scaleKeys.sort((a, b) => a.time.compareTo(b.time));
  }

  /// Samples local translation at [time] seconds. Writes into [result] if provided.
  Vector3 samplePosition(double time, [Vector3? result]) {
    final out = result ?? Vector3.zero();
    if (positionKeys.isEmpty) return out;
    if (positionKeys.length == 1 || time <= positionKeys.first.time) {
      final v = positionKeys.first.value;
      out.setValues(v.x, v.y, v.z);
      return out;
    }
    if (time >= positionKeys.last.time) {
      final v = positionKeys.last.value;
      out.setValues(v.x, v.y, v.z);
      return out;
    }

    // Binary search for adjacent keyframes
    int index = _findKeyframeIndex(positionKeys, time);
    final k0 = positionKeys[index];
    final k1 = positionKeys[index + 1];

    final duration = k1.time - k0.time;
    final t = duration > 0 ? (time - k0.time) / duration : 0.0;
    final easedT = CurveEvaluator.evaluate(t, k0.curve);

    return MathUtils.lerpVector3(k0.value, k1.value, easedT, out);
  }

  /// Samples local rotation in radians at [time] seconds, interpolating along the shortest arc.
  double sampleRotation(double time) {
    if (rotationKeys.isEmpty) return 0.0;
    if (rotationKeys.length == 1 || time <= rotationKeys.first.time) {
      return rotationKeys.first.value;
    }
    if (time >= rotationKeys.last.time) {
      return rotationKeys.last.value;
    }

    int index = _findKeyframeIndex(rotationKeys, time);
    final k0 = rotationKeys[index];
    final k1 = rotationKeys[index + 1];

    final duration = k1.time - k0.time;
    final t = duration > 0 ? (time - k0.time) / duration : 0.0;
    final easedT = CurveEvaluator.evaluate(t, k0.curve);

    return MathUtils.slerpAngle(k0.value, k1.value, easedT);
  }

  /// Samples local scale at [time] seconds. Writes into [result] if provided.
  Vector3 sampleScale(double time, [Vector3? result]) {
    final out = result ?? Vector3(1.0, 1.0, 1.0);
    if (scaleKeys.isEmpty) return out;
    if (scaleKeys.length == 1 || time <= scaleKeys.first.time) {
      final v = scaleKeys.first.value;
      out.setValues(v.x, v.y, v.z);
      return out;
    }
    if (time >= scaleKeys.last.time) {
      final v = scaleKeys.last.value;
      out.setValues(v.x, v.y, v.z);
      return out;
    }

    int index = _findKeyframeIndex(scaleKeys, time);
    final k0 = scaleKeys[index];
    final k1 = scaleKeys[index + 1];

    final duration = k1.time - k0.time;
    final t = duration > 0 ? (time - k0.time) / duration : 0.0;
    final easedT = CurveEvaluator.evaluate(t, k0.curve);

    return MathUtils.lerpVector3(k0.value, k1.value, easedT, out);
  }

  static int _findKeyframeIndex<T>(List<Keyframe<T>> keys, double time) {
    int low = 0;
    int high = keys.length - 1;

    while (low <= high) {
      int mid = (low + high) >> 1;
      if (keys[mid].time <= time) {
        if (mid == keys.length - 1 || keys[mid + 1].time > time) {
          return mid;
        }
        low = mid + 1;
      } else {
        high = mid - 1;
      }
    }
    return 0;
  }
}
