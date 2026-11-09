import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:easymator_example/main.dart';

void main() {
  testWidgets('Sandbox app boots up and renders skeletal viewport and controls', (tester) async {
    // Set fixed virtual window size
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(const EasymatorSandboxApp());
    await tester.pump(const Duration(milliseconds: 100));

    // Verify title and main UI components
    expect(find.text('Easymator Skeletal Engine Sandbox'), findsOneWidget);
    expect(find.text('Knight'), findsOneWidget);
    expect(find.text('Robot'), findsOneWidget);

    // Verify view layers switches
    expect(find.text('Debug Wireframe'), findsOneWidget);
    expect(find.text('Vector Attachments'), findsOneWidget);
    expect(find.text('Interactive IK Mode'), findsOneWidget);

    // Switch skin to Robot
    await tester.tap(find.text('Robot'));
    await tester.pump(const Duration(milliseconds: 50));
    expect(find.text('Active Skin: ROBOT (Retargeted)'), findsOneWidget);

    // Switch back to Knight
    await tester.tap(find.text('Knight'));
    await tester.pump(const Duration(milliseconds: 50));
    expect(find.text('Active Skin: KNIGHT (Retargeted)'), findsOneWidget);

    // Verify animation playback controls toggle
    expect(find.byIcon(Icons.play_arrow), findsOneWidget);
    await tester.tap(find.byIcon(Icons.play_arrow));
    await tester.pump(const Duration(milliseconds: 50));
    expect(find.byIcon(Icons.pause), findsOneWidget);
  });
}
