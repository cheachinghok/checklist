import 'package:checklist_app/core/models/task_model.dart';

abstract class TaskRepository {
  Future<List<Task>> getTasks();
  Future<void> addTask(Task task);
  Future<void> updateTask(Task task);
  Future<void> deleteTask(String taskId);
  Future<void> toggleTaskCompletion(String taskId);
  Future<void> reorderTasks(int oldIndex, int newIndex);
}

class LocalTaskRepository implements TaskRepository {
  List<Task> _tasks = [];

  LocalTaskRepository() {
    _initializeTestData();
  }

  void _initializeTestData() {
    _tasks = [
      Task(
        title: 'Complete Flutter project',
        description: 'Finish the checklist app with all features',
        priority: TaskPriority.high,
        dueDate: DateTime.now().add(const Duration(days: 2)),
        tags: ['work', 'flutter', 'important'],
      ),
      Task(
        title: 'Buy groceries',
        description: 'Milk, Eggs, Bread, Fruits',
        priority: TaskPriority.medium,
        dueDate: DateTime.now().add(const Duration(days: 1)),
        tags: ['personal', 'shopping'],
      ),
      Task(
        title: 'Morning exercise',
        description: '30 minutes of cardio and strength training',
        priority: TaskPriority.medium,
        tags: ['health', 'routine'],
      ),
      Task(
        title: 'Read documentation',
        description: 'Read about BLoC pattern and state management',
        priority: TaskPriority.low,
        tags: ['learning', 'flutter'],
      ),
      Task(
        title: 'Team meeting',
        description: 'Weekly team sync-up meeting',
        priority: TaskPriority.high,
        dueDate: DateTime.now().add(const Duration(hours: 5)),
        tags: ['work', 'meeting'],
        isCompleted: true,
        completedAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      Task(
        title: 'Update portfolio',
        description: 'Add new projects and update resume',
        priority: TaskPriority.medium,
        dueDate: DateTime.now().add(const Duration(days: 7)),
        tags: ['career', 'important'],
      ),
      Task(
        title: 'Plan weekend trip',
        description: 'Research destinations and book accommodations',
        priority: TaskPriority.low,
        tags: ['personal', 'travel'],
      ),
      Task(
        title: 'Fix bug in login screen',
        description: 'Resolve the issue with keyboard overlapping',
        priority: TaskPriority.high,
        dueDate: DateTime.now().add(const Duration(days: 1)),
        tags: ['work', 'bug', 'flutter'],
        isCompleted: true,
        completedAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ];
  }

  @override
  Future<List<Task>> getTasks() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List<Task>.from(_tasks);
  }

  @override
  Future<void> addTask(Task task) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _tasks.add(task);
  }

  @override
  Future<void> updateTask(Task task) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _tasks[index] = task;
    }
  }

  @override
  Future<void> deleteTask(String taskId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _tasks.removeWhere((task) => task.id == taskId);
  }

  @override
  Future<void> toggleTaskCompletion(String taskId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final index = _tasks.indexWhere((task) => task.id == taskId);
    if (index != -1) {
      final task = _tasks[index];
      _tasks[index] = task.copyWith(
        isCompleted: !task.isCompleted,
        completedAt: !task.isCompleted ? DateTime.now() : null,
      );
    }
  }

  @override
  Future<void> reorderTasks(int oldIndex, int newIndex) async {
    await Future.delayed(const Duration(milliseconds: 200));
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final task = _tasks.removeAt(oldIndex);
    _tasks.insert(newIndex, task);
  }
}