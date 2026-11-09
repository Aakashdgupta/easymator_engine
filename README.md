# Easymator 2D Skeletal Animation Engine

A clean-room, high-performance, MIT-licensed 2D skeletal puppet rigging and animation retargeting engine for Dart and Flutter.

---

## Workspace Structure

```plaintext
D:\PROJECTS\easymator_engine\
├── easymator_core/                      # Pure Dart library (Zero Flutter dependencies)
│   ├── lib/
│   │   ├── easymator_core.dart          # Public barrel export
│   │   └── src/
│   │       ├── math/                    # Transform2D, MathUtils (in-place Matrix4 mutations)
│   │       ├── model/                   # Bone, Skeleton, Slot, Attachment, Skin
│   │       ├── animation/               # Keyframe, BoneAnimationTrack, AnimationClip
│   │       └── ik/                      # TwoBoneIKSolver (Analytical Law of Cosines)
│   └── test/                            # 11 unit tests verifying forward kinematics & IK
│
├── easymator_flutter/                   # Flutter bridge & CustomPainters
│   ├── lib/
│   │   ├── easymator_flutter.dart       # Public Flutter export
│   │   └── src/
│   │       ├── rendering/               # DebugSkeletonPainter, SkeletonPainter
│   │       └── widgets/                 # SkeletonController, SkeletonView
│   └── example/                         # Interactive Visual Sandbox App
│       ├── lib/main.dart                # Viewport, Pan/Zoom, Retargeting Skin Swapper, Controls
│       └── test/widget_test.dart        # Headless widget verification test
└── launch_sandbox.bat                   # 1-click launcher for the visual sandbox
```

---

## Quick Start & Verification

### 1. Run Unit Tests (Pure Dart Math)
```bash
cd D:\PROJECTS\easymator_engine\easymator_core
dart test
```

### 2. Run Headless Flutter Widget Tests
```bash
cd D:\PROJECTS\easymator_engine\easymator_flutter\example
flutter test
```

### 3. Launch the Interactive Sandbox (Windows / Web)
Double-click `launch_sandbox.bat` or run:
```bash
cd D:\PROJECTS\easymator_engine\easymator_flutter\example
flutter run -d windows
```
*(Or use `-d chrome` for web)*

---

## Features Demonstrated in Sandbox

1. **Animation Retargeting (1-Click Skin Swapper)**:
   * Toggle between the **Knight** skin (silver armor, blue torso, gauntlets) and **Robot** skin (cyber orange, slate chassis, plasma limbs) while the walk cycle plays continuously.
2. **Forward Kinematics & Bone Hierarchy**:
   * Inspect and rotate any bone in real-time with sliders to verify that children limbs inherit rotation and translation accurately.
3. **Inverse Kinematics (IK)**:
   * Toggle "Interactive IK Mode" and drag the target to watch the arm bend realistically using a closed-form analytical solver.
4. **Zero-GC Transform Mutation**:
   * All bone transforms reuse pre-allocated matrices (`Matrix4.setFrom` & `Matrix4.multiply`) for smooth 60/120 FPS performance.
