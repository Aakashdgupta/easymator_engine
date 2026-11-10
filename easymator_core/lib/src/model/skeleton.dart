import 'dart:math' as math;
import 'package:vector_math/vector_math_64.dart';
import 'bone.dart';

/// Manages a collection of bones forming a complete character rig.
class Skeleton {
  /// Unique identifier of the skeleton.
  final String id;

  /// Human-readable name.
  String name;

  /// Root bone of the skeleton.
  final Bone root;

  /// Fast lookup map by bone ID.
  final Map<String, Bone> _boneMap = {};

  /// Ordered list of all bones in topological order (parents before children).
  final List<Bone> _bones = [];

  Skeleton({
    required this.id,
    this.name = '',
    required this.root,
  }) {
    if (name.isEmpty) name = id;
    _rebuildBoneIndex();
  }

  /// All bones in topological order.
  List<Bone> get bones => List.unmodifiable(_bones);

  /// Look up a bone by its [id].
  Bone? findBone(String id) => _boneMap[id];

  /// Rebuilds the flat list and index map of all bones in the hierarchy.
  void _rebuildBoneIndex() {
    _boneMap.clear();
    _bones.clear();
    _traverse(root);
  }

  void _traverse(Bone current) {
    _boneMap[current.id] = current;
    _bones.add(current);
    for (final child in current.children) {
      _traverse(child);
    }
  }

  /// Refreshes the skeleton hierarchy if bones were added or removed dynamically.
  void refreshHierarchy() {
    _rebuildBoneIndex();
  }

  /// Adds a new [bone] under the parent identified by [parentId].
  ///
  /// Returns `true` if successful, or `false` if the parent bone was not found.
  bool addBone(Bone bone, {required String parentId}) {
    final parent = findBone(parentId);
    if (parent == null) return false;
    parent.addChild(bone);
    _rebuildBoneIndex();
    updateWorldTransforms(force: true);
    return true;
  }

  /// Removes a bone by its [boneId] from the hierarchy.
  /// Cannot remove the root bone. Returns `true` if removed.
  bool removeBone(String boneId) {
    if (boneId == root.id) return false;
    final bone = findBone(boneId);
    if (bone == null || bone.parent == null) return false;
    bone.parent!.removeChild(bone);
    _rebuildBoneIndex();
    updateWorldTransforms(force: true);
    return true;
  }

  /// Evaluates and updates the world transform matrices for the entire skeleton.
  void updateWorldTransforms({bool force = false}) {
    root.updateWorldTransform(force: force);
  }

  /// Hit-tests all bones against an absolute world coordinate [point].
  ///
  /// Returns the nearest [Bone] whose joint or body line is within [threshold] pixels,
  /// or `null` if no bone is within range.
  Bone? hitTest(Vector3 point, {double threshold = 12.0}) {
    Bone? bestBone;
    double bestDistance = double.infinity;

    final tempOrigin = Vector3.zero();
    final tempTip = Vector3.zero();

    for (final bone in _bones) {
      bone.getWorldPosition(tempOrigin);
      bone.getTipPosition(tempTip);

      final dist = _distanceToSegment(point, tempOrigin, tempTip);
      if (dist <= threshold && dist < bestDistance) {
        bestDistance = dist;
        bestBone = bone;
      }
    }

    return bestBone;
  }

  /// Calculates the shortest distance from point [p] to the line segment between [a] and [b].
  double _distanceToSegment(Vector3 p, Vector3 a, Vector3 b) {
    final abX = b.x - a.x;
    final abY = b.y - a.y;
    final lengthSq = abX * abX + abY * abY;

    if (lengthSq == 0.0) {
      final dx = p.x - a.x;
      final dy = p.y - a.y;
      return math.sqrt(dx * dx + dy * dy);
    }

    // Projection factor t
    var t = ((p.x - a.x) * abX + (p.y - a.y) * abY) / lengthSq;
    t = t.clamp(0.0, 1.0);

    final projX = a.x + t * abX;
    final projY = a.y + t * abY;

    final dx = p.x - projX;
    final dy = p.y - projY;
    return math.sqrt(dx * dx + dy * dy);
  }
}
