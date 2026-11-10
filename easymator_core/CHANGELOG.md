# Changelog

All notable changes to `easymator_core` will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0] - 2026-11-10

### Added
- **Pure Dart Core Architecture**: Zero Flutter dependencies, suitable for command-line, game engines, servers, and client applications.
- **Hierarchical Bone Tree (`Skeleton` & `Bone`)**:
  - Forward kinematics propagation with parent-child matrix transforms.
  - Dynamic bone creation (`addBone`), removal (`removeBone`), and reparenting (`reparentBone`).
  - Rest pose alignment and bone length configurations.
- **Analytical Two-Bone Inverse Kinematics (`TwoBoneIK`)**:
  - Law of Cosines closed-form analytical solver.
  - Configurable pole vector bending constraints for knees and elbows.
  - Target reach clamping to prevent joint inversion.
- **Deterministic Animation System**:
  - Timeline tracks (`BoneAnimationTrack`) supporting both rotation (`rotationKeys`) and translation (`positionKeys`).
  - Linear vector interpolation (`Vector3.lerp`) and continuous angular interpolation.
  - Clip playback evaluation (`AnimationClip.evaluate`).
- **Bidirectional JSON Serialization**:
  - `toJson()` and `fromJson()` across `Keyframe`, `BoneAnimationTrack`, and `AnimationClip`.
  - Human-readable pretty JSON exporter (`toPrettyJson`) and deserializer (`fromJsonString`).
- **Character Registry & Multi-Perspective Skins**:
  - Universal 12-bone biped skeleton with setup pose compensation.
  - 9 production skins across 3 archetypes (Knight, Robot, Mage) and 3 camera perspectives (`ViewAngle.front`, `ViewAngle.side`, `ViewAngle.back`).
