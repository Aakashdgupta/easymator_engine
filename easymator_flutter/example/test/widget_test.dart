import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:easymator_example/main.dart';

void main() {
  testWidgets('Sandbox studio boots up, manages animation library, and supports bone addition and realignment', (tester) async {
    // Set fixed virtual desktop window size
    tester.view.physicalSize = const Size(1600, 1000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(const EasymatorSandboxApp());
    await tester.pump(const Duration(milliseconds: 100));

    // 1. Verify header and brand title
    expect(find.text('Easymator 2D Studio'), findsOneWidget);

    // 2. Verify 3 Characters in Top Bar
    expect(find.text('Knight'), findsOneWidget);
    expect(find.text('Robot'), findsOneWidget);
    expect(find.text('Mage'), findsOneWidget);

    // 3. Verify 3 View Angle options in SegmentedButton
    expect(find.text('Front'), findsOneWidget);
    expect(find.text('Side'), findsOneWidget);
    expect(find.text('Back'), findsOneWidget);

    // Initial badge: KNIGHT • FRONT VIEW
    expect(find.text('KNIGHT • FRONT VIEW'), findsOneWidget);

    // 4. Test Character Retargeting: switch to Robot
    await tester.tap(find.text('Robot'));
    await tester.pump(const Duration(milliseconds: 50));
    expect(find.text('ROBOT • FRONT VIEW'), findsOneWidget);

    // Switch to Mage
    await tester.tap(find.text('Mage'));
    await tester.pump(const Duration(milliseconds: 50));
    expect(find.text('MAGE • FRONT VIEW'), findsOneWidget);

    // 5. Test Camera View Switching: switch to Side View
    await tester.tap(find.text('Side'));
    await tester.pump(const Duration(milliseconds: 50));
    expect(find.text('MAGE • SIDE VIEW'), findsOneWidget);

    // Return to Front View and Knight
    await tester.tap(find.text('Front'));
    await tester.tap(find.text('Knight'));
    await tester.pump(const Duration(milliseconds: 50));
    expect(find.text('KNIGHT • FRONT VIEW'), findsOneWidget);

    // 6. Test Playback Controls (Play / Pause toggle)
    expect(find.byIcon(Icons.play_arrow), findsOneWidget);
    await tester.tap(find.byIcon(Icons.play_arrow));
    await tester.pump(const Duration(milliseconds: 50));
    expect(find.byIcon(Icons.pause), findsOneWidget);

    // 7. Test Authoring Action: Record Keyframe
    final recordButton = find.text('Record Keyframe');
    expect(recordButton, findsOneWidget);
    await tester.tap(recordButton);
    await tester.pump(const Duration(milliseconds: 50));
    expect(find.byType(SnackBar), findsOneWidget);
    await tester.pump(const Duration(seconds: 2));

    // 8. Test Export JSON Dialog
    final exportButton = find.text('Export JSON');
    expect(exportButton, findsOneWidget);
    await tester.tap(exportButton);
    await tester.pump(const Duration(milliseconds: 50));
    expect(find.text('Export "Walk Cycle" JSON'), findsOneWidget);
    expect(find.text('Copy to Clipboard'), findsOneWidget);
    await tester.tap(find.text('Close'));
    await tester.pump(const Duration(milliseconds: 100));

    // 9. Test Import JSON Dialog
    final importButton = find.text('Import JSON');
    expect(importButton, findsOneWidget);
    await tester.tap(importButton);
    await tester.pump(const Duration(milliseconds: 50));
    expect(find.text('Import Animation JSON'), findsOneWidget);
    expect(find.text('Load & Play'), findsOneWidget);
    await tester.tap(find.text('Cancel'));
    await tester.pump(const Duration(milliseconds: 100));

    // 10. Test Animation Library Listing & Creation
    expect(find.text('Walk Cycle (1.0s)'), findsOneWidget);
    expect(find.text('Wave Hand (1.2s)'), findsOneWidget);
    expect(find.text('Idle Breathing (2.0s)'), findsOneWidget);

    // Switch to Wave Hand
    await tester.tap(find.text('Wave Hand (1.2s)'));
    await tester.pump(const Duration(milliseconds: 50));
    expect(find.text('Active Clip: "Wave Hand" (1.2s)'), findsOneWidget);

    // Create New Custom Clip
    final newClipButton = find.text('New Clip');
    expect(newClipButton, findsOneWidget);
    await tester.ensureVisible(newClipButton);
    await tester.tap(newClipButton);
    await tester.pump(const Duration(milliseconds: 50));
    expect(find.text('Create New Animation Clip'), findsOneWidget);

    await tester.enterText(find.widgetWithText(TextField, 'Clip Name'), 'Ninja Kick');
    await tester.tap(find.text('Create'));
    await tester.pump(const Duration(milliseconds: 100));

    // Verify newly created clip appears in the library!
    expect(find.text('Ninja Kick (1.5s)'), findsOneWidget);
    expect(find.text('Active Clip: "Ninja Kick" (1.5s)'), findsOneWidget);

    // 11. Test Add Bone Dialog
    final addBoneButton = find.byTooltip('Add new bone to skeleton');
    expect(addBoneButton, findsOneWidget);
    await tester.ensureVisible(addBoneButton);
    await tester.tap(addBoneButton);
    await tester.pump(const Duration(milliseconds: 50));
    expect(find.text('Add New Bone'), findsOneWidget);

    await tester.tap(find.text('Add Bone'));
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.byType(SnackBar), findsOneWidget);
    await tester.pump(const Duration(seconds: 2));

    // 12. Test Reset Rig to Default
    final resetRigButton = find.byTooltip('Reset rig to original aligned pose');
    expect(resetRigButton, findsOneWidget);
    await tester.ensureVisible(resetRigButton);
    await tester.tap(resetRigButton);
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('Rig reset to original factory alignment!'), findsOneWidget);
    await tester.pump(const Duration(seconds: 2));

    // 13. Test Bone Realignment Controls
    expect(find.textContaining('Offset X:'), findsOneWidget);
    expect(find.textContaining('Offset Y:'), findsOneWidget);
    expect(find.textContaining('Rotation:'), findsOneWidget);
    expect(find.textContaining('Bone Length:'), findsOneWidget);

    // Switch selected bone to 'Thigh (R)'
    final thighChip = find.widgetWithText(ChoiceChip, 'Thigh (R)');
    expect(thighChip, findsOneWidget);
    await tester.ensureVisible(thighChip);
    await tester.tap(thighChip);
    await tester.pump(const Duration(milliseconds: 50));
    expect(find.textContaining('Thigh (R)'), findsWidgets);

    // 14. Verify View Layers switches
    expect(find.text('Debug Wireframe'), findsOneWidget);
    expect(find.text('Vector Attachments'), findsOneWidget);
    expect(find.text('Interactive IK Mode'), findsOneWidget);
    expect(find.text('Canvas Grid'), findsOneWidget);
  });
}
