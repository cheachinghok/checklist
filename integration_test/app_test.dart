import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:checklist_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('End-to-End Test', () {
    testWidgets('Complete user flow: create, complete, and delete task', (WidgetTester tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // Navigate to tasks screen
      await tester.tap(find.byIcon(Icons.checklist));
      await tester.pumpAndSettle();

      // Tap add button to create new task
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      // Fill in task details
      await tester.enterText(find.byType(TextField).first, 'Integration Test Task');
      await tester.tap(find.text('High'));
      await tester.pump();

      // Create the task
      await tester.tap(find.text('Create Task'));
      await tester.pumpAndSettle();

      // Verify task was created
      expect(find.text('Integration Test Task'), findsOneWidget);

      // Mark task as completed
      await tester.tap(find.byType(Checkbox).first);
      await tester.pumpAndSettle();

      // Navigate to dashboard to see statistics
      await tester.tap(find.byIcon(Icons.dashboard));
      await tester.pumpAndSettle();

      // Verify dashboard shows the task in statistics
      expect(find.text('Task Statistics'), findsOneWidget);

      // Navigate back to tasks and delete the task
      await tester.tap(find.byIcon(Icons.checklist));
      await tester.pumpAndSettle();

      // Open task options menu
      await tester.tap(find.byIcon(Icons.more_vert).first);
      await tester.pumpAndSettle();

      // Tap delete option (you might need to adjust this based on your actual UI)
      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();

      // Verify task was deleted
      expect(find.text('Integration Test Task'), findsNothing);
    });
  });
}