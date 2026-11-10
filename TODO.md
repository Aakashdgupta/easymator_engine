# Easymator Engine: Improvement & Feature Backlog (TODO)

This backlog outlines upcoming milestones to evolve the engine from technical sandbox to studio-grade animation system.

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
  - Add expressive sub-slots: eyes, visors, hands/palms with fingers, and boots/footwear for both the Knight and Robot skins.
- [ ] **Task 2.3: Dynamic Z-Ordering / Draw-Order Keyframing**
  - Enable animating slot `zIndex` over time so limbs naturally pass in front of or behind the torso during movement cycles.

---

## Milestone 3: Animation System & Studio Authoring
- [ ] **Task 3.1: Interactive Dope Sheet Timeline**
  - Render diamond keyframe markers (`◆`) along the timeline track in the sandbox.
  - Add an "Add / Record Keyframe" button to capture the current character pose at the playhead timestamp.
  - Support per-keyframe easing curve customization (`easeInOut`, `bounce`, `elastic`).
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
- [ ] **Task 4.1: JSON Rig & Motion Serialization**
  - Add `Skeleton.toJson()` / `Skeleton.fromJson()` and `AnimationClip.toJson()` / `AnimationClip.fromJson()`.
  - Add 1-click "Export Rig (.json)" button in the sandbox to generate files ready for direct import into the main Easymator app.
- [ ] **Task 4.2: Media Sequence Exporter**
  - Render animation loops directly to transparent animated PNG / GIF sequences or MP4 video frames.
