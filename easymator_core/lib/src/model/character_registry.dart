import 'package:vector_math/vector_math_64.dart';
import 'attachment.dart';
import 'skin.dart';

/// Supported camera view perspectives for 2D character rigs.
enum ViewAngle {
  front,
  side,
  back,
}

/// Metadata describing a character archetype.
class CharacterProfile {
  final String id;
  final String name;
  final String description;

  const CharacterProfile({
    required this.id,
    required this.name,
    required this.description,
  });
}

/// Comprehensive registry of multi-angle character skins (3 Characters x 3 Views = 9 Skins).
class CharacterRegistry {
  CharacterRegistry._();

  static const List<CharacterProfile> characters = [
    CharacterProfile(
      id: 'knight',
      name: 'Knight',
      description: 'Medieval plate armor, helm visor, and royal blue surcoat.',
    ),
    CharacterProfile(
      id: 'robot',
      name: 'Robot',
      description: 'Cybernetic mech with optic visor, battery core, and plasma blasters.',
    ),
    CharacterProfile(
      id: 'mage',
      name: 'Mage',
      description: 'Arcane wizard with pointed hat, crystal amulet, and flowing robes.',
    ),
  ];

  static final Map<String, Map<ViewAngle, Skin>> _registry = {
    'knight': {
      ViewAngle.front: _buildKnightFront(),
      ViewAngle.side: _buildKnightSide(),
      ViewAngle.back: _buildKnightBack(),
    },
    'robot': {
      ViewAngle.front: _buildRobotFront(),
      ViewAngle.side: _buildRobotSide(),
      ViewAngle.back: _buildRobotBack(),
    },
    'mage': {
      ViewAngle.front: _buildMageFront(),
      ViewAngle.side: _buildMageSide(),
      ViewAngle.back: _buildMageBack(),
    },
  };

  /// Retrieves a specific character skin for the requested [view].
  static Skin getSkin(String characterId, ViewAngle view) {
    final characterSkins = _registry[characterId] ?? _registry['knight']!;
    return characterSkins[view] ?? characterSkins[ViewAngle.front]!;
  }

  // ==========================================
  // 1. KNIGHT SKINS (Front, Side, Back)
  // ==========================================

  static Skin _buildKnightFront() {
    final skin = Skin(id: 'knight_front', name: 'Knight (Front)');
    skin.setAttachment(
      'slot_head',
      ShapeAttachment(
        id: 'knight_front_helm',
        shapeType: ShapeType.capsule,
        width: 48.0,
        height: 52.0,
        offset: Vector3(22.0, 0.0, 0.0),
        fillColor: 0xFF90A4AE, // Silver-blue steel
        strokeColor: 0xFF37474F,
        strokeWidth: 3.0,
      ),
    );
    skin.setAttachment(
      'slot_torso',
      ShapeAttachment(
        id: 'knight_front_torso',
        shapeType: ShapeType.rectangle,
        width: 80.0,
        height: 48.0,
        offset: Vector3(45.0, 0.0, 0.0),
        fillColor: 0xFF1976D2, // Royal Blue surcoat
        strokeColor: 0xFF0D47A1,
        strokeWidth: 3.0,
      ),
    );
    skin.setAttachment(
      'slot_upper_arm_r',
      ShapeAttachment(
        id: 'knight_front_uarm_r',
        shapeType: ShapeType.capsule,
        width: 50.0,
        height: 20.0,
        offset: Vector3(25.0, 0.0, 0.0),
        fillColor: 0xFFB0BEC5,
        strokeColor: 0xFF37474F,
      ),
    );
    skin.setAttachment(
      'slot_forearm_r',
      ShapeAttachment(
        id: 'knight_front_farm_r',
        shapeType: ShapeType.capsule,
        width: 45.0,
        height: 18.0,
        offset: Vector3(22.0, 0.0, 0.0),
        fillColor: 0xFF78909C,
        strokeColor: 0xFF263238,
      ),
    );
    skin.setAttachment(
      'slot_upper_arm_l',
      ShapeAttachment(
        id: 'knight_front_uarm_l',
        shapeType: ShapeType.capsule,
        width: 50.0,
        height: 20.0,
        offset: Vector3(25.0, 0.0, 0.0),
        fillColor: 0xFF90A4AE,
        strokeColor: 0xFF37474F,
      ),
    );
    skin.setAttachment(
      'slot_forearm_l',
      ShapeAttachment(
        id: 'knight_front_farm_l',
        shapeType: ShapeType.capsule,
        width: 45.0,
        height: 18.0,
        offset: Vector3(22.0, 0.0, 0.0),
        fillColor: 0xFF607D8B,
        strokeColor: 0xFF263238,
      ),
    );
    skin.setAttachment(
      'slot_thigh_r',
      ShapeAttachment(
        id: 'knight_front_thigh_r',
        shapeType: ShapeType.capsule,
        width: 55.0,
        height: 22.0,
        offset: Vector3(28.0, 0.0, 0.0),
        fillColor: 0xFFB0BEC5,
        strokeColor: 0xFF37474F,
      ),
    );
    skin.setAttachment(
      'slot_shin_r',
      ShapeAttachment(
        id: 'knight_front_shin_r',
        shapeType: ShapeType.capsule,
        width: 50.0,
        height: 18.0,
        offset: Vector3(25.0, 0.0, 0.0),
        fillColor: 0xFF78909C,
        strokeColor: 0xFF263238,
      ),
    );
    skin.setAttachment(
      'slot_thigh_l',
      ShapeAttachment(
        id: 'knight_front_thigh_l',
        shapeType: ShapeType.capsule,
        width: 55.0,
        height: 22.0,
        offset: Vector3(28.0, 0.0, 0.0),
        fillColor: 0xFF90A4AE,
        strokeColor: 0xFF37474F,
      ),
    );
    skin.setAttachment(
      'slot_shin_l',
      ShapeAttachment(
        id: 'knight_front_shin_l',
        shapeType: ShapeType.capsule,
        width: 50.0,
        height: 18.0,
        offset: Vector3(25.0, 0.0, 0.0),
        fillColor: 0xFF607D8B,
        strokeColor: 0xFF263238,
      ),
    );
    return skin;
  }

