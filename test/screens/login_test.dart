import 'package:community/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const MaterialApp app = MaterialApp(
    home: Scaffold(body: const LoginScreen()),
  );
  testWidgets('Login page Widget test', (WidgetTester tester) async {
    await tester.pumpWidget(app);
    expect(find.byType(LoginScreen), findsOneWidget);
    // Finding the phone number form
    expect(find.byType(TextFormField), findsOneWidget);
    await tester.enterText(find.byType(TextFormField), "12345");
    expect(find.byType(RaisedButton), findsOneWidget);
    await tester.tap(find.byType(RaisedButton));
    await tester.pumpAndSettle();
    expect(find.text("Please enter a 10 digit valid phone number"),
        findsOneWidget);
  });
}
