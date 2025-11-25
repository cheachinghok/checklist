part of 'task_bloc.dart';

abstract class TaskState extends Equatable {
  const TaskState();

  @override
  List<Object> get props => [];
}

class TaskInitial extends TaskState {}

class TaskLoading extends TaskState {}

class TaskLoaded extends TaskState {
  final List<Task> tasks;
  final List<Task> filteredTasks;
  final TaskFilter currentFilter;
  final TaskSort currentSort;

  const TaskLoaded({
    required this.tasks,
    this.filteredTasks = const [],
    this.currentFilter = TaskFilter.all,
    this.currentSort = TaskSort.priority,
  });

  TaskLoaded copyWith({
    List<Task>? tasks,
    List<Task>? filteredTasks,
    TaskFilter? currentFilter,
    TaskSort? currentSort,
  }) {
    return TaskLoaded(
      tasks: tasks ?? this.tasks,
      filteredTasks: filteredTasks ?? this.filteredTasks,
      currentFilter: currentFilter ?? this.currentFilter,
      currentSort: currentSort ?? this.currentSort,
    );
  }

  @override
  List<Object> get props => [tasks, filteredTasks, currentFilter, currentSort];
}

class TaskError extends TaskState {
  final String message;

  const TaskError({required this.message});

  @override
  List<Object> get props => [message];
}