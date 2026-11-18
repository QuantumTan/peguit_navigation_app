import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:peguit_navigation_app/demo_auth.dart';
import 'package:peguit_navigation_app/main.dart';
import 'package:peguit_navigation_app/social_media/create_post_sheet.dart';

class _TestHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (cert, host, port) => true;
  }
}

void main() {
  setUp(() {
    HttpOverrides.global = _TestHttpOverrides();
    DemoAuth.logout();
    DemoAuth.registeredUsername = null;
    DemoAuth.registeredPassword = null;
  });

  testWidgets('Complete Step 11 verification flow', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(const StudentApp());
    await tester.pumpAndSettle();

    // 1. Open the application -> Login appears first.
    expect(find.text('Login'), findsWidgets);
    expect(find.text('Welcome Back!'), findsOneWidget);

    // 2. Submit empty login fields -> Validation messages appear.
    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pumpAndSettle();
    expect(find.text('Enter your username.'), findsOneWidget);
    expect(find.text('Enter your password.'), findsOneWidget);

    // 3. Enter incorrect credentials -> Login is rejected.
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Username'),
      'wronguser',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Password'),
      'wrongpass',
    );
    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pumpAndSettle();
    expect(find.text('Invalid username or password.'), findsOneWidget);

    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();

    // 4. Enter admin / admin123 -> Dashboard opens.
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Username'),
      'admin',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Password'),
      'admin123',
    );
    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pumpAndSettle();

    // 5. Read the dashboard greeting -> Displays Welcome, admin!
    expect(find.text('Welcome, admin!'), findsOneWidget);

    // 6. Open Calculator and calculate 10 + 5 -> Displays 15.0.
    await tester.tap(find.widgetWithText(NavigationDestination, 'Calculator'));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.widgetWithText(TextFormField, 'First number'),
      '10',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Second number'),
      '5',
    );
    await tester.tap(find.widgetWithText(ElevatedButton, '+'));
    await tester.pumpAndSettle();
    expect(find.text('15.0'), findsOneWidget);

    // 7. Switch tabs and return to Calculator -> Inputs and result remain.
    await tester.tap(find.widgetWithText(NavigationDestination, 'Dashboard'));
    await tester.pumpAndSettle();
    expect(find.text('Welcome, admin!'), findsOneWidget);

    await tester.tap(find.widgetWithText(NavigationDestination, 'Calculator'));
    await tester.pumpAndSettle();
    expect(find.text('10'), findsOneWidget);
    expect(find.text('5'), findsOneWidget);
    expect(find.text('15.0'), findsOneWidget);

    // Also verify Step 7 checkpoint: 20 and 5 for +, -, *, /
    await tester.enterText(
      find.widgetWithText(TextFormField, 'First number'),
      '20',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Second number'),
      '5',
    );
    await tester.tap(find.widgetWithText(ElevatedButton, '+'));
    await tester.pumpAndSettle();
    expect(find.text('25.0'), findsOneWidget);

    await tester.tap(find.widgetWithText(ElevatedButton, '−'));
    await tester.pumpAndSettle();
    expect(find.text('15.0'), findsOneWidget);

    await tester.tap(find.widgetWithText(ElevatedButton, '×'));
    await tester.pumpAndSettle();
    expect(find.text('100.0'), findsOneWidget);

    await tester.tap(find.widgetWithText(ElevatedButton, '÷'));
    await tester.pumpAndSettle();
    expect(find.text('4.0'), findsOneWidget);

    // 8. Open Social and create a social post -> Post displays admin.
    await tester.tap(find.widgetWithText(NavigationDestination, 'Social'));
    await tester.pumpAndSettle();

    expect(find.text('JohnDoe'), findsOneWidget);
    expect(find.text('JaneSmith'), findsOneWidget);

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    final sheetTextFields = find.descendant(
      of: find.byType(CreatePostSheet),
      matching: find.byType(TextField),
    );
    await tester.enterText(sheetTextFields.at(0), 'My test post');
    await tester.enterText(
      sheetTextFields.at(1),
      'https://picsum.photos/id/20/600/400',
    );
    await tester.tap(find.widgetWithText(ElevatedButton, 'Submit Post'));
    await tester.pumpAndSettle();

    expect(find.text('My test post'), findsOneWidget);
    expect(find.text('admin'), findsOneWidget);

    // 9. Like a post and add a comment -> Both interactions update correctly.
    await tester.tap(find.widgetWithText(TextButton, 'Like').first);
    await tester.pumpAndSettle();
    expect(find.text('Liked'), findsOneWidget);

    await tester.enterText(
      find.widgetWithText(TextField, 'Add a comment...').first,
      'Nice post!',
    );
    await tester.tap(find.byTooltip('Send comment').first);
    await tester.pumpAndSettle();
    expect(find.text('Nice post!'), findsOneWidget);
    expect(find.text('1 Comments'), findsOneWidget);

    // 10. Switch tabs and return to Social -> Posts, likes, and comments remain.
    await tester.tap(find.widgetWithText(NavigationDestination, 'Dashboard'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(NavigationDestination, 'Social'));
    await tester.pumpAndSettle();

    expect(find.text('My test post'), findsOneWidget);
    expect(find.text('Liked'), findsOneWidget);
    expect(find.text('Nice post!'), findsOneWidget);

    // 11. Open Profile -> Student information and username appear.
    await tester.tap(find.widgetWithText(NavigationDestination, 'Profile'));
    await tester.pumpAndSettle();
    expect(find.text('Jonathan Jr. H. Peguit'), findsOneWidget);
    expect(find.text('Logged in as: admin'), findsOneWidget);
    expect(find.text('554826'), findsOneWidget);
    expect(find.text('BSIT - 3447'), findsOneWidget);

    // 12. Tap Logout -> Login appears; Back does not reopen MainScreen.
    await tester.tap(find.widgetWithText(ElevatedButton, 'Logout'));
    await tester.pumpAndSettle();

    expect(find.text('Welcome Back!'), findsOneWidget);
    final navigatorState = tester.state<NavigatorState>(find.byType(Navigator));
    expect(navigatorState.canPop(), isFalse);

    // 13. Register a valid account and log in -> Dashboard displays registered username.
    await tester.tap(find.text("Don't have an account? Register"));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Username'),
      'student1',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Password'),
      'secret123',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Confirm Password'),
      'secret123',
    );
    await tester.tap(find.widgetWithText(ElevatedButton, 'Register'));
    await tester.pumpAndSettle();

    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Username'),
      'student1',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Password'),
      'secret123',
    );
    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pumpAndSettle();

    expect(find.text('Welcome, student1!'), findsOneWidget);

    // 14. Create a post using the registered account -> Post displays registered username.
    await tester.tap(find.widgetWithText(NavigationDestination, 'Social'));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    final newSheetFields = find.descendant(
      of: find.byType(CreatePostSheet),
      matching: find.byType(TextField),
    );
    await tester.enterText(newSheetFields.at(0), 'Student post');
    await tester.enterText(
      newSheetFields.at(1),
      'https://picsum.photos/id/24/600/400',
    );
    await tester.tap(find.widgetWithText(ElevatedButton, 'Submit Post'));
    await tester.pumpAndSettle();

    expect(find.text('Student post'), findsOneWidget);
    expect(find.text('student1'), findsOneWidget);
  });
}
