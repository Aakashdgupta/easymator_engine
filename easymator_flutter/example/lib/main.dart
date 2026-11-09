import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vm;
import 'package:easymator_flutter/easymator_flutter.dart';

void main() {
  runApp(const EasymatorSandboxApp());
}

class EasymatorSandboxApp extends StatelessWidget {
  const EasymatorSandboxApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Easymator 2D Skeletal Engine Sandbox',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF12141A),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF4A90E2),
          secondary: Color(0xFF00E676),
          surface: Color(0xFF1E222D),
        ),
      ),
      home: const SandboxScreen(),
    );
  }
}

class SandboxScreen extends StatefulWidget {
  const SandboxScreen({super.key});

  @override
  State<SandboxScreen> createState() => _SandboxScreenState();
}

class _SandboxScreenState extends State<SandboxScreen> {
  late final Skeleton _skeleton;
  late final List<Slot> _slots;
  late final Skin _knightSkin;
  late final Skin _robotSkin;
  late final AnimationClip _walkClip;
  late final AnimationClip _waveClip;
  late final SkeletonController _controller;

  String? _selectedBoneId = 'upper_arm_r';
  String _activeSkinId = 'knight';
  bool _showDebugWireframe = true;
  bool _showAttachments = true;
  bool _showGrid = true;
  bool _ikMode = false;
  Offset _ikTarget = const Offset(280, 220);

  @override
  void initState() {
    super.initState();
    _buildCharacterRig();
    _buildSkins();
    _buildAnimations();

    _controller = SkeletonController(
      skeleton: _skeleton,
      slots: _slots,
      initialClip: _walkClip,
    );

    _knightSkin.apply(_slots);
  }

  void _buildCharacterRig() {
    // Root at world center (250, 200)
    final root = Bone(id: 'root', name: 'Root', localPosition: vm.Vector3(250.0, 200.0, 0.0), length: 20.0);

    // Torso extends upward (-Y)
    final torso = Bone(
      id: 'torso',
      name: 'Torso',
      localPosition: vm.Vector3(0.0, -10.0, 0.0),
      localRotation: -math.pi / 2.0, // Pointing up
      length: 90.0,
    );

    // Head extends further upward from Torso tip
    final head = Bone(
      id: 'head',
      name: 'Head',
      localPosition: vm.Vector3(90.0, 0.0, 0.0),
      localRotation: 0.0,
      length: 45.0,
    );

    // Right Arm (facing viewer left)
    final upperArmR = Bone(
      id: 'upper_arm_r',
      name: 'Upper Arm (R)',
      localPosition: vm.Vector3(80.0, 25.0, 0.0),
      localRotation: math.pi / 2.0, // pointing down
      length: 55.0,
    );
    final forearmR = Bone(
      id: 'forearm_r',
      name: 'Forearm (R)',
      localPosition: vm.Vector3(55.0, 0.0, 0.0),
      localRotation: 0.2,
      length: 50.0,
    );

    // Left Arm (facing viewer right)
    final upperArmL = Bone(
      id: 'upper_arm_l',
      name: 'Upper Arm (L)',
      localPosition: vm.Vector3(80.0, -25.0, 0.0),
      localRotation: math.pi / 2.0,
      length: 55.0,
    );
    final forearmL = Bone(
      id: 'forearm_l',
      name: 'Forearm (L)',
      localPosition: vm.Vector3(55.0, 0.0, 0.0),
      localRotation: -0.2,
      length: 50.0,
    );

    // Right Leg
    final thighR = Bone(
      id: 'thigh_r',
      name: 'Thigh (R)',
      localPosition: vm.Vector3(0.0, 15.0, 0.0),
      localRotation: math.pi / 2.0,
      length: 60.0,
    );
    final shinR = Bone(
      id: 'shin_r',
      name: 'Shin (R)',
      localPosition: vm.Vector3(60.0, 0.0, 0.0),
      localRotation: 0.0,
      length: 55.0,
    );

    // Left Leg
    final thighL = Bone(
      id: 'thigh_l',
      name: 'Thigh (L)',
      localPosition: vm.Vector3(0.0, -15.0, 0.0),
      localRotation: math.pi / 2.0,
      length: 60.0,
    );
    final shinL = Bone(
      id: 'shin_l',
      name: 'Shin (L)',
      localPosition: vm.Vector3(60.0, 0.0, 0.0),
      localRotation: 0.0,
      length: 55.0,
    );

    // Assembly
    root.addChild(torso);
    torso.addChild(head);
    torso.addChild(upperArmR);
    upperArmR.addChild(forearmR);
    torso.addChild(upperArmL);
    upperArmL.addChild(forearmL);

    root.addChild(thighR);
    thighR.addChild(shinR);
    root.addChild(thighL);
    thighL.addChild(shinL);

    _skeleton = Skeleton(id: 'character_biped', name: 'Biped Rig', root: root);
    _skeleton.updateWorldTransforms();

    // Define rendering slots
    _slots = [
      Slot(id: 'slot_head', boneId: 'head', zIndex: 10),
      Slot(id: 'slot_torso', boneId: 'torso', zIndex: 5),
      Slot(id: 'slot_upper_arm_r', boneId: 'upper_arm_r', zIndex: 15),
      Slot(id: 'slot_forearm_r', boneId: 'forearm_r', zIndex: 16),
      Slot(id: 'slot_upper_arm_l', boneId: 'upper_arm_l', zIndex: 1),
      Slot(id: 'slot_forearm_l', boneId: 'forearm_l', zIndex: 2),
      Slot(id: 'slot_thigh_r', boneId: 'thigh_r', zIndex: 7),
      Slot(id: 'slot_shin_r', boneId: 'shin_r', zIndex: 8),
      Slot(id: 'slot_thigh_l', boneId: 'thigh_l', zIndex: 3),
      Slot(id: 'slot_shin_l', boneId: 'shin_l', zIndex: 4),
    ];
  }

