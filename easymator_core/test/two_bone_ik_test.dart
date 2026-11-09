import 'package:test/test.dart';
import 'package:vector_math/vector_math_64.dart';
import 'package:easymator_core/easymator_core.dart';
import 'matchers.dart';

void main() {
  group('Two-Bone Analytical IK Solver', () {
    test('Child tip reaches exact reachable target position', () {
      final parent = Bone(id: 'upper_arm', length: 100.0);
      final child = Bone(id: 'forearm', localPosition: Vector3(100.0, 0.0, 0.0), length: 100.0);
      parent.addChild(child);

      final skeleton = Skeleton(id: 'arm_rig', root: parent);
      skeleton.updateWorldTransforms();

      // Target position: (100, 100).
      // Triangle with sides 100, 100, and distance sqrt(100^2 + 100^2) = ~141.42 (reachable!)
      final target = Vector3(100.0, 100.0, 0.0);

      final reached = TwoBoneIKSolver.solve(
        parent: parent,
        child: child,
        targetWorldPos: target,
        bendPositive: true,
      );

      expect(reached, isTrue);
      // Verify the child tip is placed exactly on the target
      final tipPos = child.getTipPosition();
      expect(tipPos, closeToVector(target, 1e-2));
    });

    test('Clamps safely to max reach when target is out of range', () {
      final parent = Bone(id: 'upper_arm', length: 50.0);
      final child = Bone(id: 'forearm', localPosition: Vector3(50.0, 0.0, 0.0), length: 50.0);
      parent.addChild(child);

      final skeleton = Skeleton(id: 'arm_rig', root: parent);
      skeleton.updateWorldTransforms();

      // Total reach is 50 + 50 = 100. Target is at (200, 0)
      final outOfReachTarget = Vector3(200.0, 0.0, 0.0);

      final reached = TwoBoneIKSolver.solve(
        parent: parent,
        child: child,
        targetWorldPos: outOfReachTarget,
      );

      expect(reached, isFalse);

      // Limbs should point straight along +X to the maximum reach of ~100
      final tipPos = child.getTipPosition();
      expect(tipPos.x, closeTo(100.0, 0.1));
      expect(tipPos.y, closeTo(0.0, 0.1));
    });

    test('Alternating bend directions produce mirrored limb shapes', () {
      final p1 = Bone(id: 'p1', length: 100.0);
      final c1 = Bone(id: 'c1', localPosition: Vector3(100.0, 0.0, 0.0), length: 100.0);
      p1.addChild(c1);

      final p2 = Bone(id: 'p2', length: 100.0);
      final c2 = Bone(id: 'c2', localPosition: Vector3(100.0, 0.0, 0.0), length: 100.0);
      p2.addChild(c2);

      final target = Vector3(120.0, 0.0, 0.0);

      TwoBoneIKSolver.solve(parent: p1, child: c1, targetWorldPos: target, bendPositive: true);
      TwoBoneIKSolver.solve(parent: p2, child: c2, targetWorldPos: target, bendPositive: false);

      // Both tips reach the target
      expect(c1.getTipPosition(), closeToVector(target, 1e-2));
      expect(c2.getTipPosition(), closeToVector(target, 1e-2));

      // But joint positions (knee/elbow) have opposite Y offsets (mirrored bend)
      final joint1 = c1.getWorldPosition();
      final joint2 = c2.getWorldPosition();

      expect(joint1.x, closeTo(joint2.x, 1e-2));
      expect(joint1.y, closeTo(-joint2.y, 1e-2));
    });
  });
}
