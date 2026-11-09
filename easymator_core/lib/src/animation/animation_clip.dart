import '../model/skeleton.dart';
import 'timeline.dart';

/// A named, reusable animation clip (e.g. 'Walk', 'Run', 'Cheer') composed of multiple bone tracks.
class AnimationClip {
  /// Unique identifier of the animation.
  final String id;

  /// Human-readable title.
  String name;

  /// Total duration in seconds.
  final double duration;

  /// Whether the animation loops continuously.
  final bool isLooping;

  /// Bone animation tracks.
  final List<BoneAnimationTrack> tracks;

  /// Fast track lookup.
  final Map<String, BoneAnimationTrack> _trackMap = {};

  AnimationClip({
    required this.id,
    this.name = '',
    required this.duration,
    this.isLooping = true,
    required this.tracks,
  }) {
    if (name.isEmpty) name = id;
    for (final track in tracks) {
      _trackMap[track.boneId] = track;
    }
  }

  /// Retrieves the animation track for [boneId], or `null` if none.
  BoneAnimationTrack? getTrack(String boneId) => _trackMap[boneId];

  /// Evaluates and applies the animation poses to [skeleton] at [time] in seconds.
  ///
  /// This operation is 100% deterministic and operates with zero dynamic timer dependencies.
  void apply(Skeleton skeleton, double time) {
    if (duration <= 0.0) return;

    double sampleTime;
    if (isLooping) {
      sampleTime = time % duration;
      if (sampleTime < 0.0) sampleTime += duration;
    } else {
      sampleTime = time.clamp(0.0, duration);
    }

    for (final track in tracks) {
      final bone = skeleton.findBone(track.boneId);
      if (bone == null) continue;

      if (track.positionKeys.isNotEmpty) {
        track.samplePosition(sampleTime, bone.localPosition);
      }
      if (track.rotationKeys.isNotEmpty) {
        bone.localRotation = track.sampleRotation(sampleTime);
      }
      if (track.scaleKeys.isNotEmpty) {
        track.sampleScale(sampleTime, bone.localScale);
      }
      bone.markDirty();
    }

    skeleton.updateWorldTransforms();
  }
}
