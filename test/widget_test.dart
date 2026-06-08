import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nzxtgen_os/core/widgets/primary_button.dart';

void main() {
  testWidgets('PrimaryButton renders successfully and handles clicks', (WidgetTester tester) async {
    bool pressed = false;

    // Pump a testing material app containing the primary button
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: PrimaryButton(
              text: 'Tap Here',
              onPressed: () {
                pressed = true;
              },
            ),
          ),
        ),
      ),
    );

    // Verify button text is displayed
    expect(find.text('Tap Here'), findsOneWidget);

    // Click on the button and verify event callback triggers
    await tester.tap(find.text('Tap Here'));
    expect(pressed, isTrue);
  });
}
