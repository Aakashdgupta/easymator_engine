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
- [x] **Task 3.1: Interactive Dope Sheet Timeline**
  - Render diamond keyframe markers (`◆`) along the timeline track in the sandbox.
  - Added "+ Record Keyframe" and "- Delete Keyframe" buttons to capture/remove bone poses at current playhead timestamp.
  - Added "New Custom Clip" authoring dialog.
- [ ] **Task 3.2: Pose Cross-Fading (Smooth Animation Blending)**
  - Implement seamless transition blending between clips (e.g. Walk -> Wave) over a configurable duration (e.g., 0.2s) using SLERP to eliminate visual popping.
- [ ] **Task 3.3: Expanded Motion Preset Library**
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
- [ ] **Task 4.2: Media Sequence Exporter**
  - Render animation loops directly to transparent animated PNG / GIF sequences or MP4 video frames.