  static Skin _buildKnightSide() {
    final skin = Skin(id: 'knight_side', name: 'Knight (Side)');
    skin.setAttachment(
      'slot_head',
      ShapeAttachment(
        id: 'knight_side_helm',
        shapeType: ShapeType.rectangle,
        width: 54.0,
        height: 48.0,
        offset: Vector3(22.0, 6.0, 0.0), // Visor jutting forward
        fillColor: 0xFF78909C,
        strokeColor: 0xFF263238,
        strokeWidth: 3.0,
      ),
    );
    skin.setAttachment(
      'slot_torso',
      ShapeAttachment(
        id: 'knight_side_torso',
        shapeType: ShapeType.capsule,
        width: 82.0,
        height: 38.0, // Narrower side silhouette
        offset: Vector3(45.0, 0.0, 0.0),
        fillColor: 0xFF1565C0,
        strokeColor: 0xFF0D47A1,
        strokeWidth: 3.0,
      ),
    );
    skin.setAttachment(
      'slot_upper_arm_r',
      ShapeAttachment(
        id: 'knight_side_uarm_r',
        shapeType: ShapeType.capsule,
        width: 52.0,
        height: 24.0, // Near pauldron shield
        offset: Vector3(26.0, 0.0, 0.0),
        fillColor: 0xFFB0BEC5,
        strokeColor: 0xFF37474F,
      ),
    );
    skin.setAttachment(
      'slot_forearm_r',
      ShapeAttachment(
        id: 'knight_side_farm_r',
        shapeType: ShapeType.rectangle,
        width: 48.0,
        height: 18.0,
        offset: Vector3(24.0, 0.0, 0.0),
        fillColor: 0xFF90A4AE,
        strokeColor: 0xFF263238,
      ),
    );
    skin.setAttachment(
      'slot_upper_arm_l',
      ShapeAttachment(
        id: 'knight_side_uarm_l',
        shapeType: ShapeType.capsule,
        width: 44.0,
        height: 16.0, // Far arm recessed
        offset: Vector3(22.0, 0.0, 0.0),
        fillColor: 0xFF546E7A,
        strokeColor: 0xFF263238,
      ),
    );
    skin.setAttachment(
      'slot_forearm_l',
      ShapeAttachment(
        id: 'knight_side_farm_l',
        shapeType: ShapeType.capsule,
        width: 40.0,
        height: 14.0,
        offset: Vector3(20.0, 0.0, 0.0),
        fillColor: 0xFF455A64,
        strokeColor: 0xFF263238,
      ),
    );
    skin.setAttachment(
      'slot_thigh_r',
      ShapeAttachment(
        id: 'knight_side_thigh_r',
        shapeType: ShapeType.capsule,
        width: 56.0,
        height: 24.0,
        offset: Vector3(28.0, 0.0, 0.0),
        fillColor: 0xFFB0BEC5,
        strokeColor: 0xFF37474F,
      ),
    );
    skin.setAttachment(
      'slot_shin_r',
      ShapeAttachment(
        id: 'knight_side_shin_r',
        shapeType: ShapeType.rectangle,
        width: 52.0,
        height: 20.0,
        offset: Vector3(26.0, 3.0, 0.0), // Sabaton toe forward
        fillColor: 0xFF78909C,
        strokeColor: 0xFF263238,
      ),
    );
    skin.setAttachment(
      'slot_thigh_l',
      ShapeAttachment(
        id: 'knight_side_thigh_l',
        shapeType: ShapeType.capsule,
        width: 50.0,
        height: 18.0,
        offset: Vector3(25.0, 0.0, 0.0),
        fillColor: 0xFF546E7A,
        strokeColor: 0xFF263238,
      ),
    );
    skin.setAttachment(
      'slot_shin_l',
      ShapeAttachment(
        id: 'knight_side_shin_l',
        shapeType: ShapeType.capsule,
        width: 46.0,
        height: 16.0,
        offset: Vector3(23.0, 0.0, 0.0),
        fillColor: 0xFF455A64,
        strokeColor: 0xFF263238,
      ),
    );
    return skin;
  }

