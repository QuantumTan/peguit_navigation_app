import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:peguit_navigation_app/main.dart';
import 'package:peguit_navigation_app/services/demo_auth.dart';
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

  testWidgets('Full flow: Login, Navigation, Like, Comment, Post creation, Logout, Register', (tester) async {
    // Provide a large enough screen to avoid scrolling issues in tests
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(const StudentApp());
    await tester.pumpAndSettle();

    // 1. Verify Login screen
    expect(find.text('Login'), findsWidgets);
    expect(find.text('Welcome Back!'), findsOneWidget);

    // Enter admin credentials
    await tester.enterText(find.widgetWithText(TextFormField, 'Username'), 'admin');
    await tester.enterText(find.widgetWithText(TextFormField, 'Password'), 'admin123');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pumpAndSettle();

    // Verify MainScreen loaded
    expect(find.text('Welcome, Student!'), findsOneWidget);

    // 2. Open Social Media tab
    await tester.tap(find.byIcon(Icons.share_outlined));
    await tester.pumpAndSettle();

    // Sample posts appear
    expect(find.descendant(of: find.byType(AppBar), matching: find.text('Social Media')), findsOneWidget);
    expect(find.text('JohnDoe'), findsOneWidget);
    expect(find.text('JaneSmith'), findsOneWidget);

    // 6. Tap Like twice on the first post
    final likeButton = find.widgetWithText(TextButton, 'Like').first;
    await tester.tap(likeButton);
    await tester.pumpAndSettle();
    expect(find.text('Liked'), findsOneWidget);

    await tester.tap(find.widgetWithText(TextButton, 'Liked').first);
    await tester.pumpAndSettle();
    expect(find.text('Liked'), findsNothing);

    // Tap Like again to keep it liked
    await tester.tap(likeButton);
    await tester.pumpAndSettle();
    expect(find.text('Liked'), findsOneWidget);

    // 7. Add comment
    final commentField = find.widgetWithText(TextField, 'Add a comment...').first;
    await tester.enterText(commentField, 'Nice post!');
    final sendButton = find.byTooltip('Send comment').first;
    await tester.tap(sendButton);
    await tester.pumpAndSettle();

    expect(find.text('Nice post!'), findsOneWidget);
    expect(find.text('1 Comments'), findsOneWidget);

    // 8. Submit a blank comment
    await tester.enterText(commentField, '   ');
    await tester.tap(sendButton);
    await tester.pumpAndSettle();
    expect(find.text('1 Comments'), findsOneWidget);

    // 3 & 4 & 5. Tap FAB to open CreatePostSheet
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
    expect(find.text('Create Post'), findsOneWidget);

    // 3. Empty fields submit
    await tester.tap(find.widgetWithText(ElevatedButton, 'Submit Post'));
    await tester.pumpAndSettle();
    expect(find.text('Complete both fields before submitting!'), findsOneWidget);

    // Wait for the SnackBar to dismiss
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();

    // 4. Invalid URL submit
    final sheetTextFields = find.descendant(
      of: find.byType(CreatePostSheet),
      matching: find.byType(TextField),
    );
    await tester.enterText(sheetTextFields.at(0), 'My test post');
    await tester.enterText(sheetTextFields.at(1), 'invalid-url');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Submit Post'));
    await tester.pumpAndSettle();
    expect(find.text('Enter a valid HTTP or HTTPS image URL.'), findsOneWidget);

    // Wait for the SnackBar to dismiss
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();

    // 5. Valid post submit
    await tester.enterText(sheetTextFields.at(1), 'https://picsum.photos/id/20/600/400');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Submit Post'));
    await tester.pumpAndSettle();

    // Verify new post appears at the top with admin username
    expect(find.text('My test post'), findsOneWidget);
    expect(find.text('admin'), findsOneWidget);

    // 10. Switch to Home and return, ensure posts, likes, comments remain
    await tester.tap(find.widgetWithText(NavigationDestination, 'Home'));
    await tester.pumpAndSettle();
    expect(find.text('Welcome, Student!'), findsOneWidget);

    await tester.tap(find.widgetWithText(NavigationDestination, 'Social Media'));
    await tester.pumpAndSettle();
    expect(find.text('My test post'), findsOneWidget);
    expect(find.text('Nice post!'), findsOneWidget);
    expect(find.text('Liked'), findsOneWidget);

    // 11. Profile & Logout
    await tester.tap(find.widgetWithText(NavigationDestination, 'Profile'));
    await tester.pumpAndSettle();
    expect(find.text('Jonathan Jr. H. Peguit'), findsOneWidget);

    // Tap Logout
    await tester.tap(find.widgetWithText(ElevatedButton, 'Logout'));
    await tester.pumpAndSettle();

    // Verify back to Login screen
    expect(find.text('Welcome Back!'), findsOneWidget);

    // Register a new user
    await tester.tap(find.text("Don't have an account? Register"));
    await tester.pumpAndSettle();

    await tester.enterText(find.widgetWithText(TextFormField, 'Username'), 'student1');
    await tester.enterText(find.widgetWithText(TextFormField, 'Password'), 'secret123');
    await tester.enterText(find.widgetWithText(TextFormField, 'Confirm Password'), 'secret123');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Register'));
    await tester.pumpAndSettle();

    // Wait for the snackbar to dismiss
    await tester.pump(const Duration(seconds: 4));
    await tester.pumpAndSettle();

    // Now log in as student1
    await tester.enterText(find.widgetWithText(TextFormField, 'Username'), 'student1');
    await tester.enterText(find.widgetWithText(TextFormField, 'Password'), 'secret123');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pumpAndSettle();

    // Navigate to Social Media
    await tester.tap(find.widgetWithText(NavigationDestination, 'Social Media'));
    await tester.pumpAndSettle();

    // Create a new post as student1
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    final newSheetFields = find.descendant(
      of: find.byType(CreatePostSheet),
      matching: find.byType(TextField),
    );
    await tester.enterText(newSheetFields.at(0), 'Student post');
    await tester.enterText(newSheetFields.at(1), 'https://picsum.photos/id/24/600/400');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Submit Post'));
    await tester.pumpAndSettle();

    // Confirm that the new post has student1 as username
    expect(find.text('Student post'), findsOneWidget);
    expect(find.text('student1'), findsOneWidget);
  });
}
