// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pet_adoption_app/main.dart';

import 'package:pet_adoption_app/screens/screens.dart';
import 'package:pet_adoption_app/screens/widgets/widgets.dart';

void main() {
  testWidgets('Pet Adoption Test', (widgetTester) async {
    // await widgetTester.pumpWidget(
    //   MultiProvider(providers: [
    //     ChangeNotifierProvider(create: (_) => ThemeProvider()),
    //     ChangeNotifierProvider(create: (_) => PetsNotifier()),
    //   ], child: const MyApp()),
    // );

    debugPrint("Starting the test");

    debugPrint("Pump Widget my app");
    await widgetTester.pumpWidget(const MyApp());

    await widgetTester.pumpAndSettle();
    await widgetTester.pump(const Duration(seconds: 5));

    // expect the IntroScreen Widget
    expect(find.byType(IntroScreen), findsOneWidget);

    // tap on "Get Started" button
    await widgetTester.pumpAndSettle();
    await widgetTester.tap(find.byType(ElevatedButton));

    expect(find.byType(HomeScreen), findsOneWidget);

    await widgetTester.pumpAndSettle();
    await widgetTester.tap(find.byType(PetListItemWidget));

    // after taping expect the PetDetailScreen Widget
    expect(find.byType(PetDetailScreen), findsOneWidget);

    // tap on the adoption button
    await widgetTester.pumpAndSettle();
    await widgetTester.tap(find.byIcon(Icons.pets));

    // now there should be a dialog
    await widgetTester.pumpAndSettle();
    expect(find.byType(Dialog), findsOneWidget);

    await widgetTester.tap(find.byType(ElevatedButton));
    await widgetTester.pumpAndSettle();

    // now it should be back to home screen
    expect(find.byType(HomeScreen), findsOneWidget);

    await widgetTester.pumpAndSettle();
    await widgetTester.tap(find.byType(PetListItemWidget));

    // after taping expect the PetDetailScreen Widget
    expect(find.byType(PetDetailScreen), findsOneWidget);

    await widgetTester.pumpAndSettle();

    expect(find.text("Already Adopted!"), findsOneWidget);
  });
}
