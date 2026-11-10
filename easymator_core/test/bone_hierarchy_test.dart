import 'dart:math' as math;
import 'package:test/test.dart';
import 'package:vector_math/vector_math_64.dart';
import 'package:easymator_core/easymator_core.dart';
import 'matchers.dart';

void main() {
  group('Bone Hierarchy & Forward Kinematics', () {
    test('Root bone calculates local and world transform identically', () {
      final root = Bone(
        id: 'root',
        localPosition: Vector3(100.0, 50.0, 0.0),
        localRotation: MathUtils.degToRad(45.0),
        localScale: Vector3(2.0, 2.0, 1.0),
        length: 80.0,
      );

      root.updateWorldTransform();

      expect(root.getWorldPosition(), closeToVector(Vector3(100.0, 50.0, 0.0)));
      expect(root.getWorldRotation(), closeTo(MathUtils.degToRad(45.0), 1e-4));
      expect(root.worldTransform, closeToMatrix(root.localTransform));
    });

    test('Child bone inherits parent translation and rotation correctly', () {
      // Parent at (100, 100), length 100, rotated 90 degrees (pointing straight down along +Y)
      final parent = Bone(
        id: 'parent',
        localPosition: Vector3(100.0, 100.0, 0.0),
        localRotation: math.pi / 2.0, // 90 degrees
        length: 100.0,
      );

      // Child attached to parent at local X = 100 (parent's tip)
      final child = Bone(
        id: 'child',
        localPosition: Vector3(100.0, 0.0, 0.0),
        localRotation: 0.0,
        length: 50.0,
      );

      parent.addChild(child);
      parent.updateWorldTransform();

      // Parent rotated 90 deg clockwise:
      // Parent's tip should be at (100, 100) + (100 * cos(90), 100 * sin(90)) = (100, 200)
      expect(parent.getTipPosition(), closeToVector(Vector3(100.0, 200.0, 0.0)));
      expect(child.getWorldPosition(), closeToVector(Vector3(100.0, 200.0, 0.0)));
      expect(child.getWorldRotation(), closeTo(math.pi / 2.0, 1e-4));

      // Now rotate child by another 90 degrees
      child.localRotation = math.pi / 2.0;
      parent.updateWorldTransform();

      // Child world rotation is 90 + 90 = 180 degrees (pi)
      expect(child.getWorldRotation(), closeTo(math.pi, 1e-4));

      // Child's tip should extend 50 units in direction 180 degrees (-X):
      // (100, 200) + (-50, 0) = (50, 200)
      expect(child.getTipPosition(), closeToVector(Vector3(50.0, 200.0, 0.0)));
    });

    test('3-Bone chain (Root -> Upper Arm -> Forearm)', () {
      final root = Bone(id: 'root', localPosition: Vector3(200.0, 300.0, 0.0));
      final upperArm = Bone(id: 'upper_arm', length: 100.0);
      final forearm = Bone(id: 'forearm', localPosition: Vector3(100.0, 0.0, 0.0), length: 80.0);

      root.addChild(upperArm);
      upperArm.addChild(forearm);

      upperArm.localRotation = MathUtils.degToRad(30.0);
      forearm.localRotation = MathUtils.degToRad(45.0);

      root.updateWorldTransform();

      // Forearm world rotation should be 30 + 45 = 75 degrees
      expect(forearm.getWorldRotation(), closeTo(MathUtils.degToRad(75.0), 1e-4));
    });

    test('Inverse matrix transformation (worldToLocal & localToWorld)', () {
      final bone = Bone(
        id: 'test_bone',
        localPosition: Vector3(150.0, 250.0, 0.0),
        localRotation: MathUtils.degToRad(60.0),
        localScale: Vector3(1.5, 1.5, 1.0),
        length: 100.0,
      );

      bone.updateWorldTransform();

      final localPoint = Vector3(40.0, -25.0, 0.0);
      final worldPoint = bone.localToWorld(localPoint);
      final backToLocal = bone.worldToLocal(worldPoint);

      expect(backToLocal, closeToVector(localPoint));
    });

    test('Skeleton hit testing against bone segments', () {
      final root = Bone(id: 'root', localPosition: Vector3(0.0, 0.0, 0.0), length: 100.0);
      final skeleton = Skeleton(id: 'skel', root: root);
      skeleton.updateWorldTransforms();

      // Point directly on bone segment: (50, 0)
      final hit1 = skeleton.hitTest(Vector3(50.0, 0.0, 0.0));
      expect(hit1?.id, equals('root'));

      // Point near bone segment within threshold (50, 8)
      final hit2 = skeleton.hitTest(Vector3(50.0, 8.0, 0.0), threshold: 10.0);
      expect(hit2?.id, equals('root'));

      // Point far away: (50, 50)
      final hit3 = skeleton.hitTest(Vector3(50.0, 50.0, 0.0), threshold: 10.0);
      expect(hit3, isNull);
    });

    test('Dynamic bone addition and removal updates hierarchy and indexing', () {
      final root = Bone(id: 'root', localPosition: Vector3(100.0, 100.0, 0.0), length: 50.0);
      final skeleton = Skeleton(id: 'skel', root: root);

      expect(skeleton.bones.length, equals(1));
      expect(skeleton.findBone('root'), isNotNull);

      // Add child bone
      final arm = Bone(id: 'arm', length: 40.0);
      final addedArm = skeleton.addBone(arm, parentId: 'root');
      expect(addedArm, isTrue);
      expect(skeleton.bones.length, equals(2));
      expect(skeleton.findBone('arm'), isNotNull);
      expect(arm.parent, equals(root));

      // Add sub-child bone
      final hand = Bone(id: 'hand', length: 20.0);
      final addedHand = skeleton.addBone(hand, parentId: 'arm');
      expect(addedHand, isTrue);
      expect(skeleton.bones.length, equals(3));
      expect(hand.parent, equals(arm));

      // Cannot add under nonexistent parent
      final orphan = Bone(id: 'orphan');
      expect(skeleton.addBone(orphan, parentId: 'nonexistent'), isFalse);

      // Remove intermediate bone (arm removes both arm and hand)
      final removedArm = skeleton.removeBone('arm');
      expect(removedArm, isTrue);
      expect(skeleton.findBone('arm'), isNull);
      expect(skeleton.findBone('hand'), isNull);
      expect(skeleton.bones.length, equals(1));

      // Cannot remove root bone
      expect(skeleton.removeBone('root'), isFalse);
    });
  });
}
