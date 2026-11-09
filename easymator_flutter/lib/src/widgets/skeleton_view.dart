import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:vector_math/vector_math_64.dart' as vm;
import 'package:easymator_core/easymator_core.dart';
import '../rendering/debug_skeleton_painter.dart';
import '../rendering/skeleton_painter.dart';
import 'skeleton_controller.dart';

/// Interactive Flutter widget that renders a skeletal rig, drives timeline ticks,
/// and handles bone selection hit-testing.
class SkeletonView extends StatefulWidget {
  final SkeletonController controller;
  final bool showDebugWireframe;
  final bool showAttachments;
  final String? selectedBoneId;
  final ValueChanged<Bone?>? onBoneSelected;

  const SkeletonView({
    super.key,
    required this.controller,
    this.showDebugWireframe = true,
    this.showAttachments = true,
    this.selectedBoneId,
    this.onBoneSelected,
  });

  @override
  State<SkeletonView> createState() => _SkeletonViewState();
}

class _SkeletonViewState extends State<SkeletonView> with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  Duration _lastElapsed = Duration.zero;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick);
    _ticker.start();
  }

  void _onTick(Duration elapsed) {
    if (_lastElapsed != Duration.zero) {
      final dt = (elapsed - _lastElapsed).inMicroseconds / 1000000.0;
      if (dt > 0.0 && dt < 0.25) {
        widget.controller.update(dt);
      }
    }
    _lastElapsed = elapsed;
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.onBoneSelected == null) return;

    final tapPos = vm.Vector3(details.localPosition.dx, details.localPosition.dy, 0.0);
    final hitBone = widget.controller.skeleton.hitTest(tapPos, threshold: 16.0);
    widget.onBoneSelected!(hitBone);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, _) {
        return GestureDetector(
          onTapDown: _handleTapDown,
          child: CustomPaint(
            painter: widget.showAttachments
                ? SkeletonPainter(
                    skeleton: widget.controller.skeleton,
                    slots: widget.controller.slots,
                  )
                : null,
            foregroundPainter: widget.showDebugWireframe
                ? DebugSkeletonPainter(
                    skeleton: widget.controller.skeleton,
                    selectedBoneId: widget.selectedBoneId,
                  )
                : null,
            size: Size.infinite,
          ),
        );
      },
    );
  }
}
