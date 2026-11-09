import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vm;
import 'package:easymator_core/easymator_core.dart';

/// Renders a diagnostic visual wireframe of the bone hierarchy, joints, and lengths.
class DebugSkeletonPainter extends CustomPainter {
  final Skeleton skeleton;

  /// Optional ID of the currently selected/hovered bone to highlight.
  final String? selectedBoneId;

  /// Joint circle radius in pixels.
  final double jointRadius;

  /// Bone wireframe stroke width.
  final double boneLineWidth;

  /// Color palette for debug drawing.
  final Color boneColor;
  final Color jointColor;
  final Color selectedColor;
  final Color tipColor;

  DebugSkeletonPainter({
    required this.skeleton,
    this.selectedBoneId,
    this.jointRadius = 6.0,
    this.boneLineWidth = 3.0,
    this.boneColor = const Color(0xFF4CAF50),       // Bright Green
    this.jointColor = const Color(0xFFFF5722),      // Deep Orange
    this.selectedColor = const Color(0xFFFFEB3B),   // Vivid Yellow
    this.tipColor = const Color(0xFF03A9F4),        // Light Blue
  });

  @override
  void paint(Canvas canvas, Size size) {
    skeleton.updateWorldTransforms();

    final bonePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = boneLineWidth;

    final boneFillPaint = Paint()..style = PaintingStyle.fill;
    final jointPaint = Paint()..style = PaintingStyle.fill;

    final tempOrigin = vm.Vector3.zero();
    final tempTip = vm.Vector3.zero();

    // 1. Draw Bone bodies (tapered kite-shape from joint to tip)
    for (final bone in skeleton.bones) {
      bone.getWorldPosition(tempOrigin);
      bone.getTipPosition(tempTip);

      final isSelected = bone.id == selectedBoneId;
      final currentColor = isSelected ? selectedColor : boneColor;

      final start = Offset(tempOrigin.x, tempOrigin.y);
      final end = Offset(tempTip.x, tempTip.y);

      _drawBoneSegment(canvas, start, end, currentColor, bonePaint, boneFillPaint, isSelected);
    }

    // 2. Draw Joint circles at origins
    for (final bone in skeleton.bones) {
      bone.getWorldPosition(tempOrigin);
      final isSelected = bone.id == selectedBoneId;

      jointPaint.color = isSelected ? selectedColor : jointColor;
      canvas.drawCircle(Offset(tempOrigin.x, tempOrigin.y), isSelected ? jointRadius * 1.4 : jointRadius, jointPaint);

      // White inner dot for precision pivot visibility
      jointPaint.color = Colors.white;
      canvas.drawCircle(Offset(tempOrigin.x, tempOrigin.y), 2.0, jointPaint);
    }
  }

  void _drawBoneSegment(
    Canvas canvas,
    Offset start,
    Offset end,
    Color color,
    Paint strokePaint,
    Paint fillPaint,
    bool isSelected,
  ) {
    final dx = end.dx - start.dx;
    final dy = end.dy - start.dy;
    final length = math.sqrt(dx * dx + dy * dy);

    if (length < 2.0) {
      strokePaint.color = color;
      canvas.drawLine(start, end, strokePaint);
      return;
    }

    // Unit direction & perpendicular normal
    final ux = dx / length;
    final uy = dy / length;
    final nx = -uy;
    final ny = ux;

    // Tapered polygon: wider at 20% along length, tapered down to tip
    final waistDist = math.min(length * 0.2, 16.0);
    final waistWidth = math.min(length * 0.15, 10.0);

    final p0 = start;
    final p1 = Offset(start.dx + ux * waistDist + nx * waistWidth, start.dy + uy * waistDist + ny * waistWidth);
    final p2 = end;
    final p3 = Offset(start.dx + ux * waistDist - nx * waistWidth, start.dy + uy * waistDist - ny * waistWidth);

    final path = Path()
      ..moveTo(p0.dx, p0.dy)
      ..lineTo(p1.dx, p1.dy)
      ..lineTo(p2.dx, p2.dy)
      ..lineTo(p3.dx, p3.dy)
      ..close();

    // Fill with semi-transparent color
    fillPaint.color = color.withValues(alpha: isSelected ? 0.45 : 0.25);
    canvas.drawPath(path, fillPaint);

    // Outline stroke
    strokePaint.color = color;
    strokePaint.strokeWidth = isSelected ? boneLineWidth * 1.5 : boneLineWidth;
    canvas.drawPath(path, strokePaint);
  }

  @override
  bool shouldRepaint(covariant DebugSkeletonPainter oldDelegate) => true;
}
