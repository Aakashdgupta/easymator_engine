import 'dart:math' as math;
import 'package:vector_math/vector_math_64.dart';
import '../model/bone.dart';

/// Analytical 2-Bone Inverse Kinematics (IK) solver using the Law of Cosines.
///
/// Closed-form, instantaneous, and deterministic. Ideal for human limbs
/// (Hip -> Knee -> Ankle, Shoulder -> Elbow -> Wrist).
class TwoBoneIKSolver {
  TwoBoneIKSolver._();

  /// Solves IK for a two-bone chain ([parent] and [child]) such that [child]'s tip
  /// reaches toward [targetWorldPos].
  ///
  /// [bendPositive]: controls the bend direction (e.g. knee bending forward vs backward).
  ///
  /// Returns `true` if the target was reachable, or `false` if it was clamped to max reach.
  static bool solve({
    required Bone parent,
    required Bone child,
    required Vector3 targetWorldPos,
    bool bendPositive = true,
  }) {
    final l1 = parent.length;
    final l2 = child.length;

    if (l1 <= 0.0 || l2 <= 0.0) return false;

    // Origin of parent in world space
    final pOrigin = parent.getWorldPosition();

    // Vector from parent to target
    final dx = targetWorldPos.x - pOrigin.x;
    final dy = targetWorldPos.y - pOrigin.y;
    final dist = math.sqrt(dx * dx + dy * dy);

    // Clamp distance to physical limits of the 2-bone chain
    final maxReach = l1 + l2 - 0.001;
    final minReach = (l1 - l2).abs() + 0.001;
    final d = dist.clamp(minReach, maxReach);
    final isClamped = dist > maxReach || dist < minReach;

    // Base angle pointing from parent origin directly toward target
    final targetAngle = math.atan2(dy, dx);

    // Law of Cosines:
    // d^2 = l1^2 + l2^2 - 2*l1*l2 * cos(gamma) -> gamma is interior angle at knee/elbow
    final cosGamma = (l1 * l1 + l2 * l2 - d * d) / (2.0 * l1 * l2);
    final gamma = math.acos(cosGamma.clamp(-1.0, 1.0));

    // Law of Cosines:
    // l2^2 = l1^2 + d^2 - 2*l1*d * cos(alpha) -> alpha is angle between l1 and line to target
    final cosAlpha = (l1 * l1 + d * d - l2 * l2) / (2.0 * l1 * d);
    final alpha = math.acos(cosAlpha.clamp(-1.0, 1.0));

    // Compute parent world rotation
    final parentWorldAngle = bendPositive ? (targetAngle - alpha) : (targetAngle + alpha);

    // Convert parent world rotation to local rotation
    final parentParentWorldRotation = parent.parent?.getWorldRotation() ?? 0.0;
    parent.localRotation = parentWorldAngle - parentParentWorldRotation;
    parent.updateWorldTransform(force: true);

    // Child local rotation (angle difference between l1 and l2)
    final childLocalAngle = bendPositive ? (math.pi - gamma) : -(math.pi - gamma);
    child.localRotation = childLocalAngle;
    child.updateWorldTransform(force: true);

    return !isClamped;
  }
}