  static Skin _buildKnightBack() {
    final skin = Skin(id: 'knight_back', name: 'Knight (Back)');
    skin.setAttachment(
      'slot_head',
      ShapeAttachment(
        id: 'knight_back_helm',
        shapeType: ShapeType.capsule,
        width: 48.0,
        height: 52.0,
        offset: Vector3(22.0, 0.0, 0.0),
        fillColor: 0xFF546E7A, // Steel cowl / neck guard
        strokeColor: 0xFF263238,
        strokeWidth: 3.0,
      ),
    );
    skin.setAttachment(
      'slot_torso',
      ShapeAttachment(
        id: 'knight_back_cape',
        shapeType: ShapeType.rectangle,
        width: 86.0, // Wide flowing cape covering back
        height: 54.0,
        offset: Vector3(45.0, 0.0, 0.0),
        fillColor: 0xFF0D47A1, // Deep Navy Cape
        strokeColor: 0xFF002171,
        strokeWidth: 3.5,
      ),
    );
    skin.setAttachment(
      'slot_upper_arm_r',
      ShapeAttachment(
        id: 'knight_back_uarm_r',
        shapeType: ShapeType.capsule,
        width: 48.0,
        height: 18.0,
        offset: Vector3(24.0, 0.0, 0.0),
        fillColor: 0xFF78909C,
        strokeColor: 0xFF37474F,
      ),
    );
    skin.setAttachment(
      'slot_forearm_r',
      ShapeAttachment(
        id: 'knight_back_farm_r',
        shapeType: ShapeType.capsule,
        width: 44.0,
        height: 16.0,
        offset: Vector3(22.0, 0.0, 0.0),
        fillColor: 0xFF546E7A,
        strokeColor: 0xFF263238,
      ),
    );
    skin.setAttachment(
      'slot_upper_arm_l',
      ShapeAttachment(
        id: 'knight_back_uarm_l',
        shapeType: ShapeType.capsule,
        width: 48.0,
        height: 18.0,
        offset: Vector3(24.0, 0.0, 0.0),
        fillColor: 0xFF78909C,
        strokeColor: 0xFF37474F,
      ),
    );
    skin.setAttachment(
      'slot_forearm_l',
      ShapeAttachment(
        id: 'knight_back_farm_l',
        shapeType: ShapeType.capsule,
        width: 44.0,
        height: 16.0,
        offset: Vector3(22.0, 0.0, 0.0),
        fillColor: 0xFF546E7A,
        strokeColor: 0xFF263238,
      ),
    );
    skin.setAttachment(
      'slot_thigh_r',
      ShapeAttachment(
        id: 'knight_back_thigh_r',
        shapeType: ShapeType.capsule,
        width: 55.0,
        height: 20.0,
        offset: Vector3(28.0, 0.0, 0.0),
        fillColor: 0xFF78909C,
        strokeColor: 0xFF37474F,
      ),
    );
    skin.setAttachment(
      'slot_shin_r',
      ShapeAttachment(
        id: 'knight_back_shin_r',
        shapeType: ShapeType.capsule,
        width: 50.0,
        height: 18.0,
        offset: Vector3(25.0, 0.0, 0.0),
        fillColor: 0xFF546E7A,
        strokeColor: 0xFF263238,
      ),
    );
    skin.setAttachment(
      'slot_thigh_l',
      ShapeAttachment(
        id: 'knight_back_thigh_l',
        shapeType: ShapeType.capsule,
        width: 55.0,
        height: 20.0,
        offset: Vector3(28.0, 0.0, 0.0),
        fillColor: 0xFF78909C,
        strokeColor: 0xFF37474F,
      ),
    );
    skin.setAttachment(
      'slot_shin_l',
      ShapeAttachment(
        id: 'knight_back_shin_l',
        shapeType: ShapeType.capsule,
        width: 50.0,
        height: 18.0,
        offset: Vector3(25.0, 0.0, 0.0),
        fillColor: 0xFF546E7A,
        strokeColor: 0xFF263238,
      ),
    );
    return skin;
  }

  // ==========================================
  // 2. ROBOT SKINS (Front, Side, Back)
  // ==========================================

