# Easymator 2D Skeletal Animation Engine

[![Pub Version (Core)](https://img.shields.io/badge/easymator__core-v0.1.0-blue.svg)](https://pub.dev/packages/easymator_core)
[![Pub Version (Flutter)](https://img.shields.io/badge/easymator__flutter-v0.1.0-blue.svg)](https://pub.dev/packages/easymator_flutter)
[![License: MIT](https://img.shields.io/badge/license-MIT-purple.svg)](https://opensource.org/licenses/MIT)
[![Tests Passing](https://img.shields.io/badge/tests-all%20passing-brightgreen.svg)](https://github.com/Aakashdgupta/easymator_engine)

A clean-room, high-performance, MIT-licensed 2D skeletal puppet rigging, animation, and retargeting engine for Dart and Flutter. 

Designed with zero garbage collection pressure, deterministic timelines, closed-form analytical Two-Bone Inverse Kinematics (IK), and multi-perspective skin rendering (Front, Side, Back).

---

## Repository Structure

The engine is structured as a modular monorepo:

```plaintext
easymator_engine/
├── easymator_core/                      # Pure Dart engine (Zero Flutter dependencies)
│   ├── lib/
│   │   ├── easymator_core.dart          # Public barrel export
│   │   └── src/
│   │       ├── animation/               # Keyframe, BoneAnimationTrack, AnimationClip
│   │       ├── ik/                      # Analytical TwoBoneIK (Law of Cosines)
│   │       ├── math/                    # Transform2D, zero-allocation Matrix4 math
│   │       └── model/                   # Bone, Skeleton, Skin, Slot, CharacterRegistry
│   ├── test/                            # 14 pure Dart unit tests
│   ├── CHANGELOG.md
│   ├── LICENSE
│   └── README.md
│
├── easymator_flutter/                   # Flutter rendering bridge & widgets
│   ├── lib/
│   │   ├── easymator_flutter.dart       # Re-exports core + Flutter widgets
│   │   └── src/
│   │       ├── rendering/               # SkeletonPainter, DebugSkeletonPainter
│   │       └── widgets/                 # SkeletonView, SkeletonController
│   ├── example/                         # Interactive Visual Studio Sandbox App
│   │   ├── lib/main.dart                # Studio editor with timeline, grid, pan/zoom
│   │   └── test/widget_test.dart        # Headless widget integration test
│   ├── CHANGELOG.md
│   ├── LICENSE
│   └── README.md
│
├── launch_sandbox.bat                   # 1-click launcher for the visual sandbox
├── LICENSE                              # Master MIT License
└── TODO.md                              # Roadmap & Milestone tracker
```

---

## Quick Start (Flutter)

### 1. Add Dependency
In your Flutter app's `pubspec.yaml`:

```yaml
dependencies:
  easymator_flutter: ^0.1.0
```

### 2. Render & Animate in 20 Lines
```dart
import 'package:flutter/material.dart';
import 'package:easymator_flutter/easymator_flutter.dart';

class CharacterWidget extends StatefulWidget {
  const CharacterWidget({super.key});
  @override
  State<CharacterWidget> createState() => _CharacterWidgetState();
}

class _CharacterWidgetState extends State<CharacterWidget>
    with SingleTickerProviderStateMixin {
  late SkeletonController _controller;

  @override
  void initState() {
    super.initState();
    // 1. Initialize controller with character preset
    _controller = SkeletonController(
      skeleton: CharacterRegistry.knightFront,
      vsync: this,
    );
    // 2. Play walk cycle loop
    _controller.play(CharacterRegistry.walkCyclePreset);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SkeletonView(controller: _controller, width: 300, height: 400);
  }
}
```

---

## Quick Start (Pure Dart / CLI / Game Engines)

For non-Flutter environments (servers, command-line tools, custom game loops), import `easymator_core`:

```yaml
dependencies:
  easymator_core: ^0.1.0
```

```dart
import 'package:easymator_core/easymator_core.dart';

void main() {
  final skeleton = CharacterRegistry.knightFront;
  final clip = CharacterRegistry.walkCyclePreset;

  // Evaluate motion at t = 0.5 seconds
  clip.evaluate(skeleton, 0.5);
  skeleton.updateWorldTransforms();

  print('Root world transform: ${skeleton.rootBone.worldTransform}');
}
```

---

## Interactive Studio Sandbox

The repository includes a comprehensive desktop/web studio sandbox in `easymator_flutter/example/`:

- **Viewport**: Infinite canvas with smooth pan, zoom (`0.2x` - `4.0x`), and spatial reference grid.
- **Interactive Dope Sheet**: Diamond keyframe markers (`◆`), time scrubber, and real-time keyframe recording for both rotation and translation (`localPosition`).
- **Dynamic Rigging**: Live bone addition, realignment sliders (Offset X/Y, Rotation, Length), and 1-click factory rig reset.
- **Persistent Storage**: Auto-saves user clips via `shared_preferences` across browser and app sessions.
- **JSON Pipeline**: 1-click import and export of animations.

### Launching the Sandbox:
- **Windows**: Double-click [`launch_sandbox.bat`](launch_sandbox.bat)
- **Terminal**:
  ```bash
  cd easymator_flutter/example
  flutter run -d chrome
  ```

---

## Running Automated Tests

### 1. Pure Dart Core Tests (14 unit tests)
```bash
cd easymator_core
dart test
```

### 2. Flutter Headless Widget Tests
```bash
cd easymator_flutter/example
flutter test
```

---

## How to Publish to Pub.dev

Publishing is executed in two simple steps:

### Step 1: Publish `easymator_core`
```bash
cd easymator_core
dart pub publish --dry-run
dart pub publish
```

### Step 2: Publish `easymator_flutter`
Update `easymator_flutter/pubspec.yaml` to point to the published version:
```yaml
dependencies:
  easymator_core: ^0.1.0
```
Then publish:
```bash
cd easymator_flutter
flutter pub publish --dry-run
flutter pub publish
```

---

## Roadmap

See [`TODO.md`](TODO.md) for current milestones, including:
- **Milestone 4**: Unified character package (`.easymator` bundle with SVG skins and animations).
- **Milestone 5**: Character Designer Studio & Action Deck (skin inspector, character profiles, 1-click action triggers).

---

## License

This project is open-source and available under the [MIT License](LICENSE).
