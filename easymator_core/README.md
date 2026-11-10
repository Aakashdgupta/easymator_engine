# easymator_core

[![Pub Version](https://img.shields.io/badge/pub-v0.1.0-blue.svg)](https://pub.dev/packages/easymator_core)
[![Dart SDK](https://img.shields.io/badge/dart-%3E%3D3.0.0-blue.svg)](https://dart.dev)
[![License: MIT](https://img.shields.io/badge/license-MIT-purple.svg)](https://opensource.org/licenses/MIT)
[![Tests Passing](https://img.shields.io/badge/tests-14%2F14%20passing-brightgreen.svg)](https://github.com/easymator/easymator_engine)

A high-performance, MIT-licensed 2D skeletal animation, rigging, and inverse kinematics engine written in **pure Dart**. Designed with zero Flutter dependencies, it can be embedded into command-line tools, game engines, backend servers, or front-end Flutter apps via `easymator_flutter`.

---

## Features

- ⚡ **Zero-Allocation Math**: In-place matrix operations (`Matrix4.setFrom`, `multiply`) eliminate GC pressure during 60/120 FPS animation loops.
- 🦴 **Hierarchical Bone Tree**: Full Forward Kinematics (FK) with parent-child transform propagation, dynamic bone addition, reparenting, and setup pose alignment.
- 🎯 **Analytical Two-Bone IK Solver**: Fast, closed-form Law of Cosines solver with pole vector constraints for natural knee and elbow bending without numerical iterative drift.
- ⏱️ **Deterministic Timeline**: Multi-track keyframe interpolation supporting both continuous rotational angles and 3D translation (`localPosition`).
- 🔄 **Bidirectional JSON Serialization**: Full export and import support for animation clips and keyframe tracks via human-readable JSON.
- 📐 **Multi-Angle Character Registry**: Universal 12-bone biped rig with setup compensation across Front (`ViewAngle.front`), Side (`ViewAngle.side`), and Back (`ViewAngle.back`) views.

---

## Installation

Add `easymator_core` to your `pubspec.yaml`:

```yaml
dependencies:
  easymator_core: ^0.1.0
```

Then run:

```bash
dart pub get
```

---

## Quick Start

### 1. Constructing a Skeletal Rig

```dart
import 'package:easymator_core/easymator_core.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

void main() {
  // 1. Create a skeleton root
  final skeleton = Skeleton(
    id: 'biped_skeleton',
    bones: [
      Bone(id: 'root', length: 0),
      Bone(
        id: 'torso',
        parentId: 'root',
        length: 70,
        localPosition: vm.Vector3(0, -10, 0),
        localRotation: -1.5708, // -90 degrees in radians
      ),
      Bone(
        id: 'head',
        parentId: 'torso',
        length: 40,
        localPosition: vm.Vector3(70, 0, 0),
      ),
    ],
  );

  // 2. Compute world transform matrices
  skeleton.updateWorldTransforms();

  final head = skeleton.findBone('head');
  print('Head world position: ${head?.worldPosition}');
}
```

---

### 2. Analytical Two-Bone Inverse Kinematics (IK)

Solve limb positions instantly using the closed-form analytical solver:

```dart
import 'package:easymator_core/easymator_core.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

void solveArmIK(Skeleton skeleton) {
  final shoulder = skeleton.findBone('upper_arm_l')!;
  final elbow = skeleton.findBone('lower_arm_l')!;
  final target = vm.Vector3(120, -50, 0); // Where the hand should reach

  TwoBoneIKSolver.solve(
    root: shoulder,
    mid: elbow,
    targetWorld: target,
    bendPositive: true, // true = bend like elbow, false = invert
  );

  skeleton.updateWorldTransforms();
}
```

---

### 3. Creating & Evaluating Animation Clips

```dart
import 'package:easymator_core/easymator_core.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

void playMotion(Skeleton skeleton) {
  // Create an animation clip
  final clip = AnimationClip(
    name: 'wave',
    duration: 1.0,
    isLooping: true,
  );

  // Add keyframes for a bone track
  final armTrack = BoneAnimationTrack(boneId: 'upper_arm_r')
    ..addRotationKey(Keyframe(time: 0.0, value: 0.0))
    ..addRotationKey(Keyframe(time: 0.5, value: 0.8))
    ..addRotationKey(Keyframe(time: 1.0, value: 0.0));

  clip.addTrack(armTrack);

  // Evaluate pose at t = 0.5 seconds
  clip.evaluate(skeleton, 0.5);
  skeleton.updateWorldTransforms();
}
```

---

### 4. Serializing Animations to JSON

Export your animations to standard JSON to share between tools:

```dart
// Export clip to pretty JSON string
final jsonString = clip.toPrettyJson();

// Import clip from JSON string
final restoredClip = AnimationClip.fromJsonString(jsonString);
```

---

## Architecture Overview

```
easymator_core/
├── lib/
│   ├── easymator_core.dart         # Main library export
│   └── src/
│       ├── animation/              # Keyframe, BoneAnimationTrack, AnimationClip
│       ├── ik/                     # TwoBoneIKSolver (Law of Cosines)
│       ├── math/                   # Transform2D, MathUtils (zero-allocation)
│       └── model/                  # Bone, Skeleton, Skin, Slot, Attachment
└── test/                           # Comprehensive test suite (14 unit tests)
```

---

## Running Tests

Verify the math and forward kinematics suite:

```bash
dart test
```

---

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