  static Skin _buildRobotFront() {
    final skin = Skin(id: 'robot_front', name: 'Robot (Front)');
    skin.setAttachment(
      'slot_head',
      ShapeAttachment(
        id: 'robot_front_head',
        shapeType: ShapeType.rectangle,
        width: 44.0,
        height: 44.0,
        offset: Vector3(22.0, 0.0, 0.0),
        fillColor: 0xFFFF6D00, // Cyber Neon Orange Visor
        strokeColor: 0xFF212121,
        strokeWidth: 3.5,
      ),
    );
    skin.setAttachment(
      'slot_torso',
      ShapeAttachment(
        id: 'robot_front_torso',
        shapeType: ShapeType.rectangle,
        width: 82.0,
        height: 52.0,
        offset: Vector3(45.0, 0.0, 0.0),
        fillColor: 0xFF263238, // Slate Black Chassis
        strokeColor: 0xFFFF6D00,
        strokeWidth: 3.0,
      ),
    );
    skin.setAttachment(
      'slot_upper_arm_r',
      ShapeAttachment(
        id: 'robot_front_uarm_r',
        shapeType: ShapeType.rectangle,
        width: 48.0,
        height: 16.0,
        offset: Vector3(24.0, 0.0, 0.0),
        fillColor: 0xFFFF9E80,
        strokeColor: 0xFF212121,
      ),
    );
    skin.setAttachment(
      'slot_forearm_r',
      ShapeAttachment(
        id: 'robot_front_farm_r',
        shapeType: ShapeType.rectangle,
        width: 45.0,
        height: 22.0,
        offset: Vector3(22.0, 0.0, 0.0),
        fillColor: 0xFFFF3D00,
        strokeColor: 0xFF212121,
      ),
    );
    skin.setAttachment(
      'slot_upper_arm_l',
      ShapeAttachment(
        id: 'robot_front_uarm_l',
        shapeType: ShapeType.rectangle,
        width: 48.0,
        height: 16.0,
        offset: Vector3(24.0, 0.0, 0.0),
        fillColor: 0xFFFF9E80,
        strokeColor: 0xFF212121,
      ),
    );
    skin.setAttachment(
      'slot_forearm_l',
      ShapeAttachment(
        id: 'robot_front_farm_l',
        shapeType: ShapeType.rectangle,
        width: 45.0,
        height: 22.0,
        offset: Vector3(22.0, 0.0, 0.0),
        fillColor: 0xFFFF3D00,
        strokeColor: 0xFF212121,
      ),
    );
    skin.setAttachment(
      'slot_thigh_r',
      ShapeAttachment(
        id: 'robot_front_thigh_r',
        shapeType: ShapeType.capsule,
        width: 55.0,
        height: 18.0,
        offset: Vector3(28.0, 0.0, 0.0),
        fillColor: 0xFF37474F,
        strokeColor: 0xFFFF6D00,
      ),
    );
    skin.setAttachment(
      'slot_shin_r',
      ShapeAttachment(
        id: 'robot_front_shin_r',
        shapeType: ShapeType.rectangle,
        width: 50.0,
        height: 16.0,
        offset: Vector3(25.0, 0.0, 0.0),
        fillColor: 0xFFFFAB40,
        strokeColor: 0xFF212121,
      ),
    );
    skin.setAttachment(
      'slot_thigh_l',
      ShapeAttachment(
        id: 'robot_front_thigh_l',
        shapeType: ShapeType.capsule,
        width: 55.0,
        height: 18.0,
        offset: Vector3(28.0, 0.0, 0.0),
        fillColor: 0xFF37474F,
        strokeColor: 0xFFFF6D00,
      ),
    );
    skin.setAttachment(
      'slot_shin_l',
      ShapeAttachment(
        id: 'robot_front_shin_l',
        shapeType: ShapeType.rectangle,
        width: 50.0,
        height: 16.0,
        offset: Vector3(25.0, 0.0, 0.0),
        fillColor: 0xFFFFAB40,
        strokeColor: 0xFF212121,
      ),
    );
    return skin;
  }

