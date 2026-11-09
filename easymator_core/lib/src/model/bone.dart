import 'package:vector_math/vector_math_64.dart';
import '../math/transform2d.dart';
import '../math/math_utils.dart';

/// A single bone in a 2D skeletal hierarchy.
///
/// Each bone maintains its local Translation-Rotation-Scale (TRS) relative to its parent,
/// and calculates a concatenated [worldTransform] matrix used for rendering attachments
/// and Forward Kinematics (FK).
class Bone {
  /// Unique identifier of the bone.
  final String id;

  /// Human-readable name.
  String name;

  /// Parent bone in the hierarchy, or `null` if this is a root bone.
  Bone? _parent;

  /// Child bones attached to this bone.
  final List<Bone> _children = [];

  /// The visual length of the bone along its local X-axis.
  double length;

  /// Local translation relative to the parent bone.
  final Vector3 localPosition;

  /// Local rotation in radians around the Z-axis relative to the parent bone.
  double _localRotation;

  /// Local scale factor.
  final Vector3 localScale;

  /// Pre-allocated transformation matrix for local space.
  final Matrix4 localTransform = Matrix4.identity();

  /// Pre-allocated transformation matrix for absolute world coordinates.
  final Matrix4 worldTransform = Matrix4.identity();

  /// Pre-allocated inverse of [worldTransform] for screen hit-testing.
  final Matrix4 worldToLocalTransform = Matrix4.identity();

  /// Indicates whether the world transform needs re-computation.
  bool _isDirty = true;

  Bone({
    required this.id,
    this.name = '',
    this.length = 50.0,
    Vector3? localPosition,
    double localRotation = 0.0,
    Vector3? localScale,
  })  : localPosition = localPosition ?? Vector3.zero(),
        _localRotation = localRotation,
        localScale = localScale ?? Vector3(1.0, 1.0, 1.0) {
    if (name.isEmpty) name = id;
    markDirty();
  }

  /// Parent bone in the hierarchy.
  Bone? get parent => _parent;

  /// Unmodifiable view of child bones.
  List<Bone> get children => List.unmodifiable(_children);

  /// Whether this bone or its children require a transform update.
  bool get isDirty => _isDirty;

  /// Local rotation in radians. Setting this marks the bone hierarchy dirty.
  double get localRotation => _localRotation;
  set localRotation(double value) {
    _localRotation = MathUtils.normalizeAngle(value);
    markDirty();
  }

  /// Marks this bone and all its descendants as dirty, requiring a matrix recalculation.
  void markDirty() {
    _isDirty = true;
    for (int i = 0; i < _children.length; i++) {
      _children[i].markDirty();
    }
  }

  /// Adds a [child] bone to this bone's hierarchy.
  void addChild(Bone child) {
    if (child._parent == this) return;
    child._parent?._removeChildInternal(child);
    child._parent = this;
    _children.add(child);
    child.markDirty();
  }

  /// Removes a [child] bone from this bone's hierarchy.
  void removeChild(Bone child) {
    if (child._parent == this) {
      _children.remove(child);
      child._parent = null;
      child.markDirty();
    }
  }

  void _removeChildInternal(Bone child) {
    _children.remove(child);
    child._parent = null;
  }

  /// Updates the local transformation matrix from TRS properties.
  void updateLocalTransform() {
    Transform2D.composeInto(
      localTransform,
      tx: localPosition.x,
      ty: localPosition.y,
      tz: localPosition.z,
      rotation: _localRotation,
      sx: localScale.x,
      sy: localScale.y,
      sz: localScale.z,
    );
  }

  /// Computes the concatenated [worldTransform] matrix from the root downward.
  ///
  /// If this bone or its parent changed, recalculates matrices and propagates to children.
  void updateWorldTransform({bool force = false}) {
    final shouldUpdate = _isDirty || force;

    if (shouldUpdate) {
      updateLocalTransform();

      if (_parent != null) {
        Transform2D.multiplyInto(_parent!.worldTransform, localTransform, worldTransform);
      } else {
        worldTransform.setFrom(localTransform);
      }

      Transform2D.invertInto(worldTransform, worldToLocalTransform);
      _isDirty = false;
    }

    // Always inspect children: if parent updated, force children to update;
    // otherwise, allow children with their own dirty flags to update.
    for (int i = 0; i < _children.length; i++) {
      _children[i].updateWorldTransform(force: shouldUpdate);
    }
  }

  /// Returns the world position of this bone's origin/joint.
  Vector3 getWorldPosition([Vector3? result]) {
    final out = result ?? Vector3.zero();
    final s = worldTransform.storage;
    out.x = s[12];
    out.y = s[13];
    out.z = s[14];
    return out;
  }

  /// Returns the world position of this bone's tip (offset by [length] along local X).
  Vector3 getTipPosition([Vector3? result]) {
    return localToWorld(Vector3(length, 0.0, 0.0), result);
  }

  /// Returns the world rotation angle of this bone in radians.
  double getWorldRotation() {
    return Transform2D.extractRotationZ(worldTransform);
  }

  /// Transforms a local bone coordinate into absolute world coordinates.
  Vector3 localToWorld(Vector3 localPoint, [Vector3? result]) {
    return Transform2D.transformPoint(worldTransform, localPoint.x, localPoint.y, result);
  }

  /// Transforms an absolute world coordinate into local bone coordinates.
  Vector3 worldToLocal(Vector3 worldPoint, [Vector3? result]) {
    return Transform2D.transformPoint(worldToLocalTransform, worldPoint.x, worldPoint.y, result);
  }
}
