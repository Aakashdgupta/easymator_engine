import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:easymator_example/main.dart';

void main() {
  testWidgets('Sandbox studio boots up, switches 3 characters across 3 views, and opens export/import dialogs', (tester) async {
    // Set fixed virtual desktop window size
    tester.view.physicalSize = const Size(1400, 900);
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

    // Switch to Back View
    await tester.tap(find.text('Back'));
    await tester.pump(const Duration(milliseconds: 50));
    expect(find.text('MAGE • BACK VIEW'), findsOneWidget);

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

    // Dismiss snackbar
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

    // 10. Verify View Layer Switches
    expect(find.text('Debug Wireframe'), findsOneWidget);
    expect(find.text('Vector Attachments'), findsOneWidget);
    expect(find.text('Interactive IK Mode'), findsOneWidget);
    expect(find.text('Canvas Grid'), findsOneWidget);
  });
}