  static Skin _buildRobotSide() {
    final skin = Skin(id: 'robot_side', name: 'Robot (Side)');
    skin.setAttachment(
      'slot_head',
      ShapeAttachment(
        id: 'robot_side_head',
        shapeType: ShapeType.rectangle,
        width: 52.0, // Antenna / optic jutting forward
        height: 40.0,
        offset: Vector3(24.0, 8.0, 0.0),
        fillColor: 0xFFFF6D00,
        strokeColor: 0xFF212121,
        strokeWidth: 3.5,
      ),
    );
    skin.setAttachment(
      'slot_torso',
      ShapeAttachment(
        id: 'robot_side_torso',
        shapeType: ShapeType.rectangle,
        width: 82.0,
        height: 40.0, // Profile chassis
        offset: Vector3(45.0, 4.0, 0.0),
        fillColor: 0xFF263238,
        strokeColor: 0xFFFF6D00,
        strokeWidth: 3.0,
      ),
    );
    skin.setAttachment(
      'slot_upper_arm_r',
      ShapeAttachment(
        id: 'robot_side_uarm_r',
        shapeType: ShapeType.rectangle,
        width: 48.0,
        height: 20.0,
        offset: Vector3(24.0, 0.0, 0.0),
        fillColor: 0xFFFF9E80,
        strokeColor: 0xFF212121,
      ),
    );
    skin.setAttachment(
      'slot_forearm_r',
      ShapeAttachment(
        id: 'robot_side_farm_r',
        shapeType: ShapeType.rectangle,
        width: 48.0,
        height: 24.0,
        offset: Vector3(24.0, 0.0, 0.0),
        fillColor: 0xFFFF3D00,
        strokeColor: 0xFF212121,
      ),
    );
    skin.setAttachment(
      'slot_upper_arm_l',
      ShapeAttachment(
        id: 'robot_side_uarm_l',
        shapeType: ShapeType.rectangle,
        width: 42.0,
        height: 14.0,
        offset: Vector3(21.0, 0.0, 0.0),
        fillColor: 0xFF5D4037,
        strokeColor: 0xFF212121,
      ),
    );
    skin.setAttachment(
      'slot_forearm_l',
      ShapeAttachment(
        id: 'robot_side_farm_l',
        shapeType: ShapeType.rectangle,
        width: 40.0,
        height: 16.0,
        offset: Vector3(20.0, 0.0, 0.0),
        fillColor: 0xFF4E342E,
        strokeColor: 0xFF212121,
      ),
    );
    skin.setAttachment(
      'slot_thigh_r',
      ShapeAttachment(
        id: 'robot_side_thigh_r',
        shapeType: ShapeType.capsule,
        width: 55.0,
        height: 20.0,
        offset: Vector3(28.0, 0.0, 0.0),
        fillColor: 0xFF37474F,
        strokeColor: 0xFFFF6D00,
      ),
    );
    skin.setAttachment(
      'slot_shin_r',
      ShapeAttachment(
        id: 'robot_side_shin_r',
        shapeType: ShapeType.rectangle,
        width: 54.0,
        height: 18.0,
        offset: Vector3(27.0, 4.0, 0.0), // Foot forward
        fillColor: 0xFFFFAB40,
        strokeColor: 0xFF212121,
      ),
    );
    skin.setAttachment(
      'slot_thigh_l',
      ShapeAttachment(
        id: 'robot_side_thigh_l',
        shapeType: ShapeType.capsule,
        width: 48.0,
        height: 16.0,
        offset: Vector3(24.0, 0.0, 0.0),
        fillColor: 0xFF263238,
        strokeColor: 0xFF212121,
      ),
    );
    skin.setAttachment(
      'slot_shin_l',
      ShapeAttachment(
        id: 'robot_side_shin_l',
        shapeType: ShapeType.rectangle,
        width: 45.0,
        height: 14.0,
        offset: Vector3(22.0, 0.0, 0.0),
        fillColor: 0xFF37474F,
        strokeColor: 0xFF212121,
      ),
    );
    return skin;
  }

