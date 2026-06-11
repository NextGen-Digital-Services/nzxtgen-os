import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nzxtgen_os/core/widgets/primary_button.dart';
import 'package:nzxtgen_os/core/widgets/glass_card.dart';
import 'package:nzxtgen_os/core/widgets/status_badge.dart';
import 'package:nzxtgen_os/core/widgets/ambient_glow.dart';

void main() {
  testWidgets('PrimaryButton renders successfully and handles clicks', (WidgetTester tester) async {
    bool pressed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: PrimaryButton(
              text: 'Tap Here',
              variant: ButtonVariant.primary,
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

  testWidgets('GlassCard renders child content correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: GlassCard(
            tier: GlassTier.tier3,
            child: Text('Frosted Layer'),
          ),
        ),
      ),
    );

    expect(find.text('Frosted Layer'), findsOneWidget);
  });

  testWidgets('StatusBadge displays status label in uppercase', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: StatusBadge(
            label: 'active',
            type: StatusType.active,
          ),
        ),
      ),
    );

    expect(find.text('ACTIVE'), findsOneWidget);
  });

  testWidgets('AmbientGlow renders with container structures', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: AmbientGlow(
            size: 200,
            color: Colors.blue,
          ),
        ),
      ),
    );

    expect(find.byType(AmbientGlow), findsOneWidget);
  });
}
