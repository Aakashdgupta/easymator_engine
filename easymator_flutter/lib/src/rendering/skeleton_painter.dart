import 'package:flutter/material.dart';
import 'package:easymator_core/easymator_core.dart';

/// Production CustomPainter that renders visual attachments bound to slots, sorted by Z-order.
class SkeletonPainter extends CustomPainter {
  final Skeleton skeleton;
  final List<Slot> slots;

  SkeletonPainter({
    required this.skeleton,
    required this.slots,
  });

  @override
  void paint(Canvas canvas, Size size) {
    skeleton.updateWorldTransforms();

    // Sort slots by draw order (zIndex)
    final sortedSlots = List<Slot>.from(slots)..sort((a, b) => a.zIndex.compareTo(b.zIndex));

    for (final slot in sortedSlots) {
      final attachment = slot.activeAttachment;
      if (attachment == null) continue;

      final bone = skeleton.findBone(slot.boneId);
      if (bone == null) continue;

      canvas.save();

      // Concatenate the bone's 4x4 world transform matrix directly into the Flutter canvas!
      canvas.transform(bone.worldTransform.storage);

      // Apply attachment local offset and rotation within the bone's local space
      if (attachment.offset.x != 0.0 || attachment.offset.y != 0.0) {
        canvas.translate(attachment.offset.x, attachment.offset.y);
      }
      if (attachment.rotation != 0.0) {
        canvas.rotate(attachment.rotation);
      }
      if (attachment.scale.x != 1.0 || attachment.scale.y != 1.0) {
        canvas.scale(attachment.scale.x, attachment.scale.y);
      }

      // Render based on attachment type
      if (attachment is ShapeAttachment) {
        _renderShape(canvas, attachment, slot.opacity);
      } else if (attachment is PathAttachment) {
        _renderPath(canvas, attachment, slot.opacity);
      }

      canvas.restore();
    }
  }

  void _renderShape(Canvas canvas, ShapeAttachment shape, double slotOpacity) {
    final baseFillColor = Color(shape.fillColor);
    final fillPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = baseFillColor.withValues(
        alpha: (baseFillColor.a * slotOpacity).clamp(0.0, 1.0),
      );

    final baseStrokeColor = Color(shape.strokeColor);
    final strokePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = shape.strokeWidth
      ..color = baseStrokeColor.withValues(
        alpha: (baseStrokeColor.a * slotOpacity).clamp(0.0, 1.0),
      );

    final rect = Rect.fromCenter(
      center: Offset.zero,
      width: shape.width,
      height: shape.height,
    );

    switch (shape.shapeType) {
      case ShapeType.rectangle:
        canvas.drawRect(rect, fillPaint);
        if (shape.strokeWidth > 0) canvas.drawRect(rect, strokePaint);
        break;
      case ShapeType.capsule:
        final rrect = RRect.fromRectAndRadius(rect, Radius.circular(shape.height / 2.0));
        canvas.drawRRect(rrect, fillPaint);
        if (shape.strokeWidth > 0) canvas.drawRRect(rrect, strokePaint);
        break;
      case ShapeType.ellipse:
        canvas.drawOval(rect, fillPaint);
        if (shape.strokeWidth > 0) canvas.drawOval(rect, strokePaint);
        break;
    }
  }

  void _renderPath(Canvas canvas, PathAttachment pathAttachment, double slotOpacity) {
    if (pathAttachment.vertices.isEmpty) return;

    final path = Path();
    path.moveTo(pathAttachment.vertices[0].x, pathAttachment.vertices[0].y);

    for (int i = 1; i < pathAttachment.vertices.length; i++) {
      path.lineTo(pathAttachment.vertices[i].x, pathAttachment.vertices[i].y);
    }

    if (pathAttachment.isClosed) {
      path.close();
    }

    final baseFillColor = Color(pathAttachment.fillColor);
    final fillPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = baseFillColor.withValues(
        alpha: (baseFillColor.a * slotOpacity).clamp(0.0, 1.0),
      );

    final baseStrokeColor = Color(pathAttachment.strokeColor);
    final strokePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = pathAttachment.strokeWidth
      ..color = baseStrokeColor.withValues(
        alpha: (baseStrokeColor.a * slotOpacity).clamp(0.0, 1.0),
      );

    canvas.drawPath(path, fillPaint);
    if (pathAttachment.strokeWidth > 0) {
      canvas.drawPath(path, strokePaint);
    }
  }

  @override
  bool shouldRepaint(covariant SkeletonPainter oldDelegate) => true;
}
