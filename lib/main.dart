import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:checklist_app/app/app.dart';
import 'package:checklist_app/core/services/task_repository.dart';

import 'feature/tasks/bloc/task_bloc.dart';

void main() {
  runApp(const ChecklistApp());
}

class ChecklistApp extends StatelessWidget {
  const ChecklistApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
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
        child: MaterialApp(
          title: 'Checklist App',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: const App(),
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}