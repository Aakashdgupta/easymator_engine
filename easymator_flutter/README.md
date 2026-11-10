# easymator_flutter

[![Pub Version](https://img.shields.io/badge/pub-v0.1.0-blue.svg)](https://pub.dev/packages/easymator_flutter)
[![Flutter](https://img.shields.io/badge/flutter-%3E%3D3.0.0-02569B.svg)](https://flutter.dev)
[![Platforms](https://img.shields.io/badge/platforms-Android%20%7C%20iOS%20%7C%20Web%20%7C%20macOS%20%7C%20Windows%20%7C%20Linux-brightgreen.svg)](https://flutter.dev)
[![License: MIT](https://img.shields.io/badge/license-MIT-purple.svg)](https://opensource.org/licenses/MIT)

The official Flutter rendering and widget layer for the **Easymator 2D Skeletal Animation Engine**. Renders multi-angle skeletal characters, handles inverse kinematics (IK), and plays deterministic animations with zero GC pressure at 60/120 FPS.

> **Note**: `easymator_flutter` automatically re-exports `easymator_core`. You only need to import this single package in your Flutter app!

---

## Features

- 🎨 **High-Performance Canvas Rendering**: Custom painter architecture renders bone segments, joint pivots, and visual skin attachments with zero raster degradation.
- 🎮 **State-Driven Controller**: `SkeletonController` manages animation playback, playhead time-scrubbing, bone rotations, and IK target positioning.
- 🕹️ **Interactive IK Dragging**: End-effector handles let users drag hands or feet with mouse or touch, bending limbs naturally via closed-form analytical TwoBoneIK.
- 🔍 **Diagnostic Wireframe Mode**: Easily switch between production skin rendering (`SkeletonPainter`) and wireframe debug mode (`DebugSkeletonPainter`).
- 🔄 **Multi-Perspective Retargeting**: Hot-swap character skins across Front, Side, and Back views during active animation playback without restarting clips.

---

## Installation

Add `easymator_flutter` to your `pubspec.yaml`:

```yaml
dependencies:
  easymator_flutter: ^0.1.0
```

Then run:

```bash
flutter pub get
```

---

## Quick Start (30-Second Example)

Here is a complete, runnable Flutter app displaying and animating a skeletal character:

```dart
import 'package:flutter/material.dart';
import 'package:easymator_flutter/easymator_flutter.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Scaffold(
      backgroundColor: Color(0xFF0F172A),
      body: Center(child: AnimatedCharacterDemo()),
    ),
  ));
}

class AnimatedCharacterDemo extends StatefulWidget {
  const AnimatedCharacterDemo({super.key});

  @override
  State<AnimatedCharacterDemo> createState() => _AnimatedCharacterDemoState();
}

class _AnimatedCharacterDemoState extends State<AnimatedCharacterDemo>
    with SingleTickerProviderStateMixin {
  late SkeletonController _controller;

  @override
  void initState() {
    super.initState();
    // 1. Choose a character preset (or supply your own custom Skeleton)
    final skeleton = CharacterRegistry.knightFront;

    // 2. Instantiate the controller with TickerProvider
    _controller = SkeletonController(
      skeleton: skeleton,
      vsync: this,
    );

    // 3. Play the walk cycle animation
    _controller.play(CharacterRegistry.walkCyclePreset);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 4. Render the character widget
    return SkeletonView(
      controller: _controller,
      width: 400,
      height: 400,
      showBones: false, // Set to true to show debug wireframes
    );
  }
}
```

---

## Core Widgets & APIs

### `SkeletonView`
The primary Flutter widget that paints the skeleton onto the screen:

| Property | Type | Description |
| :--- | :--- | :--- |
| `controller` | `SkeletonController` | The controller driving the skeleton's state and animation. |
| `width` | `double` | Display width in logical pixels. |
| `height` | `double` | Display height in logical pixels. |
| `showBones` | `bool` | Toggles debug bone wireframe rendering (default: `false`). |
| `ikHandleRadius` | `double` | Radius of interactive IK drag handles (default: `14.0`). |

### `SkeletonController`
Manages the lifecycle and state of a `Skeleton`:

```dart
// Playback controls
controller.play(walkClip);
controller.pause();
controller.stop();
controller.seek(0.5); // Seek to 0.5 seconds

// Dynamic bone adjustments
controller.setBoneRotation('torso', 0.2);
controller.setBoneLength('arm_l', 55.0);

// Multi-angle perspective swapping
controller.setSkeleton(CharacterRegistry.knightSide);

// Inverse Kinematics target positioning
controller.setIKTarget('arm_l_ik', Offset(100, 200));
```

---

## Interactive Studio Sandbox

This package includes a full studio designer sandbox in the `example/` directory featuring:
- Viewport with smooth pan, zoom (`0.2x` - `4.0x`), and reference grid.
- Interactive Dope Sheet timeline with keyframe recording.
- Dynamic bone addition, realignment sliders, and rig reset.
- Bidirectional JSON import/export dialogs.

To launch the sandbox in Google Chrome:

```bash
cd example
flutter run -d chrome
```

---

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
