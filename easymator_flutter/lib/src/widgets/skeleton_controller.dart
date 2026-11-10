import 'package:flutter/foundation.dart';
import 'package:easymator_core/easymator_core.dart';

/// Interactive controller managing skeleton state, animation playback, and skin retargeting.
class SkeletonController extends ChangeNotifier {
  final Skeleton skeleton;
  final List<Slot> slots;

  AnimationClip? _currentClip;
  double _currentTime = 0.0;
  bool _isPlaying = false;
  double _playbackSpeed = 1.0;

  SkeletonController({
    required this.skeleton,
    List<Slot>? slots,
    AnimationClip? initialClip,
  })  : slots = slots ?? [],
        _currentClip = initialClip {
    if (_currentClip != null) {
      _currentClip!.apply(skeleton, 0.0);
    } else {
      skeleton.updateWorldTransforms();
    }
  }

  /// Currently loaded animation clip.
  AnimationClip? get currentClip => _currentClip;

  /// Current timeline playhead position in seconds.
  double get currentTime => _currentTime;

  /// Whether animation is actively playing.
  bool get isPlaying => _isPlaying;

  /// Playback speed multiplier (e.g. 0.5x, 1.0x, 2.0x).
  double get playbackSpeed => _playbackSpeed;
  set playbackSpeed(double value) {
    _playbackSpeed = value.clamp(0.05, 5.0);
    notifyListeners();
  }

  /// Total duration of currently active animation.
  double get duration => _currentClip?.duration ?? 0.0;

  /// Sets the active animation clip and resets playhead.
  void setClip(AnimationClip? clip) {
    _currentClip = clip;
    _currentTime = 0.0;
    _currentClip?.apply(skeleton, 0.0);
    notifyListeners();
  }

  /// Advances animation playback by [dt] seconds.
  void update(double dt) {
    if (!_isPlaying || _currentClip == null) return;

    _currentTime += dt * _playbackSpeed;
    _currentClip!.apply(skeleton, _currentTime);
    notifyListeners();
  }

  /// Manually seeks to a specific [time] along the timeline.
  void seek(double time) {
    _currentTime = time;
    _currentClip?.apply(skeleton, _currentTime);
    notifyListeners();
  }

  /// Starts playback.
  void play() {
    _isPlaying = true;
    notifyListeners();
  }

  /// Pauses playback.
  void pause() {
    _isPlaying = false;
    notifyListeners();
  }

  /// Toggles play / pause state.
  void togglePlayPause() {
    _isPlaying = !_isPlaying;
    notifyListeners();
  }

  /// Stops playback and resets timeline to 0.
  void stop() {
    _isPlaying = false;
    seek(0.0);
  }

  /// Applies a [Skin] to all slots, achieving instant **Animation Retargeting**.
  void applySkin(Skin skin) {
    skin.apply(slots);
    notifyListeners();
  }

  /// Manually adjusts a bone's local rotation angle in radians.
  void setBoneRotation(String boneId, double radians) {
    final bone = skeleton.findBone(boneId);
    if (bone != null) {
      bone.localRotation = radians;
      skeleton.updateWorldTransforms();
      notifyListeners();
    }
  }

  /// Manually adjusts a bone's local translation offset.
  void setBonePosition(String boneId, double x, double y) {
    final bone = skeleton.findBone(boneId);
    if (bone != null) {
      bone.localPosition.setValues(x, y, 0.0);
      bone.markDirty();
      skeleton.updateWorldTransforms();
      notifyListeners();
    }
  }

  /// Manually adjusts a bone's visual length.
  void setBoneLength(String boneId, double length) {
    final bone = skeleton.findBone(boneId);
    if (bone != null) {
      bone.length = length;
      bone.markDirty();
      skeleton.updateWorldTransforms();
      notifyListeners();
    }
  }

  /// Adds a new bone under [parentId] and triggers hierarchy recalculation.
  bool addBone(Bone bone, {required String parentId}) {
    final success = skeleton.addBone(bone, parentId: parentId);
    if (success) {
      notifyListeners();
    }
    return success;
  }

  /// Removes a bone by its [boneId].
  bool removeBone(String boneId) {
    final success = skeleton.removeBone(boneId);
    if (success) {
      notifyListeners();
    }
    return success;
  }

  /// Re-parents a bone under a new parent bone.
  bool reparentBone(String boneId, String newParentId) {
    if (boneId == skeleton.root.id || boneId == newParentId) return false;
    final bone = skeleton.findBone(boneId);
    final newParent = skeleton.findBone(newParentId);
    if (bone == null || newParent == null) return false;
    newParent.addChild(bone);
    skeleton.refreshHierarchy();
    skeleton.updateWorldTransforms(force: true);
    notifyListeners();
    return true;
  }
}
