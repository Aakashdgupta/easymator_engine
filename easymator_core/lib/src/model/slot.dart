import 'attachment.dart';

/// A rendering slot bound to a specific bone.
///
/// Slots control the Z-order (draw depth) and hold the currently active [Attachment].
class Slot {
  /// Unique identifier of the slot.
  final String id;

  /// Human-readable name.
  String name;

  /// ID of the bone to which this slot is bound.
  final String boneId;

  /// Draw order index (lower values are drawn behind higher values).
  int zIndex;

  /// Currently active attachment rendered for this slot.
  Attachment? activeAttachment;

  /// Opacity multiplier ($0.0 \dots 1.0$).
  double opacity;

  /// Optional ARGB color tint.
  int colorTint;

  Slot({
    required this.id,
    this.name = '',
    required this.boneId,
    this.zIndex = 0,
    this.activeAttachment,
    this.opacity = 1.0,
    this.colorTint = 0xFFFFFFFF,
  }) {
    if (name.isEmpty) name = id;
  }
}
