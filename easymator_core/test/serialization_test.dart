import 'package:test/test.dart';
import 'package:vector_math/vector_math_64.dart';
import 'package:easymator_core/easymator_core.dart';
import 'matchers.dart';

void main() {
  group('AnimationClip JSON Serialization', () {
    test('Round-trip serialization preserves tracks, keyframes, and curves', () {
      final originalClip = AnimationClip(
        id: 'test_walk',
        name: 'Test Walk Cycle',
        duration: 1.5,
        isLooping: true,
        tracks: [
          BoneAnimationTrack(
            boneId: 'thigh_r',
            rotationKeys: [
              const Keyframe(time: 0.0, value: 1.0, curve: EasingCurve.linear),
              const Keyframe(time: 0.75, value: 2.5, curve: EasingCurve.easeInOut),
              const Keyframe(time: 1.5, value: 1.0, curve: EasingCurve.linear),
            ],
          ),
          BoneAnimationTrack(
            boneId: 'root',
            positionKeys: [
              Keyframe(time: 0.0, value: Vector3(100.0, 200.0, 0.0)),
              Keyframe(time: 0.75, value: Vector3(100.0, 210.0, 0.0)),
              Keyframe(time: 1.5, value: Vector3(100.0, 200.0, 0.0)),
            ],
          ),
        ],
      );

      final jsonMap = originalClip.toJson();
      expect(jsonMap['version'], equals('1.0'));
      expect(jsonMap['name'], equals('Test Walk Cycle'));

      final jsonString = originalClip.toPrettyJson();
      final restoredClip = AnimationClip.fromJsonString(jsonString);

      expect(restoredClip.id, equals('test_walk'));
      expect(restoredClip.name, equals('Test Walk Cycle'));
      expect(restoredClip.duration, closeTo(1.5, 1e-4));
      expect(restoredClip.isLooping, isTrue);
      expect(restoredClip.tracks.length, equals(2));

      final thighTrack = restoredClip.getTrack('thigh_r')!;
      expect(thighTrack.rotationKeys.length, equals(3));
      expect(thighTrack.rotationKeys[1].time, closeTo(0.75, 1e-4));
      expect(thighTrack.rotationKeys[1].value, closeTo(2.5, 1e-4));
      expect(thighTrack.rotationKeys[1].curve, equals(EasingCurve.easeInOut));

      final rootTrack = restoredClip.getTrack('root')!;
      expect(rootTrack.positionKeys.length, equals(3));
      expect(rootTrack.positionKeys[1].value, closeToVector(Vector3(100.0, 210.0, 0.0)));
    });

    test('CharacterRegistry provides all 3 characters in all 3 views (9 skins total)', () {
      expect(CharacterRegistry.characters.length, equals(3));

      for (final char in CharacterRegistry.characters) {
        for (final view in ViewAngle.values) {
          final skin = CharacterRegistry.getSkin(char.id, view);
          expect(skin.attachments.isNotEmpty, isTrue);
          expect(skin.attachments.containsKey('slot_head'), isTrue);
          expect(skin.attachments.containsKey('slot_torso'), isTrue);
        }
      }
    });
  });
}
