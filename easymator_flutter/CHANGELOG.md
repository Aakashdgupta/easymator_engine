# Changelog

All notable changes to `easymator_flutter` will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0] - 2026-11-10

### Added
- **Flutter Widget & Rendering Bridge**:
  - `SkeletonView`: High-performance `CustomPainter` rendering 2D skeletal rigs and visual skin attachments at 60/120 FPS.
  - `SkeletonController`: State-driven controller managing animation playback, playhead ticking, dynamic bone manipulations, and IK target positioning.
- **Rendering Modes**:
  - `SkeletonPainter`: Production visual slot and bone capsule renderer.
  - `DebugSkeletonPainter`: Diagnostic wireframe renderer visualizing bone segments, joint pivots, names, and IK constraint lines.
- **Interactive Manipulation & IK**:
  - Real-time IK handle dragging with end-effector targeting.
  - Dynamic bone length and alignment updates reflected instantly on the canvas.
- **Re-export of `easymator_core`**:
  - Full access to pure Dart math, hierarchy, timelines, and clips via a single import of `package:easymator_flutter/easymator_flutter.dart`.
- **Comprehensive Studio Sandbox Example (`example/`)**:
  - Multi-perspective skin switcher (Front, Side, Back).
  - Interactive Dope Sheet timeline with keyframe recording.
  - Canvas pan, zoom, and reference grid.
  - Dynamic bone hierarchy editor and JSON animation import/export.
