import 'attachment.dart';
import 'slot.dart';

/// Defines a set of [Attachment]s mapped to [Slot] IDs.
///
/// Swapping skins enables **Animation Retargeting**: applying the same bone motions
/// to different visual character designs without modifying the skeleton or animation tracks.
class Skin {
  /// Unique identifier of the skin.
  final String id;

  /// Human-readable name (e.g., 'Knight', 'Robot', 'Casual Outfit').
  String name;

  /// Mapping from slot ID to attachment.
  final Map<String, Attachment> _attachments = {};

  Skin({
    required this.id,
    this.name = '',
  }) {
    if (name.isEmpty) name = id;
  }

  /// Sets an attachment for a given [slotId].
  void setAttachment(String slotId, Attachment attachment) {
    _attachments[slotId] = attachment;
  }

  /// Retrieves the attachment configured for [slotId], or `null` if none.
  Attachment? getAttachment(String slotId) => _attachments[slotId];

  /// All registered attachments in this skin.
  Map<String, Attachment> get attachments => Map.unmodifiable(_attachments);

  /// Applies this skin to a list of [slots], updating each slot's [Slot.activeAttachment].
  void apply(List<Slot> slots) {
    for (final slot in slots) {
      if (_attachments.containsKey(slot.id)) {
        slot.activeAttachment = _attachments[slot.id];
      }
    }
  }
}