  static Skin _buildRobotBack() {
    final skin = Skin(id: 'robot_back', name: 'Robot (Back)');
    skin.setAttachment(
      'slot_head',
      ShapeAttachment(
        id: 'robot_back_head',
        shapeType: ShapeType.rectangle,
        width: 44.0,
        height: 44.0,
        offset: Vector3(22.0, 0.0, 0.0),
        fillColor: 0xFF37474F, // Heat sink grill, no visor
        strokeColor: 0xFF212121,
        strokeWidth: 3.5,
      ),
    );
    skin.setAttachment(
      'slot_torso',
      ShapeAttachment(
        id: 'robot_back_torso',
        shapeType: ShapeType.rectangle,
        width: 82.0,
        height: 52.0,
        offset: Vector3(45.0, 0.0, 0.0),
        fillColor: 0xFF212121, // Spinal reactor battery
        strokeColor: 0xFFFF6D00,
        strokeWidth: 3.0,
      ),
    );
    skin.setAttachment(
      'slot_upper_arm_r',
      ShapeAttachment(
        id: 'robot_back_uarm_r',
        shapeType: ShapeType.rectangle,
        width: 48.0,
        height: 16.0,
        offset: Vector3(24.0, 0.0, 0.0),
        fillColor: 0xFF37474F,
        strokeColor: 0xFF212121,
      ),
    );
    skin.setAttachment(
      'slot_forearm_r',
      ShapeAttachment(
        id: 'robot_back_farm_r',
        shapeType: ShapeType.rectangle,
        width: 45.0,
        height: 20.0,
        offset: Vector3(22.0, 0.0, 0.0),
        fillColor: 0xFF263238,
        strokeColor: 0xFF212121,
      ),
    );
    skin.setAttachment(
      'slot_upper_arm_l',
      ShapeAttachment(
        id: 'robot_back_uarm_l',
        shapeType: ShapeType.rectangle,
        width: 48.0,
        height: 16.0,
        offset: Vector3(24.0, 0.0, 0.0),
        fillColor: 0xFF37474F,
        strokeColor: 0xFF212121,
      ),
    );
    skin.setAttachment(
      'slot_forearm_l',
      ShapeAttachment(
        id: 'robot_back_farm_l',
        shapeType: ShapeType.rectangle,
        width: 45.0,
        height: 20.0,
        offset: Vector3(22.0, 0.0, 0.0),
        fillColor: 0xFF263238,
        strokeColor: 0xFF212121,
      ),
    );
    skin.setAttachment(
      'slot_thigh_r',
      ShapeAttachment(
        id: 'robot_back_thigh_r',
        shapeType: ShapeType.capsule,
        width: 55.0,
        height: 18.0,
        offset: Vector3(28.0, 0.0, 0.0),
        fillColor: 0xFF37474F,
        strokeColor: 0xFF212121,
      ),
    );
    skin.setAttachment(
      'slot_shin_r',
      ShapeAttachment(
        id: 'robot_back_shin_r',
        shapeType: ShapeType.rectangle,
        width: 50.0,
        height: 16.0,
        offset: Vector3(25.0, 0.0, 0.0),
        fillColor: 0xFF263238,
        strokeColor: 0xFF212121,
      ),
    );
    skin.setAttachment(
      'slot_thigh_l',
      ShapeAttachment(
        id: 'robot_back_thigh_l',
        shapeType: ShapeType.capsule,
        width: 55.0,
        height: 18.0,
        offset: Vector3(28.0, 0.0, 0.0),
        fillColor: 0xFF37474F,
        strokeColor: 0xFF212121,
      ),
    );
    skin.setAttachment(
      'slot_shin_l',
      ShapeAttachment(
        id: 'robot_back_shin_l',
        shapeType: ShapeType.rectangle,
        width: 50.0,
        height: 16.0,
        offset: Vector3(25.0, 0.0, 0.0),
        fillColor: 0xFF263238,
        strokeColor: 0xFF212121,
      ),
    );
    return skin;
  }

  // ==========================================
  // 3. MAGE SKINS (Front, Side, Back)
  // ==========================================

  static Skin _buildMageFront() {
    final skin = Skin(id: 'mage_front', name: 'Mage (Front)');
    skin.setAttachment(
      'slot_head',
      ShapeAttachment(
        id: 'mage_front_hat',
        shapeType: ShapeType.capsule,
        width: 56.0, // Pointed Wizard Hat
        height: 48.0,
        offset: Vector3(24.0, 0.0, 0.0),
        fillColor: 0xFF7B1FA2, // Arcane Purple
        strokeColor: 0xFFFFD700, // Gold trim
        strokeWidth: 3.0,
      ),
    );
    skin.setAttachment(
      'slot_torso',
      ShapeAttachment(
        id: 'mage_front_robe',
        shapeType: ShapeType.rectangle,
        width: 84.0,
        height: 52.0,
        offset: Vector3(45.0, 0.0, 0.0),
        fillColor: 0xFF4A148C, // Deep Violet Robe
        strokeColor: 0xFFFFD700,
        strokeWidth: 3.0,
      ),
    );
    skin.setAttachment(
      'slot_upper_arm_r',
      ShapeAttachment(
        id: 'mage_front_uarm_r',
        shapeType: ShapeType.capsule,
        width: 52.0,
        height: 22.0, // Flared mystical sleeve
        offset: Vector3(26.0, 0.0, 0.0),
        fillColor: 0xFF6A1B9A,
        strokeColor: 0xFFFFD700,
      ),
    );
    skin.setAttachment(
      'slot_forearm_r',
      ShapeAttachment(
        id: 'mage_front_farm_r',
        shapeType: ShapeType.capsule,
        width: 44.0,
        height: 18.0,
        offset: Vector3(22.0, 0.0, 0.0),
        fillColor: 0xFF00E5FF, // Glowing Cyan Spell Orb
        strokeColor: 0xFF00B0FF,
        strokeWidth: 3.0,
      ),
    );
    skin.setAttachment(
      'slot_upper_arm_l',
      ShapeAttachment(
        id: 'mage_front_uarm_l',
        shapeType: ShapeType.capsule,
        width: 52.0,
        height: 22.0,
        offset: Vector3(26.0, 0.0, 0.0),
        fillColor: 0xFF6A1B9A,
        strokeColor: 0xFFFFD700,
      ),
    );
    skin.setAttachment(
      'slot_forearm_l',
      ShapeAttachment(
        id: 'mage_front_farm_l',
        shapeType: ShapeType.capsule,
        width: 44.0,
        height: 18.0,
        offset: Vector3(22.0, 0.0, 0.0),
        fillColor: 0xFFBA68C8,
        strokeColor: 0xFF4A148C,
      ),
    );
    skin.setAttachment(
      'slot_thigh_r',
      ShapeAttachment(
        id: 'mage_front_thigh_r',
        shapeType: ShapeType.rectangle,
        width: 55.0,
        height: 24.0,
        offset: Vector3(28.0, 0.0, 0.0),
        fillColor: 0xFF311B92,
        strokeColor: 0xFFFFD700,
      ),
    );
    skin.setAttachment(
      'slot_shin_r',
      ShapeAttachment(
        id: 'mage_front_shin_r',
        shapeType: ShapeType.capsule,
        width: 48.0,
        height: 16.0,
        offset: Vector3(24.0, 0.0, 0.0),
        fillColor: 0xFF212121, // Pointed Wizard Shoes
        strokeColor: 0xFFFFD700,
      ),
    );
    skin.setAttachment(
      'slot_thigh_l',
      ShapeAttachment(
        id: 'mage_front_thigh_l',
        shapeType: ShapeType.rectangle,
        width: 55.0,
        height: 24.0,
        offset: Vector3(28.0, 0.0, 0.0),
        fillColor: 0xFF311B92,
        strokeColor: 0xFFFFD700,
      ),
    );
    skin.setAttachment(
      'slot_shin_l',
      ShapeAttachment(
        id: 'mage_front_shin_l',
        shapeType: ShapeType.capsule,
        width: 48.0,
        height: 16.0,
        offset: Vector3(24.0, 0.0, 0.0),
        fillColor: 0xFF212121,
        strokeColor: 0xFFFFD700,
      ),
    );
    return skin;
  }

