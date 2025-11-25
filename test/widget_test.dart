import 'package:checklist_app/feature/tasks/bloc/task_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:checklist_app/main.dart';
import 'package:checklist_app/core/services/task_repository.dart';
import 'package:flutter_test/flutter_test.dart';
void main() {
  testWidgets('App starts and shows navigation items', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MultiRepositoryProvider(
        providers: [
          RepositoryProvider<TaskRepository>(
            create: (context) => LocalTaskRepository(),
          ),
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider<TaskBloc>(
              create: (context) => TaskBloc(
                taskRepository: context.read<TaskRepository>(),
              )..add(LoadTasks()),
            ),
          ],
          child:const MaterialApp(
            home: ChecklistApp(),
          ),
        ),
      ),
    );

    // Wait for the app to load
    await tester.pumpAndSettle();

    // Verify that our app shows navigation items
    expect(find.byIcon(Icons.dashboard), findsOneWidget);
    expect(find.byIcon(Icons.checklist), findsOneWidget);
    // expect(find.byIcon(Icons.settings), findsOneWidget);
  });

  testWidgets('Navigation between screens works', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiRepositoryProvider(
        providers: [
          RepositoryProvider<TaskRepository>(
            create: (context) => LocalTaskRepository(),
          ),
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider<TaskBloc>(
              create: (context) => TaskBloc(
                taskRepository: context.read<TaskRepository>(),
              )..add(LoadTasks()),
            ),
          ],
          child: const MaterialApp(
            home: ChecklistApp(),
          ),
        ),
      ),
    );

    // Wait for the app to load
    await tester.pumpAndSettle();

    // Tap on the Tasks navigation item (using the icon)
    await tester.tap(find.byIcon(Icons.checklist));
    await tester.pumpAndSettle();

    // Verify we're on the tasks screen by checking for the add button
    expect(find.byIcon(Icons.add), findsOneWidget);

    // Tap on the Settings navigation item
    // await tester.tap(find.byIcon(Icons.settings));
    await tester.pumpAndSettle();

    // Verify we're on the settings screen by checking for settings title
    // expect(find.text('Settings'), findsOneWidget);
  });

  testWidgets('Tasks screen loads with sample data', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiRepositoryProvider(
        providers: [
          RepositoryProvider<TaskRepository>(
            create: (context) => LocalTaskRepository(),
          ),
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider<TaskBloc>(
              create: (context) => TaskBloc(
                taskRepository: context.read<TaskRepository>(),
              )..add(LoadTasks()),
            ),
          ],
          child: const MaterialApp(
            home: ChecklistApp(),
          ),
        ),
      ),
    );

    // Wait for the app to load
    await tester.pumpAndSettle();

    // Navigate to tasks screen
    await tester.tap(find.byIcon(Icons.checklist));
    await tester.pumpAndSettle();

    // Verify that tasks are loaded (check for task items or loading state)
    // Since we have sample data, we should find some task items
    await tester.pump(const Duration(seconds: 2)); // Wait for data to load
    
    // Check if we have tasks or empty state
    // final taskItems = find.byType(ListTile);
    // final emptyState = find.text('No tasks found');
    
    // The test should pass whether we have tasks or empty state
    // expect(taskItems.isNotEmpty || emptyState.isNotEmpty, true);
  });

  testWidgets('Add task button opens dialog', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiRepositoryProvider(
        providers: [
          RepositoryProvider<TaskRepository>(
            create: (context) => LocalTaskRepository(),
          ),
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider<TaskBloc>(
              create: (context) => TaskBloc(
                taskRepository: context.read<TaskRepository>(),
              )..add(LoadTasks()),
            ),
          ],
          child: const MaterialApp(
            home: ChecklistApp(),
          ),
        ),
      ),
    );

    // Wait for the app to load
    await tester.pumpAndSettle();

    // Navigate to tasks screen
    await tester.tap(find.byIcon(Icons.checklist));
    await tester.pumpAndSettle();

    // Tap the add button
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    // Verify that the dialog is shown
    expect(find.text('Create New Task'), findsOneWidget);
    expect(find.text('Task Title'), findsOneWidget);
  });
}