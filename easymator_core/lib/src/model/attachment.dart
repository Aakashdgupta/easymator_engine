import 'package:vector_math/vector_math_64.dart';

/// Base class for all visual art attached to a bone slot.
abstract class Attachment {
  final String id;
  final String name;

  /// Local translation offset relative to the parent bone origin.
  final Vector3 offset;

  /// Local rotation in radians relative to the parent bone.
  final double rotation;

  /// Local scale relative to the parent bone.
  final Vector3 scale;

  Attachment({
    required this.id,
    this.name = '',
    Vector3? offset,
    this.rotation = 0.0,
    Vector3? scale,
  })  : offset = offset ?? Vector3.zero(),
        scale = scale ?? Vector3(1.0, 1.0, 1.0);
}

/// A procedural geometric shape attachment (capsule, rectangle, ellipse)
/// designed for rapid prototyping and modular paper-doll rigging without external assets.
class ShapeAttachment extends Attachment {
  /// Geometric type.
  final ShapeType shapeType;

  /// Width along the bone's local X-axis.
  final double width;

  /// Height along the bone's local Y-axis.
  final double height;

  /// ARGB fill color.
  final int fillColor;

  /// ARGB stroke color.
  final int strokeColor;

  /// Stroke width in pixels.
  final double strokeWidth;

  ShapeAttachment({
    required super.id,
    super.name,
    super.offset,
    super.rotation,
    super.scale,
    this.shapeType = ShapeType.capsule,
    required this.width,
    required this.height,
    this.fillColor = 0xFF4A90E2, // Default friendly blue
    this.strokeColor = 0xFF1D3557,
    this.strokeWidth = 2.0,
  });
}

enum ShapeType {
  rectangle,
  capsule,
  ellipse,
}

/// A 2D vector path attachment composed of polyline points or SVG curves.
class PathAttachment extends Attachment {
  /// Relative polygon/polyline vertices in bone space.
  final List<Vector3> vertices;

  /// ARGB fill color.
  final int fillColor;

  /// ARGB stroke/border color.
  final int strokeColor;

  /// Stroke width.
  final double strokeWidth;

  /// Whether the path forms a closed polygon.
  final bool isClosed;

  PathAttachment({
    required super.id,
    super.name,
    super.offset,
    super.rotation,
    super.scale,
    required this.vertices,
    this.fillColor = 0xFFCCCCCC,
    this.strokeColor = 0xFF333333,
    this.strokeWidth = 2.0,
    this.isClosed = true,
  });
}
