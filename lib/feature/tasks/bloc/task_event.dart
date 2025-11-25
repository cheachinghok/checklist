part of 'task_bloc.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object> get props => [];
}

class LoadTasks extends TaskEvent {}

class AddTask extends TaskEvent {
  final Task task;

  const AddTask(this.task);

  @override
  List<Object> get props => [task];
}

class UpdateTask extends TaskEvent {
  final Task task;

  const UpdateTask(this.task);

  @override
  List<Object> get props => [task];
}

class DeleteTask extends TaskEvent {
  final String taskId;

  const DeleteTask(this.taskId);

  @override
  List<Object> get props => [taskId];
}

class ToggleTaskCompletion extends TaskEvent {
  final String taskId;

  const ToggleTaskCompletion(this.taskId);

  @override
  List<Object> get props => [taskId];
}

class ReorderTasks extends TaskEvent {
  final int oldIndex;
  final int newIndex;

  const ReorderTasks(this.oldIndex, this.newIndex);

  @override
  List<Object> get props => [oldIndex, newIndex];
}

class FilterTasks extends TaskEvent {
  final TaskFilter filter;

  const FilterTasks(this.filter);

  @override
  List<Object> get props => [filter];
}

class SortTasks extends TaskEvent {
  final TaskSort sortBy;

  const SortTasks(this.sortBy);

  @override
  List<Object> get props => [sortBy];
}

enum TaskFilter { all, completed, pending, highPriority }
enum TaskSort { priority, dueDate, createdDate, alphabetical }