  void _buildSkins() {
    // --- Skin 1: Knight (Silver & Royal Blue) ---
    _knightSkin = Skin(id: 'knight', name: 'Knight Armor');
    _knightSkin.setAttachment(
      'slot_head',
      ShapeAttachment(
        id: 'knight_helmet',
        shapeType: ShapeType.capsule,
        width: 48.0,
        height: 52.0,
        offset: vm.Vector3(22.0, 0.0, 0.0),
        fillColor: 0xFF90A4AE, // Silver-blue steel
        strokeColor: 0xFF37474F,
        strokeWidth: 3.0,
      ),
    );
    _knightSkin.setAttachment(
      'slot_torso',
      ShapeAttachment(
        id: 'knight_breastplate',
        shapeType: ShapeType.rectangle,
        width: 80.0,
        height: 48.0,
        offset: vm.Vector3(45.0, 0.0, 0.0),
        fillColor: 0xFF1976D2, // Royal Blue
        strokeColor: 0xFF0D47A1,
        strokeWidth: 3.0,
      ),
    );
    _knightSkin.setAttachment(
      'slot_upper_arm_r',
      ShapeAttachment(
        id: 'knight_arm_r',
        shapeType: ShapeType.capsule,
        width: 50.0,
        height: 20.0,
        offset: vm.Vector3(25.0, 0.0, 0.0),
        fillColor: 0xFFB0BEC5,
        strokeColor: 0xFF37474F,
      ),
    );
    _knightSkin.setAttachment(
      'slot_forearm_r',
      ShapeAttachment(
        id: 'knight_gauntlet_r',
        shapeType: ShapeType.capsule,
        width: 45.0,
        height: 18.0,
        offset: vm.Vector3(22.0, 0.0, 0.0),
        fillColor: 0xFF78909C,
        strokeColor: 0xFF263238,
      ),
    );
    _knightSkin.setAttachment(
      'slot_upper_arm_l',
      ShapeAttachment(
        id: 'knight_arm_l',
        shapeType: ShapeType.capsule,
        width: 50.0,
        height: 20.0,
        offset: vm.Vector3(25.0, 0.0, 0.0),
        fillColor: 0xFF90A4AE,
        strokeColor: 0xFF37474F,
      ),
    );
    _knightSkin.setAttachment(
      'slot_forearm_l',
      ShapeAttachment(
        id: 'knight_gauntlet_l',
        shapeType: ShapeType.capsule,
        width: 45.0,
        height: 18.0,
        offset: vm.Vector3(22.0, 0.0, 0.0),
        fillColor: 0xFF607D8B,
        strokeColor: 0xFF263238,
      ),
    );
    _knightSkin.setAttachment(
      'slot_thigh_r',
      ShapeAttachment(
        id: 'knight_thigh_r',
        shapeType: ShapeType.capsule,
        width: 55.0,
        height: 22.0,
        offset: vm.Vector3(28.0, 0.0, 0.0),
        fillColor: 0xFFB0BEC5,
        strokeColor: 0xFF37474F,
      ),
    );
    _knightSkin.setAttachment(
      'slot_shin_r',
      ShapeAttachment(
        id: 'knight_greave_r',
        shapeType: ShapeType.capsule,
        width: 50.0,
        height: 18.0,
        offset: vm.Vector3(25.0, 0.0, 0.0),
        fillColor: 0xFF78909C,
        strokeColor: 0xFF263238,
      ),
    );
    _knightSkin.setAttachment(
      'slot_thigh_l',
      ShapeAttachment(
        id: 'knight_thigh_l',
        shapeType: ShapeType.capsule,
        width: 55.0,
        height: 22.0,
        offset: vm.Vector3(28.0, 0.0, 0.0),
        fillColor: 0xFF90A4AE,
        strokeColor: 0xFF37474F,
      ),
    );
    _knightSkin.setAttachment(
      'slot_shin_l',
      ShapeAttachment(
        id: 'knight_greave_l',
        shapeType: ShapeType.capsule,
        width: 50.0,
        height: 18.0,
        offset: vm.Vector3(25.0, 0.0, 0.0),
        fillColor: 0xFF607D8B,
        strokeColor: 0xFF263238,
      ),
    );

    // --- Skin 2: Sci-Fi Robot (Cyberpunk Orange & Slate Black) ---
    _robotSkin = Skin(id: 'robot', name: 'Cybernetic Robot');
    _robotSkin.setAttachment(
      'slot_head',
      ShapeAttachment(
        id: 'robot_sensor_head',
        shapeType: ShapeType.rectangle,
        width: 44.0,
        height: 44.0,
        offset: vm.Vector3(22.0, 0.0, 0.0),
        fillColor: 0xFFFF6D00, // Cyber Neon Orange
        strokeColor: 0xFF212121,
        strokeWidth: 3.5,
      ),
    );
    _robotSkin.setAttachment(
      'slot_torso',
      ShapeAttachment(
        id: 'robot_chassis',
        shapeType: ShapeType.rectangle,
        width: 82.0,
        height: 54.0,
        offset: vm.Vector3(45.0, 0.0, 0.0),
        fillColor: 0xFF263238, // Slate Black
        strokeColor: 0xFFFF6D00,
        strokeWidth: 3.0,
      ),
    );
    _robotSkin.setAttachment(
      'slot_upper_arm_r',
      ShapeAttachment(
        id: 'robot_arm_r',
        shapeType: ShapeType.rectangle,
        width: 48.0,
        height: 16.0,
        offset: vm.Vector3(24.0, 0.0, 0.0),
        fillColor: 0xFFFF9E80,
        strokeColor: 0xFF212121,
      ),
    );
    _robotSkin.setAttachment(
      'slot_forearm_r',
      ShapeAttachment(
        id: 'robot_plasma_r',
        shapeType: ShapeType.rectangle,
        width: 45.0,
        height: 22.0,
        offset: vm.Vector3(22.0, 0.0, 0.0),
        fillColor: 0xFFFF3D00,
        strokeColor: 0xFF212121,
      ),
    );
    _robotSkin.setAttachment(
      'slot_upper_arm_l',
      ShapeAttachment(
        id: 'robot_arm_l',
        shapeType: ShapeType.rectangle,
        width: 48.0,
        height: 16.0,
        offset: vm.Vector3(24.0, 0.0, 0.0),
        fillColor: 0xFFFF9E80,
        strokeColor: 0xFF212121,
      ),
    );
    _robotSkin.setAttachment(
      'slot_forearm_l',
      ShapeAttachment(
        id: 'robot_plasma_l',
        shapeType: ShapeType.rectangle,
        width: 45.0,
        height: 22.0,
        offset: vm.Vector3(22.0, 0.0, 0.0),
        fillColor: 0xFFFF3D00,
        strokeColor: 0xFF212121,
      ),
    );
    _robotSkin.setAttachment(
      'slot_thigh_r',
      ShapeAttachment(
        id: 'robot_hydraulics_thigh_r',
        shapeType: ShapeType.capsule,
        width: 55.0,
        height: 18.0,
        offset: vm.Vector3(28.0, 0.0, 0.0),
        fillColor: 0xFF37474F,
        strokeColor: 0xFFFF6D00,
      ),
    );
    _robotSkin.setAttachment(
      'slot_shin_r',
      ShapeAttachment(
        id: 'robot_piston_shin_r',
        shapeType: ShapeType.rectangle,
        width: 50.0,
        height: 16.0,
        offset: vm.Vector3(25.0, 0.0, 0.0),
        fillColor: 0xFFFFAB40,
        strokeColor: 0xFF212121,
      ),
    );
    _robotSkin.setAttachment(
      'slot_thigh_l',
      ShapeAttachment(
        id: 'robot_hydraulics_thigh_l',
        shapeType: ShapeType.capsule,
        width: 55.0,
        height: 18.0,
        offset: vm.Vector3(28.0, 0.0, 0.0),
        fillColor: 0xFF37474F,
        strokeColor: 0xFFFF6D00,
      ),
    );
    _robotSkin.setAttachment(
      'slot_shin_l',
      ShapeAttachment(
        id: 'robot_piston_shin_l',
        shapeType: ShapeType.rectangle,
        width: 50.0,
        height: 16.0,
        offset: vm.Vector3(25.0, 0.0, 0.0),
        fillColor: 0xFFFFAB40,
        strokeColor: 0xFF212121,
      ),
    );
  }