  static Skin _buildMageSide() {
    final skin = Skin(id: 'mage_side', name: 'Mage (Side)');
    skin.setAttachment(
      'slot_head',
      ShapeAttachment(
        id: 'mage_side_hat',
        shapeType: ShapeType.rectangle,
        width: 58.0, // Curved pointy hat peak
        height: 42.0,
        offset: Vector3(24.0, 6.0, 0.0),
        fillColor: 0xFF7B1FA2,
        strokeColor: 0xFFFFD700,
        strokeWidth: 3.0,
      ),
    );
    skin.setAttachment(
      'slot_torso',
      ShapeAttachment(
        id: 'mage_side_robe',
        shapeType: ShapeType.capsule,
        width: 82.0,
        height: 40.0,
        offset: Vector3(45.0, 0.0, 0.0),
        fillColor: 0xFF4A148C,
        strokeColor: 0xFFFFD700,
        strokeWidth: 3.0,
      ),
    );
    skin.setAttachment(
      'slot_upper_arm_r',
      ShapeAttachment(
        id: 'mage_side_uarm_r',
        shapeType: ShapeType.capsule,
        width: 52.0,
        height: 26.0, // Large hanging bell sleeve
        offset: Vector3(26.0, 0.0, 0.0),
        fillColor: 0xFF6A1B9A,
        strokeColor: 0xFFFFD700,
      ),
    );
    skin.setAttachment(
      'slot_forearm_r',
      ShapeAttachment(
        id: 'mage_side_farm_r',
        shapeType: ShapeType.capsule,
        width: 46.0,
        height: 20.0,
        offset: Vector3(23.0, 0.0, 0.0),
        fillColor: 0xFF00E5FF, // Crystal casting focus
        strokeColor: 0xFF00B0FF,
        strokeWidth: 3.0,
      ),
    );
    skin.setAttachment(
      'slot_upper_arm_l',
      ShapeAttachment(
        id: 'mage_side_uarm_l',
        shapeType: ShapeType.capsule,
        width: 44.0,
        height: 18.0,
        offset: Vector3(22.0, 0.0, 0.0),
        fillColor: 0xFF38006B,
        strokeColor: 0xFF212121,
      ),
    );
    skin.setAttachment(
      'slot_forearm_l',
      ShapeAttachment(
        id: 'mage_side_farm_l',
        shapeType: ShapeType.capsule,
        width: 40.0,
        height: 14.0,
        offset: Vector3(20.0, 0.0, 0.0),
        fillColor: 0xFF38006B,
        strokeColor: 0xFF212121,
      ),
    );
    skin.setAttachment(
      'slot_thigh_r',
      ShapeAttachment(
        id: 'mage_side_thigh_r',
        shapeType: ShapeType.capsule,
        width: 55.0,
        height: 22.0,
        offset: Vector3(28.0, 0.0, 0.0),
        fillColor: 0xFF311B92,
        strokeColor: 0xFFFFD700,
      ),
    );
    skin.setAttachment(
      'slot_shin_r',
      ShapeAttachment(
        id: 'mage_side_shin_r',
        shapeType: ShapeType.rectangle,
        width: 52.0,
        height: 18.0,
        offset: Vector3(26.0, 4.0, 0.0), // Pointed toe forward
        fillColor: 0xFF212121,
        strokeColor: 0xFFFFD700,
      ),
    );
    skin.setAttachment(
      'slot_thigh_l',
      ShapeAttachment(
        id: 'mage_side_thigh_l',
        shapeType: ShapeType.capsule,
        width: 48.0,
        height: 18.0,
        offset: Vector3(24.0, 0.0, 0.0),
        fillColor: 0xFF1A237E,
        strokeColor: 0xFF212121,
      ),
    );
    skin.setAttachment(
      'slot_shin_l',
      ShapeAttachment(
        id: 'mage_side_shin_l',
        shapeType: ShapeType.capsule,
        width: 44.0,
        height: 14.0,
        offset: Vector3(22.0, 0.0, 0.0),
        fillColor: 0xFF212121,
        strokeColor: 0xFF212121,
      ),
    );
    return skin;
  }

