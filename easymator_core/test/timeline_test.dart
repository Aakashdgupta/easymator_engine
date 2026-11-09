import 'dart:math' as math;
import 'package:test/test.dart';
import 'package:vector_math/vector_math_64.dart';
import 'package:easymator_core/easymator_core.dart';
import 'matchers.dart';

void main() {
  group('Timeline & Keyframe Interpolation', () {
    test('Position linear interpolation between keyframes', () {
      final track = BoneAnimationTrack(
        boneId: 'bone_1',
        positionKeys: [
          Keyframe(time: 0.0, value: Vector3(0.0, 0.0, 0.0)),
          Keyframe(time: 1.0, value: Vector3(100.0, 200.0, 0.0)),
        ],
      );

      expect(track.samplePosition(0.0), closeToVector(Vector3(0.0, 0.0, 0.0)));
      expect(track.samplePosition(0.5), closeToVector(Vector3(50.0, 100.0, 0.0)));
      expect(track.samplePosition(1.0), closeToVector(Vector3(100.0, 200.0, 0.0)));
    });

    test('SLERP rotation wraps smoothly across shortest arc', () {
      // Rotate from +170 deg (2.967 rad) to -170 deg (-2.967 rad).
      // Shortest arc is 20 degrees across the pi boundary, NOT 340 degrees backward!
      final angleA = MathUtils.degToRad(170.0);
      final angleB = MathUtils.degToRad(-170.0);

      final track = BoneAnimationTrack(
        boneId: 'bone_1',
        rotationKeys: [
          Keyframe(time: 0.0, value: angleA),
          Keyframe(time: 1.0, value: angleB),
        ],
      );

      final midAngle = track.sampleRotation(0.5);
      // Midpoint should be 180 degrees (pi or -pi)
      expect(midAngle.abs(), closeTo(math.pi, 1e-4));
    });

    test('Deterministic clip evaluation over time', () {
      final root = Bone(id: 'root');
      final arm = Bone(id: 'arm', length: 100.0);
      root.addChild(arm);

      final skeleton = Skeleton(id: 'skel', root: root);

      final clip = AnimationClip(
        id: 'wave',
        duration: 2.0,
        tracks: [
          BoneAnimationTrack(
            boneId: 'arm',
            rotationKeys: [
              Keyframe(time: 0.0, value: 0.0),
              Keyframe(time: 1.0, value: math.pi / 2.0),
              Keyframe(time: 2.0, value: 0.0),
            ],
          ),
        ],
      );

      // t = 0s -> 0 rad
      clip.apply(skeleton, 0.0);
      expect(arm.localRotation, closeTo(0.0, 1e-4));

      // t = 1s -> pi / 2
      clip.apply(skeleton, 1.0);
      expect(arm.localRotation, closeTo(math.pi / 2.0, 1e-4));

      // t = 2s -> 0 rad
      clip.apply(skeleton, 2.0);
      expect(arm.localRotation, closeTo(0.0, 1e-4));

      // Looping test: t = 3s (equivalent to 1s in 2s loop) -> pi / 2
      clip.apply(skeleton, 3.0);
      expect(arm.localRotation, closeTo(math.pi / 2.0, 1e-4));
    });
  });
}
