import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:checklist_app/core/models/task_model.dart';

import '../tasks/bloc/task_bloc.dart';
import 'task_item.dart';

class TaskList extends StatelessWidget {
  final List<Task> tasks;

  const TaskList({super.key, required this.tasks});

  @override
  Widget build(BuildContext context) {
    return ReorderableListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: tasks.length,
      onReorder: (oldIndex, newIndex) {
        context.read<TaskBloc>().add(ReorderTasks(oldIndex, newIndex));
      },
      itemBuilder: (context, index) {
        final task = tasks[index];
        return TaskItem(
          key: Key(task.id),
          task: task,
          onToggle: () {
            context.read<TaskBloc>().add(ToggleTaskCompletion(task.id));
          },
          // onEdit: () => _showEditTaskDialog(context, task),
          onDelete: () {
            context.read<TaskBloc>().add(DeleteTask(task.id));
          },
        );
      },
    );
  }
}