  static Skin _buildMageBack() {
    final skin = Skin(id: 'mage_back', name: 'Mage (Back)');
    skin.setAttachment(
      'slot_head',
      ShapeAttachment(
        id: 'mage_back_hood',
        shapeType: ShapeType.capsule,
        width: 54.0, // Back of Wizard Hood
        height: 48.0,
        offset: Vector3(24.0, 0.0, 0.0),
        fillColor: 0xFF4A148C,
        strokeColor: 0xFFFFD700,
        strokeWidth: 3.0,
      ),
    );
    skin.setAttachment(
      'slot_torso',
      ShapeAttachment(
        id: 'mage_back_cloak',
        shapeType: ShapeType.rectangle,
        width: 88.0, // Majestic flowing back cloak
        height: 56.0,
        offset: Vector3(45.0, 0.0, 0.0),
        fillColor: 0xFF311B92, // Midnight Arcane Robe
        strokeColor: 0xFFFFD700,
        strokeWidth: 3.5,
      ),
    );
    skin.setAttachment(
      'slot_upper_arm_r',
      ShapeAttachment(
        id: 'mage_back_uarm_r',
        shapeType: ShapeType.capsule,
        width: 50.0,
        height: 20.0,
        offset: Vector3(25.0, 0.0, 0.0),
        fillColor: 0xFF6A1B9A,
        strokeColor: 0xFF4A148C,
      ),
    );
    skin.setAttachment(
      'slot_forearm_r',
      ShapeAttachment(
        id: 'mage_back_farm_r',
        shapeType: ShapeType.capsule,
        width: 42.0,
        height: 16.0,
        offset: Vector3(21.0, 0.0, 0.0),
        fillColor: 0xFF4A148C,
        strokeColor: 0xFFFFD700,
      ),
    );
    skin.setAttachment(
      'slot_upper_arm_l',
      ShapeAttachment(
        id: 'mage_back_uarm_l',
        shapeType: ShapeType.capsule,
        width: 50.0,
        height: 20.0,
        offset: Vector3(25.0, 0.0, 0.0),
        fillColor: 0xFF6A1B9A,
        strokeColor: 0xFF4A148C,
      ),
    );
    skin.setAttachment(
      'slot_forearm_l',
      ShapeAttachment(
        id: 'mage_back_farm_l',
        shapeType: ShapeType.capsule,
        width: 42.0,
        height: 16.0,
        offset: Vector3(21.0, 0.0, 0.0),
        fillColor: 0xFF4A148C,
        strokeColor: 0xFFFFD700,
      ),
    );
    skin.setAttachment(
      'slot_thigh_r',
      ShapeAttachment(
        id: 'mage_back_thigh_r',
        shapeType: ShapeType.rectangle,
        width: 55.0,
        height: 22.0,
        offset: Vector3(28.0, 0.0, 0.0),
        fillColor: 0xFF1A237E,
        strokeColor: 0xFFFFD700,
      ),
    );
    skin.setAttachment(
      'slot_shin_r',
      ShapeAttachment(
        id: 'mage_back_shin_r',
        shapeType: ShapeType.capsule,
        width: 48.0,
        height: 16.0,
        offset: Vector3(24.0, 0.0, 0.0),
        fillColor: 0xFF212121,
        strokeColor: 0xFFFFD700,
      ),
    );
    skin.setAttachment(
      'slot_thigh_l',
      ShapeAttachment(
        id: 'mage_back_thigh_l',
        shapeType: ShapeType.rectangle,
        width: 55.0,
        height: 22.0,
        offset: Vector3(28.0, 0.0, 0.0),
        fillColor: 0xFF1A237E,
        strokeColor: 0xFFFFD700,
      ),
    );
    skin.setAttachment(
      'slot_shin_l',
      ShapeAttachment(
        id: 'mage_back_shin_l',
        shapeType: ShapeType.capsule,
        width: 48.0,
        height: 16.0,
        offset: Vector3(24.0, 0.0, 0.0),
        fillColor: 0xFF212121,
        strokeColor: 0xFFFFD700,
      ),
    );
    return skin;
  }
}
