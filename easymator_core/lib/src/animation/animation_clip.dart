import 'dart:convert';
import '../model/skeleton.dart';
import 'timeline.dart';

/// A named, reusable animation clip (e.g. 'Walk', 'Run', 'Cheer') composed of multiple bone tracks.
class AnimationClip {
  /// Unique identifier of the animation.
  final String id;

  /// Human-readable title.
  String name;

  /// Total duration in seconds.
  double duration;

  /// Whether the animation loops continuously.
  bool isLooping;

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

  /// Retrieves or creates an animation track for [boneId].
  BoneAnimationTrack getOrCreateTrack(String boneId) {
    if (_trackMap.containsKey(boneId)) {
      return _trackMap[boneId]!;
    }
    final track = BoneAnimationTrack(boneId: boneId);
    tracks.add(track);
    _trackMap[boneId] = track;
    return track;
  }

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

  /// Serializes this clip to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'version': '1.0',
      'id': id,
      'name': name,
      'duration': double.parse(duration.toStringAsFixed(4)),
      'isLooping': isLooping,
      'tracks': tracks.map((t) => t.toJson()).toList(),
    };
  }

  /// Formats this clip to a pretty-printed JSON string.
  String toPrettyJson() {
    return const JsonEncoder.withIndent('  ').convert(toJson());
  }

  /// Deserializes an [AnimationClip] from a JSON map.
  factory AnimationClip.fromJson(Map<String, dynamic> json) {
    final rawTracks = (json['tracks'] as List<dynamic>?) ?? [];
    return AnimationClip(
      id: json['id'] as String? ?? 'custom_clip',
      name: json['name'] as String? ?? '',
      duration: (json['duration'] as num?)?.toDouble() ?? 1.0,
      isLooping: json['isLooping'] as bool? ?? true,
      tracks: rawTracks
          .map((t) => BoneAnimationTrack.fromJson(t as Map<String, dynamic>))
          .toList(),
    );
  }

  /// Parses an [AnimationClip] from a raw JSON string.
  factory AnimationClip.fromJsonString(String jsonStr) {
    return AnimationClip.fromJson(jsonDecode(jsonStr) as Map<String, dynamic>);
  }
}