  void _buildAnimations() {
    // 1. Walk Cycle (1.0s loop)
    _walkClip = AnimationClip(
      id: 'walk',
      name: 'Walk Cycle',
      duration: 1.0,
      isLooping: true,
      tracks: [
        // Legs swinging opposite
        BoneAnimationTrack(
          boneId: 'thigh_r',
          rotationKeys: [
            Keyframe(time: 0.0, value: math.pi / 2.0 - 0.5),
            Keyframe(time: 0.5, value: math.pi / 2.0 + 0.5),
            Keyframe(time: 1.0, value: math.pi / 2.0 - 0.5),
          ],
        ),
        BoneAnimationTrack(
          boneId: 'shin_r',
          rotationKeys: [
            Keyframe(time: 0.0, value: 0.2),
            Keyframe(time: 0.25, value: 0.8),
            Keyframe(time: 0.5, value: 0.1),
            Keyframe(time: 1.0, value: 0.2),
          ],
        ),
        BoneAnimationTrack(
          boneId: 'thigh_l',
          rotationKeys: [
            Keyframe(time: 0.0, value: math.pi / 2.0 + 0.5),
            Keyframe(time: 0.5, value: math.pi / 2.0 - 0.5),
            Keyframe(time: 1.0, value: math.pi / 2.0 + 0.5),
          ],
        ),
        BoneAnimationTrack(
          boneId: 'shin_l',
          rotationKeys: [
            Keyframe(time: 0.0, value: 0.1),
            Keyframe(time: 0.5, value: 0.2),
            Keyframe(time: 0.75, value: 0.8),
            Keyframe(time: 1.0, value: 0.1),
          ],
        ),
        // Arms swinging in opposition to legs
        BoneAnimationTrack(
          boneId: 'upper_arm_r',
          rotationKeys: [
            Keyframe(time: 0.0, value: math.pi / 2.0 + 0.4),
            Keyframe(time: 0.5, value: math.pi / 2.0 - 0.4),
            Keyframe(time: 1.0, value: math.pi / 2.0 + 0.4),
          ],
        ),
        BoneAnimationTrack(
          boneId: 'upper_arm_l',
          rotationKeys: [
            Keyframe(time: 0.0, value: math.pi / 2.0 - 0.4),
            Keyframe(time: 0.5, value: math.pi / 2.0 + 0.4),
            Keyframe(time: 1.0, value: math.pi / 2.0 - 0.4),
          ],
        ),
        // Torso slight bounce
        BoneAnimationTrack(
          boneId: 'torso',
          positionKeys: [
            Keyframe(time: 0.0, value: vm.Vector3(0.0, -10.0, 0.0)),
            Keyframe(time: 0.25, value: vm.Vector3(0.0, -5.0, 0.0)),
            Keyframe(time: 0.5, value: vm.Vector3(0.0, -10.0, 0.0)),
            Keyframe(time: 0.75, value: vm.Vector3(0.0, -5.0, 0.0)),
            Keyframe(time: 1.0, value: vm.Vector3(0.0, -10.0, 0.0)),
          ],
        ),
      ],
    );

    // 2. Wave Hand Animation
    _waveClip = AnimationClip(
      id: 'wave',
      name: 'Wave Hand',
      duration: 1.2,
      isLooping: true,
      tracks: [
        BoneAnimationTrack(
          boneId: 'upper_arm_r',
          rotationKeys: [
            Keyframe(time: 0.0, value: -math.pi / 3.0),
            Keyframe(time: 0.6, value: -math.pi / 2.8),
            Keyframe(time: 1.2, value: -math.pi / 3.0),
          ],
        ),
        BoneAnimationTrack(
          boneId: 'forearm_r',
          rotationKeys: [
            Keyframe(time: 0.0, value: -0.6),
            Keyframe(time: 0.3, value: 0.4),
            Keyframe(time: 0.6, value: -0.6),
            Keyframe(time: 0.9, value: 0.4),
            Keyframe(time: 1.2, value: -0.6),
          ],
        ),
      ],
    );
  }

