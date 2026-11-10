# Easymator Engine: Improvement & Feature Backlog (TODO)

This backlog outlines completed and upcoming milestones to evolve the engine from technical sandbox to studio-grade animation system.

---

## Milestone 0: Multi-Perspective Character Rigging & Retargeting (Completed)
- [x] **Task 0.1: 3-Angle Multi-View Character Pipeline**
  - Designed clean modular 2D camera perspectives: `ViewAngle.front`, `ViewAngle.side`, and `ViewAngle.back`.
  - Seamlessly reuses universal 12-bone biped skeleton across all views with setup pose offset compensation.
- [x] **Task 0.2: 9-Skin Universal Registry**
  - Built `CharacterRegistry` bundling 9 production skins:
    - **Knight**: Front plate armor, Side visor profile, Backplate with cape drape.
    - **Robot**: Front neon core, Side antenna & exhaust, Rear cooling fins & spine harness.
    - **Mage**: Front crystal pendant, Side hat peak & robe drape, Rear wizard cowl & hem.
  - Zero-cost hot retargeting during active animation playback.

---

## Milestone 1: UX & Interactive Canvas Manipulation
- [x] **Task 1.0: Viewport Pan, Zoom & Reference Grid**
  - Interactive canvas navigation via `InteractiveViewer` with `0.2x` to `4.0x` zoom range and smooth pan.
  - Multi-tiered background reference grid (`_GridPainter`) with major and minor grid lines.
  - Smart gesture arbitration: canvas panning automatically suspends when dragging IK handles (`panEnabled: !_ikMode`).
- [ ] **Task 1.1: Direct On-Canvas Rotation Gizmo**
  - Render an interactive circular arc/wheel handle around the active selected joint directly on the canvas.
  - Allow dragging the handle with mouse/touch to rotate bones interactively rather than relying solely on sidebar sliders.
  - Add angle snapping (holding Shift for 15° increments).
- [ ] **Task 1.2: Full-Body IK & Foot Pinning**
  - Support multiple concurrent IK targets (Left Foot, Right Foot, Right Hand).
  - Pin feet to ground level so pulling the hips/root down causes both knees and ankles to bend realistically into a natural crouch.

---

## Milestone 2: Visual Polish & Organic Joint Overlaps
- [ ] **Task 2.1: Rounded Joint Caps & Gapless Bending**
  - Introduce circular joint cap geometry at pivot centers (shoulders, elbows, knees) so sharp limb bends do not reveal angular gaps or disconnections.
- [ ] **Task 2.2: Stylized Character Facial & Accessory Slots**
  - Add expressive sub-slots: eyes, visors, hands/palms with fingers, and boots/footwear for all character archetypes.
- [ ] **Task 2.3: Dynamic Z-Ordering / Draw-Order Keyframing**
  - Enable animating slot `zIndex` over time so limbs naturally pass in front of or behind the torso during movement cycles.

---

## Milestone 3: Animation System & Studio Authoring
- [x] **Task 3.1: Interactive Dope Sheet Timeline & Persistent Clips**
  - Diamond keyframe markers (`◆`) along the timeline track in the sandbox for both rotation and translation (`localPosition`).
  - Added "+ Record Keyframe" and "- Delete Keyframe" to capture/remove bone poses and translations at current playhead timestamp.
  - Clip creation and library switcher with auto-save & restore via `shared_preferences`.
- [x] **Task 3.2: Dynamic Rigging & Bone Realignment Tools**
  - Dynamic bone creation under any parent joint with length, rotation, offset, and visual capsule shape.
  - Bone inspector with sliders and fine-step controls for Offset X, Offset Y, Rotation (-180° to +180°), Length, and Reparenting.
  - 1-click "Reset Rig to Default" factory restore.
- [ ] **Task 3.3: Pose Cross-Fading (Smooth Animation Blending)**
  - Implement seamless transition blending between clips (e.g. Walk -> Wave) over a configurable duration (e.g., 0.2s) using SLERP to eliminate visual popping.
- [ ] **Task 3.4: Expanded Motion Preset Library**
  - Author and bundle:
    - **Idle Breathing** (gentle chest bounce and arm sway, 1.5s loop)
    - **Sprint / Run Cycle** (aggressive forward lean, high knee lifts, 0.6s loop)
    - **Jump & Land** (crouch -> air apex -> ground impact recovery)
    - **Cheer / Celebration** (arms raised overhead, torso pumping)

---

## Milestone 4: Import / Export & File Pipelines
- [x] **Task 4.1: JSON Rig & Motion Serialization**
  - Implemented `Keyframe.toJson()` / `fromJson()`, `BoneAnimationTrack.toJson()` / `fromJson()`, and `AnimationClip.toJson()` / `toPrettyJson()` / `fromJson()`.
  - In-sandbox **Export JSON Dialog** with syntax-highlighted preview and 1-click clipboard copy.
  - In-sandbox **Import JSON Dialog** to paste and test custom animation files on any skin.
- [ ] **Task 4.2: Unified Character Package (`.easymator` Bundle)**
  - Package complete skeleton rig, multi-perspective skins (SVG vector slots), and full animation library (multiple named clips) into a single `.easymator` JSON bundle.
  - Single-click **"Export Character (.easymator)"** in the Sandbox.
  - Drag-and-drop / file picker **"Import Character (.easymator)"** in the Sandbox to instantly load any external character.
  - SVG skin attachment rendering: paint vector SVG paths/shapes aligned to bone pivots with zero pixelation at 120 FPS.
  - High-level 1-line consuming API for Flutter apps like Easymator:
    - `final character = await EasymatorCharacter.load('assets/knight.easymator');`
    - `EasymatorView(character: character)`
- [ ] **Task 4.3: Media Sequence Exporter**
  - Render animation loops directly to transparent animated PNG / GIF sequences or MP4 video frames.
