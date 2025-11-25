import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/add_task_dialog.dart';
import '../widgets/task_list.dart';
import 'bloc/task_bloc.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Check List'),
        actions: [
          Transform.translate(
            offset:const Offset(-20, 0),
            child: Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 46, 232, 117),
                borderRadius: BorderRadius.circular(15)
              ),
              child: IconButton(
                icon: const Icon(Icons.add,color: Colors.white,),
                onPressed: () => _showAddTaskDialog(context,false),
                tooltip: 'Add New Task',
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // const TaskFilters(),
          Expanded(
            child: BlocBuilder<TaskBloc, TaskState>(
              builder: (context, state) {
                if (state is TaskLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is TaskError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, size: 64, color: Colors.grey),
                        const SizedBox(height: 16),
                        Text(
                          state.message,
                          style: const TextStyle(color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => context.read<TaskBloc>().add(LoadTasks()),
                          child: const Text('Try Again'),
                        ),
                      ],
                    ),
                  );
                } else if (state is TaskLoaded) {
                  if (state.tasks.isEmpty) {
                    return _buildEmptyState(context);
                  }
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: (){
                          context.read<TaskBloc>().add(const SortTasks(TaskSort.priority));
                        },
                        child: Container(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 52, 144, 206),
                          borderRadius: BorderRadius.circular(15)
                        ),
                        padding:const EdgeInsets.all(10),
                        margin: const EdgeInsets.only(left: 20),
                        child:const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.short_text,color: Colors.white,),
                            Text("Short by priority",style: TextStyle(color: Colors.white),),
                            SizedBox(width: 20,)
                          ],
                        ),
                                            ),
                      ),
                      Expanded(child: TaskList(tasks: state.tasks)),
                    ],
                  );
                }
                return _buildEmptyState(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.checklist_rounded,
            size: 80,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            'No tasks found',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade500,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add your first task to get started',
            style: TextStyle(
              color: Colors.grey.shade400,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => _showAddTaskDialog(context,false),
            child: const Text('Create Your First Task'),
          ),
        ],
      ),
    );
  }

  void _showAddTaskDialog(BuildContext context, bool editing) {
    showDialog(
      context: context,
      builder: (context) => AddTaskDialog(taskToEdit: null, edit: editing,),
    );
  }
}