  void _applyIK(Offset target) {
    setState(() {
      _ikTarget = target;
      final parent = _skeleton.findBone('upper_arm_r');
      final child = _skeleton.findBone('forearm_r');
      if (parent != null && child != null) {
        TwoBoneIKSolver.solve(
          parent: parent,
          child: child,
          targetWorldPos: vm.Vector3(target.dx, target.dy, 0.0),
          bendPositive: true,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedBone = _skeleton.findBone(_selectedBoneId ?? '');

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.animation, color: Color(0xFF00E676)),
            SizedBox(width: 10),
            Text('Easymator Skeletal Engine Sandbox'),
          ],
        ),
        actions: [
          Row(
            children: [
              const Text('Skin: '),
              ChoiceChip(
                label: const Text('Knight'),
                selected: _activeSkinId == 'knight',
                onSelected: (val) {
                  if (val) {
                    setState(() => _activeSkinId = 'knight');
                    _controller.applySkin(_knightSkin);
                  }
                },
              ),
              const SizedBox(width: 8),
              ChoiceChip(
                label: const Text('Robot'),
                selected: _activeSkinId == 'robot',
                onSelected: (val) {
                  if (val) {
                    setState(() => _activeSkinId = 'robot');
                    _controller.applySkin(_robotSkin);
                  }
                },
              ),
              const SizedBox(width: 16),
            ],
          ),
        ],
      ),
      body: Row(
        children: [
          // ------------------ VIEWPORT ------------------
          Expanded(
            flex: 3,
            child: Container(
              color: const Color(0xFF0D0F14),
              child: Stack(
                children: [
                  // Subtle Grid Background
                  if (_showGrid) const _GridBackground(),

                  // Interactive Viewport with Pan & Zoom
                  InteractiveViewer(
                    boundaryMargin: const EdgeInsets.all(400),
                    minScale: 0.3,
                    maxScale: 3.5,
                    child: GestureDetector(
                      onPanUpdate: _ikMode
                          ? (details) => _applyIK(details.localPosition)
                          : null,
                      child: SkeletonView(
                        controller: _controller,
                        showDebugWireframe: _showDebugWireframe,
                        showAttachments: _showAttachments,
                        selectedBoneId: _selectedBoneId,
                        onBoneSelected: (bone) {
                          setState(() {
                            _selectedBoneId = bone?.id;
                          });
                        },
                      ),
                    ),
                  ),

                  // Overlay Tooltips & Status Indicator
                  Positioned(
                    top: 16,
                    left: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.65),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.white12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Rig: ${_skeleton.name} (${_skeleton.bones.length} Bones)',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Active Skin: ${_activeSkinId.toUpperCase()} (Retargeted)',
                            style: const TextStyle(color: Color(0xFF00E676), fontSize: 12),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Selected: ${_selectedBoneId ?? "None (Tap bone to select)"}',
                            style: const TextStyle(color: Colors.white70, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Floating IK Handle
                  if (_ikMode)
                    Positioned(
                      left: _ikTarget.dx - 12,
                      top: _ikTarget.dy - 12,
                      child: const Icon(Icons.gps_fixed, color: Colors.amber, size: 24),
                    ),
                ],
              ),
            ),
          ),

          // ------------------ INSPECTOR SIDEBAR ------------------
          Material(
            color: const Color(0xFF1E222D),
            child: SizedBox(
              width: 380,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // 1. Playback Section
                  _buildSectionHeader('Animation Timeline'),
                  const SizedBox(height: 8),
                  SegmentedButton<String>(
                    segments: const [
                      ButtonSegment(value: 'walk', label: Text('Walk')),
                      ButtonSegment(value: 'wave', label: Text('Wave')),
                      ButtonSegment(value: 'manual', label: Text('Posing')),
                    ],
                    selected: {
                      _controller.currentClip == _walkClip
                          ? 'walk'
                          : _controller.currentClip == _waveClip
                              ? 'wave'
                              : 'manual'
                    },
                    onSelectionChanged: (val) {
                      final selected = val.first;
                      if (selected == 'walk') {
                        _controller.setClip(_walkClip);
                        _controller.play();
                      } else if (selected == 'wave') {
                        _controller.setClip(_waveClip);
                        _controller.play();
                      } else {
                        _controller.setClip(null);
                      }
                      setState(() {});
                    },
                  ),
                  const SizedBox(height: 12),

                  // Play / Pause / Scrubber
                  ListenableBuilder(
                    listenable: _controller,
                    builder: (context, _) {
                      return Column(
                        children: [
                          Row(
                            children: [
                              IconButton.filled(
                                icon: Icon(_controller.isPlaying ? Icons.pause : Icons.play_arrow),
                                onPressed: _controller.currentClip != null ? _controller.togglePlayPause : null,
                              ),
                              IconButton(
                                icon: const Icon(Icons.stop),
                                onPressed: _controller.currentClip != null ? _controller.stop : null,
                              ),
                              Expanded(
                                child: Slider(
                                  value: _controller.duration > 0
                                      ? (_controller.currentTime % _controller.duration)
                                      : 0.0,
                                  max: _controller.duration > 0 ? _controller.duration : 1.0,
                                  onChanged: (val) => _controller.seek(val),
                                ),
                              ),
                              Text(
                                '${_controller.currentTime.toStringAsFixed(2)}s',
                                style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          // Playback Speed
                          Wrap(
                            spacing: 6,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              const Text('Speed: ', style: TextStyle(fontSize: 12)),
                              for (final speed in [0.25, 0.5, 1.0, 2.0])
                                ChoiceChip(
                                  label: Text('${speed}x', style: const TextStyle(fontSize: 11)),
                                  selected: _controller.playbackSpeed == speed,
                                  onSelected: (val) {
                                    if (val) _controller.playbackSpeed = speed;
                                  },
                                ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),

                  const Divider(height: 32),

                  // 2. View Options
                  _buildSectionHeader('View Layers'),
                  SwitchListTile(
                    title: const Text('Debug Wireframe', style: TextStyle(fontSize: 14)),
                    subtitle: const Text('Bones, Joints, Pivots', style: TextStyle(fontSize: 12)),
                    value: _showDebugWireframe,
                    onChanged: (val) => setState(() => _showDebugWireframe = val),
                    dense: true,
                  ),
                  SwitchListTile(
                    title: const Text('Vector Attachments', style: TextStyle(fontSize: 14)),
                    subtitle: const Text('Modular Character Skin', style: TextStyle(fontSize: 12)),
                    value: _showAttachments,
                    onChanged: (val) => setState(() => _showAttachments = val),
                    dense: true,
                  ),
                  SwitchListTile(
                    title: const Text('Interactive IK Mode', style: TextStyle(fontSize: 14)),
                    subtitle: const Text('Drag Right Arm via Law of Cosines', style: TextStyle(fontSize: 12)),
                    value: _ikMode,
                    onChanged: (val) {
                      setState(() {
                        _ikMode = val;
                        if (_ikMode) {
                          _controller.setClip(null);
                          _applyIK(_ikTarget);
                        }
                      });
                    },
                    dense: true,
                  ),

                  const Divider(height: 32),

                  // 3. Bone Inspector (Forward Kinematics Sliders)
                  _buildSectionHeader('Selected Bone: ${_selectedBoneId ?? "None"}'),
                  if (selectedBone != null) ...[
                    const SizedBox(height: 8),
                    Text('Local Rotation (${MathUtils.radToDeg(selectedBone.localRotation).toStringAsFixed(1)}°)'),
                    Slider(
                      min: -math.pi,
                      max: math.pi,
                      value: selectedBone.localRotation,
                      onChanged: (val) {
                        _controller.setBoneRotation(selectedBone.id, val);
                        setState(() {});
                      },
                    ),
                    Text('Local Length: ${selectedBone.length.toStringAsFixed(0)} px'),
                    Slider(
                      min: 10.0,
                      max: 150.0,
                      value: selectedBone.length,
                      onChanged: (val) {
                        setState(() {
                          selectedBone.length = val;
                          _skeleton.updateWorldTransforms(force: true);
                        });
                      },
                    ),
                  ] else ...[
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Center(
                        child: Text(
                          'Tap any bone in the viewport to inspect & pose it with sliders.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white54, fontSize: 13),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title.toUpperCase(),
      style: const TextStyle(
        fontSize: 11,
        letterSpacing: 1.2,
        fontWeight: FontWeight.bold,
        color: Color(0xFF90A4AE),
      ),
    );
  }
}

/// Subtle blueprint/dark grid background pattern.
class _GridBackground extends StatelessWidget {
  const _GridBackground();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.infinite,
      painter: _GridPainter(),
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.04)
      ..strokeWidth = 1.0;

    const step = 40.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
