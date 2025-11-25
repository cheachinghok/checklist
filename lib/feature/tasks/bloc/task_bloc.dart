import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:checklist_app/core/models/task_model.dart';
import 'package:checklist_app/core/services/task_repository.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final TaskRepository taskRepository;

  TaskBloc({required this.taskRepository}) : super(TaskInitial()) {
    on<LoadTasks>(_onLoadTasks);
    on<AddTask>(_onAddTask);
    on<UpdateTask>(_onUpdateTask);
    on<DeleteTask>(_onDeleteTask);
    on<ToggleTaskCompletion>(_onToggleTaskCompletion);
    on<ReorderTasks>(_onReorderTasks);
    on<FilterTasks>(_onFilterTasks);
    on<SortTasks>(_onSortTasks);
  }

  Future<void> _onLoadTasks(LoadTasks event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    try {
      final tasks = await taskRepository.getTasks();
      emit(TaskLoaded(tasks: tasks));
    } catch (e) {
      emit(TaskError(message: 'Failed to load tasks: $e'));
    }
  }

  Future<void> _onAddTask(AddTask event, Emitter<TaskState> emit) async {
    if (state is TaskLoaded) {
      final currentState = state as TaskLoaded;
      try {
        await taskRepository.addTask(event.task);
        final tasks = await taskRepository.getTasks();
        emit(currentState.copyWith(tasks: tasks));
      } catch (e) {
        emit(TaskError(message: 'Failed to add task: $e'));
      }
    }
  }

  Future<void> _onUpdateTask(UpdateTask event, Emitter<TaskState> emit) async {
    if (state is TaskLoaded) {
      final currentState = state as TaskLoaded;
      try {
        await taskRepository.updateTask(event.task);
        final tasks = await taskRepository.getTasks();
        emit(currentState.copyWith(tasks: tasks));
      } catch (e) {
        emit(TaskError(message: 'Failed to update task: $e'));
      }
    }
  }

  Future<void> _onDeleteTask(DeleteTask event, Emitter<TaskState> emit) async {
    if (state is TaskLoaded) {
      final currentState = state as TaskLoaded;
      try {
        await taskRepository.deleteTask(event.taskId);
        final tasks = await taskRepository.getTasks();
        emit(currentState.copyWith(tasks: tasks));
      } catch (e) {
        emit(TaskError(message: 'Failed to delete task: $e'));
      }
    }
  }

  Future<void> _onToggleTaskCompletion(
    ToggleTaskCompletion event,
    Emitter<TaskState> emit,
  ) async {
    if (state is TaskLoaded) {
      final currentState = state as TaskLoaded;
      try {
        await taskRepository.toggleTaskCompletion(event.taskId);
        final tasks = await taskRepository.getTasks();
        emit(currentState.copyWith(tasks: tasks));
      } catch (e) {
        emit(TaskError(message: 'Failed to toggle task: $e'));
      }
    }
  }

  Future<void> _onReorderTasks(ReorderTasks event, Emitter<TaskState> emit) async {
    if (state is TaskLoaded) {
      final currentState = state as TaskLoaded;
      try {
        await taskRepository.reorderTasks(event.oldIndex, event.newIndex);
        final tasks = await taskRepository.getTasks();
        emit(currentState.copyWith(tasks: tasks));
      } catch (e) {
        emit(TaskError(message: 'Failed to reorder tasks: $e'));
      }
    }
  }

  void _onFilterTasks(FilterTasks event, Emitter<TaskState> emit) {
    if (state is TaskLoaded) {
      final currentState = state as TaskLoaded;
      final filteredTasks = _applyFilters(currentState.tasks, event.filter);
      emit(currentState.copyWith(
        tasks: currentState.tasks,
        filteredTasks: filteredTasks,
        currentFilter: event.filter,
      ));
    }
  }

  void _onSortTasks(SortTasks event, Emitter<TaskState> emit) {
    
    if (state is TaskLoaded) {
      final currentState = state as TaskLoaded;
      final sortedTasks = _applySort(currentState.tasks, event.sortBy);
      log(sortedTasks.toString());
      emit(currentState.copyWith(
        tasks: sortedTasks,
        filteredTasks: sortedTasks,
        currentSort: event.sortBy,
      ));
    }
  }

  List<Task> _applyFilters(List<Task> tasks, TaskFilter filter) {
    switch (filter) {
      case TaskFilter.all:
        return tasks;
      case TaskFilter.completed:
        return tasks.where((task) => task.isCompleted).toList();
      case TaskFilter.pending:
        return tasks.where((task) => !task.isCompleted).toList();
      case TaskFilter.highPriority:
        return tasks.where((task) => task.priority.index >= TaskPriority.high.index).toList();
    }
  }

List<Task> _applySort(List<Task> tasks, TaskSort sortBy) {
  final sortedTasks = List<Task>.from(tasks);
  
  switch (sortBy) {
    case TaskSort.priority:
      // Sort by priority (urgent first, then high, medium, low)
      sortedTasks.sort((a, b) => b.priority.index.compareTo(a.priority.index));
      break;
    case TaskSort.dueDate:
      sortedTasks.sort((a, b) {
        if (a.dueDate == null && b.dueDate == null) return 0;
        if (a.dueDate == null) return 1; // Tasks without due date go to the end
        if (b.dueDate == null) return -1; // Tasks with due date come first
        return a.dueDate!.compareTo(b.dueDate!); // Earliest first
      });
      break;
    case TaskSort.createdDate:
      // Most recent first
      sortedTasks.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      break;
    case TaskSort.alphabetical:
      sortedTasks.sort((a, b) => a.title.compareTo(b.title));
      break;
  }
  
  return sortedTasks;
}
}