import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      title: 'Easymator 2D Skeletal Studio Sandbox',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF101216),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF4A90E2),
          secondary: Color(0xFF00E676),
          surface: Color(0xFF1A1D24),
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
  late final SkeletonController _controller;

  String _activeCharacterId = 'knight';
  ViewAngle _activeViewAngle = ViewAngle.front;
  String? _selectedBoneId = 'upper_arm_r';

  bool _showDebugWireframe = true;
  bool _showAttachments = true;
  bool _showGrid = true;
  bool _ikMode = false;
  Offset _ikTarget = const Offset(280, 220);

  // Active editable clip
  late AnimationClip _activeClip;

  @override
  void initState() {
    super.initState();
    _buildCharacterRig();

    // Default walk cycle
    _activeClip = _createPresetWalkClip();

    _controller = SkeletonController(
      skeleton: _skeleton,
      slots: _slots,
      initialClip: _activeClip,
    );

    _applyActiveSkin();
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

  void _applyActiveSkin() {
    final skin = CharacterRegistry.getSkin(_activeCharacterId, _activeViewAngle);
    skin.apply(_slots);
    _controller.applySkin(skin);
    setState(() {});
  }

  AnimationClip _createPresetWalkClip() {
    return AnimationClip(
      id: 'walk',
      name: 'Walk Cycle',
      duration: 1.0,
      isLooping: true,
      tracks: [
        BoneAnimationTrack(
          boneId: 'thigh_r',
          rotationKeys: [
            const Keyframe(time: 0.0, value: math.pi / 2.0 - 0.5),
            const Keyframe(time: 0.5, value: math.pi / 2.0 + 0.5),
            const Keyframe(time: 1.0, value: math.pi / 2.0 - 0.5),
          ],
        ),
        BoneAnimationTrack(
          boneId: 'shin_r',
          rotationKeys: [
            const Keyframe(time: 0.0, value: 0.2),
            const Keyframe(time: 0.25, value: 0.8),
            const Keyframe(time: 0.5, value: 0.1),
            const Keyframe(time: 1.0, value: 0.2),
          ],
        ),
        BoneAnimationTrack(
          boneId: 'thigh_l',
          rotationKeys: [
            const Keyframe(time: 0.0, value: math.pi / 2.0 + 0.5),
            const Keyframe(time: 0.5, value: math.pi / 2.0 - 0.5),
            const Keyframe(time: 1.0, value: math.pi / 2.0 + 0.5),
          ],
        ),
        BoneAnimationTrack(
          boneId: 'shin_l',
          rotationKeys: [
            const Keyframe(time: 0.0, value: 0.1),
            const Keyframe(time: 0.5, value: 0.2),
            const Keyframe(time: 0.75, value: 0.8),
            const Keyframe(time: 1.0, value: 0.1),
          ],
        ),
        BoneAnimationTrack(
          boneId: 'upper_arm_r',
          rotationKeys: [
            const Keyframe(time: 0.0, value: math.pi / 2.0 + 0.4),
            const Keyframe(time: 0.5, value: math.pi / 2.0 - 0.4),
            const Keyframe(time: 1.0, value: math.pi / 2.0 + 0.4),
          ],
        ),
        BoneAnimationTrack(
          boneId: 'upper_arm_l',
          rotationKeys: [
            const Keyframe(time: 0.0, value: math.pi / 2.0 - 0.4),
            const Keyframe(time: 0.5, value: math.pi / 2.0 + 0.4),
            const Keyframe(time: 1.0, value: math.pi / 2.0 - 0.4),
          ],
        ),
      ],
    );
  }

  AnimationClip _createPresetWaveClip() {
    return AnimationClip(
      id: 'wave',
      name: 'Wave Hand',
      duration: 1.2,
      isLooping: true,
      tracks: [
        BoneAnimationTrack(
          boneId: 'upper_arm_r',
          rotationKeys: [
            const Keyframe(time: 0.0, value: -math.pi / 3.0),
            const Keyframe(time: 0.6, value: -math.pi / 2.8),
            const Keyframe(time: 1.2, value: -math.pi / 3.0),
          ],
        ),
        BoneAnimationTrack(
          boneId: 'forearm_r',
          rotationKeys: [
            const Keyframe(time: 0.0, value: -0.6),
            const Keyframe(time: 0.3, value: 0.4),
            const Keyframe(time: 0.6, value: -0.6),
            const Keyframe(time: 0.9, value: 0.4),
            const Keyframe(time: 1.2, value: -0.6),
          ],
        ),
      ],
    );
  }

  // Record a keyframe at the current scrubber timestamp
  void _recordKeyframe() {
    final t = double.parse((_controller.currentTime % _activeClip.duration).toStringAsFixed(2));

    for (final bone in _skeleton.bones) {
      final track = _activeClip.getOrCreateTrack(bone.id);
      track.addRotationKey(Keyframe(time: t, value: bone.localRotation));
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Keyframe recorded at ${t.toStringAsFixed(2)}s for ${_skeleton.bones.length} bones!'),
        duration: const Duration(seconds: 1),
        backgroundColor: const Color(0xFF00E676),
      ),
    );
    setState(() {});
  }

  // Delete keyframe nearest to current timestamp
  void _deleteCurrentKeyframe() {
    final t = _controller.currentTime % _activeClip.duration;
    for (final track in _activeClip.tracks) {
      track.rotationKeys.removeWhere((k) => (k.time - t).abs() < 0.05);
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Keyframe removed near ${t.toStringAsFixed(2)}s'),
        duration: const Duration(seconds: 1),
        backgroundColor: Colors.orange,
      ),
    );
    setState(() {});
  }

  // Create a new blank clip
  void _showNewClipDialog() {
    final nameController = TextEditingController(text: 'Custom Animation');
    final durationController = TextEditingController(text: '1.5');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Create New Animation Clip'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Animation Name'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: durationController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: 'Duration (seconds)'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              final dur = double.tryParse(durationController.text) ?? 1.5;
              final newClip = AnimationClip(
                id: 'custom_${DateTime.now().millisecondsSinceEpoch}',
                name: nameController.text.trim(),
                duration: dur,
                isLooping: true,
                tracks: [],
              );
              setState(() {
                _activeClip = newClip;
                _controller.setClip(_activeClip);
              });
              Navigator.pop(ctx);
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  // Export JSON dialog
  void _showExportDialog() {
    final jsonString = _activeClip.toPrettyJson();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.code, color: Color(0xFF00E676)),
            const SizedBox(width: 8),
            Text('Export "${_activeClip.name}" JSON'),
          ],
        ),
        content: SizedBox(
          width: 550,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'This standard JSON format can be imported into Easymator or any Flutter game engine:',
                style: TextStyle(fontSize: 12, color: Colors.white70),
              ),
              const SizedBox(height: 12),
              Container(
                height: 240,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF0A0C0E),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.white12),
                ),
                child: SingleChildScrollView(
                  child: SelectableText(
                    jsonString,
                    style: const TextStyle(fontFamily: 'monospace', fontSize: 11),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close')),
          FilledButton.icon(
            icon: const Icon(Icons.copy, size: 16),
            label: const Text('Copy to Clipboard'),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: jsonString));
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Animation JSON copied to clipboard!'),
                  backgroundColor: Color(0xFF4A90E2),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // Import JSON dialog
  void _showImportDialog() {
    final inputController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.file_upload, color: Color(0xFF4A90E2)),
            SizedBox(width: 8),
            Text('Import Animation JSON'),
          ],
        ),
        content: SizedBox(
          width: 550,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Paste an exported .easymate.json snippet below to play it on any character:',
                style: TextStyle(fontSize: 12, color: Colors.white70),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: inputController,
                maxLines: 10,
                decoration: InputDecoration(
                  hintText: '{\n  "version": "1.0",\n  "name": "My Clip",\n  "duration": 1.2,\n  ...\n}',
                  filled: true,
                  fillColor: const Color(0xFF0A0C0E),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
                style: const TextStyle(fontFamily: 'monospace', fontSize: 11),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              try {
                final clip = AnimationClip.fromJsonString(inputController.text.trim());
                setState(() {
                  _activeClip = clip;
                  _controller.setClip(clip);
                  _controller.play();
                });
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Successfully imported "${clip.name}"!'),
                    backgroundColor: const Color(0xFF00E676),
                  ),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Invalid JSON format: $e'),
                    backgroundColor: Colors.redAccent,
                  ),
                );
              }
            },
            child: const Text('Load & Play'),
          ),
        ],
      ),
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

    // Collect all unique keyframe timestamps for dope sheet rendering
    final Set<double> keyframeTimes = {};
    for (final track in _activeClip.tracks) {
      for (final k in track.rotationKeys) {
        keyframeTimes.add(k.time);
      }
      for (final k in track.positionKeys) {
        keyframeTimes.add(k.time);
      }
    }

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 16,
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.animation, color: Color(0xFF00E676)),
            SizedBox(width: 8),
            Text(
              'Easymator 2D Studio',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
        actions: [
          SegmentedButton<String>(
            showSelectedIcon: false,
            style: const ButtonStyle(
              visualDensity: VisualDensity.compact,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            segments: const [
              ButtonSegment(value: 'knight', label: Text('Knight', style: TextStyle(fontSize: 12))),
              ButtonSegment(value: 'robot', label: Text('Robot', style: TextStyle(fontSize: 12))),
              ButtonSegment(value: 'mage', label: Text('Mage', style: TextStyle(fontSize: 12))),
            ],
            selected: {_activeCharacterId},
            onSelectionChanged: (val) {
              _activeCharacterId = val.first;
              _applyActiveSkin();
            },
          ),
          const SizedBox(width: 8),
          SegmentedButton<ViewAngle>(
            showSelectedIcon: false,
            style: const ButtonStyle(
              visualDensity: VisualDensity.compact,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            segments: const [
              ButtonSegment(value: ViewAngle.front, label: Text('Front', style: TextStyle(fontSize: 12))),
              ButtonSegment(value: ViewAngle.side, label: Text('Side', style: TextStyle(fontSize: 12))),
              ButtonSegment(value: ViewAngle.back, label: Text('Back', style: TextStyle(fontSize: 12))),
            ],
            selected: {_activeViewAngle},
            onSelectionChanged: (val) {
              _activeViewAngle = val.first;
              _applyActiveSkin();
            },
          ),
          const SizedBox(width: 8),
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              visualDensity: VisualDensity.compact,
            ),
            icon: const Icon(Icons.file_upload, size: 16),
            label: const Text('Import JSON'),
            onPressed: _showImportDialog,
          ),
          const SizedBox(width: 8),
          FilledButton.icon(
            style: FilledButton.styleFrom(
              visualDensity: VisualDensity.compact,
            ),
            icon: const Icon(Icons.download, size: 16),
            label: const Text('Export JSON'),
            onPressed: _showExportDialog,
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: Row(
        children: [
          // ------------------ MAIN VIEWPORT ------------------
          Expanded(
            flex: 3,
            child: Container(
              color: const Color(0xFF0C0E12),
              child: Stack(
                children: [
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

                  // Overlay Status Badge
                  Positioned(
                    top: 16,
                    left: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.75),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.white12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF00E676),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${_activeCharacterId.toUpperCase()} • ${_activeViewAngle.name.toUpperCase()} VIEW',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Active Clip: "${_activeClip.name}" (${_activeClip.duration.toStringAsFixed(1)}s)',
                            style: const TextStyle(color: Color(0xFF4A90E2), fontSize: 12),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Selected Bone: ${_selectedBoneId ?? "Tap limb to select"}',
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

                  // Bottom Timeline / Dope Sheet Bar
                  Positioned(
                    left: 16,
                    right: 16,
                    bottom: 16,
                    child: _buildDopeSheetBar(keyframeTimes),
                  ),
                ],
              ),
            ),
          ),

          // ------------------ INSPECTOR SIDEBAR ------------------
          Material(
            color: const Color(0xFF171A21),
            child: SizedBox(
              width: 380,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Presets Row
                  _buildSectionHeader('Presets & Clips'),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ActionChip(
                        avatar: const Icon(Icons.directions_walk, size: 16),
                        label: const Text('Walk Cycle'),
                        onPressed: () {
                          setState(() {
                            _activeClip = _createPresetWalkClip();
                            _controller.setClip(_activeClip);
                            _controller.play();
                          });
                        },
                      ),
                      ActionChip(
                        avatar: const Icon(Icons.waving_hand, size: 16),
                        label: const Text('Wave Hand'),
                        onPressed: () {
                          setState(() {
                            _activeClip = _createPresetWaveClip();
                            _controller.setClip(_activeClip);
                            _controller.play();
                          });
                        },
                      ),
                      ActionChip(
                        avatar: const Icon(Icons.add, size: 16),
                        label: const Text('New Custom Clip'),
                        onPressed: _showNewClipDialog,
                      ),
                    ],
                  ),

                  const Divider(height: 32),

                  // Authoring Actions
                  _buildSectionHeader('Keyframe Authoring'),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton.icon(
                          icon: const Icon(Icons.bookmark_add, size: 16),
                          label: const Text('Record Keyframe'),
                          style: FilledButton.styleFrom(backgroundColor: const Color(0xFF00E676), foregroundColor: Colors.black),
                          onPressed: _recordKeyframe,
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton.outlined(
                        icon: const Icon(Icons.bookmark_remove, size: 18),
                        tooltip: 'Delete keyframe at current time',
                        onPressed: _deleteCurrentKeyframe,
                      ),
                    ],
                  ),

                  const Divider(height: 32),

                  // Layer Toggles
                  _buildSectionHeader('View Layers'),
                  SwitchListTile(
                    title: const Text('Debug Wireframe', style: TextStyle(fontSize: 14)),
                    subtitle: const Text('Bones & Joints', style: TextStyle(fontSize: 12)),
                    value: _showDebugWireframe,
                    onChanged: (val) => setState(() => _showDebugWireframe = val),
                    dense: true,
                  ),
                  SwitchListTile(
                    title: const Text('Vector Attachments', style: TextStyle(fontSize: 14)),
                    subtitle: const Text('Render Active Skin', style: TextStyle(fontSize: 12)),
                    value: _showAttachments,
                    onChanged: (val) => setState(() => _showAttachments = val),
                    dense: true,
                  ),
                  SwitchListTile(
                    title: const Text('Interactive IK Mode', style: TextStyle(fontSize: 14)),
                    subtitle: const Text('Drag Right Arm Target', style: TextStyle(fontSize: 12)),
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
                  SwitchListTile(
                    title: const Text('Canvas Grid', style: TextStyle(fontSize: 14)),
                    subtitle: const Text('Background Reference Lines', style: TextStyle(fontSize: 12)),
                    value: _showGrid,
                    onChanged: (val) => setState(() => _showGrid = val),
                    dense: true,
                  ),

                  const Divider(height: 32),

                  // Bone Transform Inspector
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
                    Text('Bone Length: ${selectedBone.length.toStringAsFixed(0)} px'),
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
                          'Tap any limb in the viewport to pose it.',
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

  // Bottom Floating Dope Sheet Bar
  Widget _buildDopeSheetBar(Set<double> keyframeTimes) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF171A21).withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white12),
        boxShadow: const [
          BoxShadow(color: Colors.black54, blurRadius: 10, offset: Offset(0, 4)),
        ],
      ),
      child: ListenableBuilder(
        listenable: _controller,
        builder: (context, _) {
          final curTime = _controller.duration > 0
              ? (_controller.currentTime % _controller.duration)
              : 0.0;
          final maxDur = _controller.duration > 0 ? _controller.duration : 1.0;

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  IconButton.filled(
                    icon: Icon(_controller.isPlaying ? Icons.pause : Icons.play_arrow),
                    onPressed: _activeClip.tracks.isNotEmpty ? _controller.togglePlayPause : null,
                  ),
                  IconButton(
                    icon: const Icon(Icons.stop),
                    onPressed: _controller.stop,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${curTime.toStringAsFixed(2)}s / ${maxDur.toStringAsFixed(1)}s',
                    style: const TextStyle(fontFamily: 'monospace', fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  const SizedBox(width: 16),

                  // Keyframe markers & Scrubber
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: Stack(
                        alignment: Alignment.centerLeft,
                        children: [
                          // Dope sheet diamonds
                          LayoutBuilder(
                            builder: (context, constraints) {
                              return SizedBox(
                                width: constraints.maxWidth,
                                height: 48,
                                child: Stack(
                                  children: [
                                    for (final kt in keyframeTimes)
                                      Positioned(
                                        left: (kt / maxDur).clamp(0.0, 1.0) * (constraints.maxWidth - 24),
                                        top: 17,
                                        child: const Icon(Icons.diamond, color: Color(0xFF00E676), size: 14),
                                      ),
                                  ],
                                ),
                              );
                            },
                          ),
                          // Slider scrubber
                          Slider(
                            value: curTime,
                            max: maxDur,
                            onChanged: (val) => _controller.seek(val),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Playback speed
                  Wrap(
                    spacing: 4,
                    children: [
                      for (final s in [0.5, 1.0, 2.0])
                        ChoiceChip(
                          label: Text('${s}x', style: const TextStyle(fontSize: 11)),
                          selected: _controller.playbackSpeed == s,
                          onSelected: (val) {
                            if (val) _controller.playbackSpeed = s;
                          },
                        ),
                    ],
                  ),
                ],
              ),
            ],
          );
        },
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
