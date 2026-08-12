import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ecardo_etrip/src/features/travel/travel_foundation.dart';

void main() {
  testWidgets('TravelButton renders its label', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TravelButton(label: 'Continue', onPressed: () {}),
        ),
      ),
    );

    expect(find.text('Continue'), findsOneWidget);
  });

  testWidgets('TravelInput renders label and hint', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: TravelInput(label: 'Destination', hint: 'Choose a city'),
        ),
      ),
    );

    expect(find.text('Destination'), findsOneWidget);
    expect(find.text('Choose a city'), findsOneWidget);
  });

  testWidgets('TravelErrorState exposes retry action', (tester) async {
    var retried = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TravelErrorState(
            message: 'Could not load',
            onRetry: () => retried = true,
          ),
        ),
      ),
    );

    await tester.tap(find.text('Retry'));
    expect(retried, isTrue);
  });

  test('route registry resolves canonical routes', () {
    expect(TravelRouteRegistry.contains(TravelRoutes.hotelSearch.path), isTrue);
    expect(TravelRouteRegistry.resolve('/unknown'), isNull);
  });
}
