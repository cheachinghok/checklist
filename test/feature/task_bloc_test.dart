import 'package:bloc_test/bloc_test.dart';
import 'package:checklist_app/feature/tasks/bloc/task_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:checklist_app/core/models/task_model.dart';
import 'package:checklist_app/core/services/task_repository.dart';

class MockTaskRepository extends Mock implements TaskRepository {}

void main() {
  late MockTaskRepository mockTaskRepository;
  late TaskBloc taskBloc;

  setUp(() {
    mockTaskRepository = MockTaskRepository();
    taskBloc = TaskBloc(taskRepository: mockTaskRepository);
  });

  tearDown(() {
    taskBloc.close();
  });

  final testTask = Task(
    id: '1',
    title: 'Test Task',
    description: 'Test Description',
    priority: TaskPriority.medium,
  );

  final testTasks = [
    testTask,
    testTask.copyWith(id: '2', title: 'Task 2', isCompleted: true),
    testTask.copyWith(id: '3', title: 'Task 3', priority: TaskPriority.high),
  ];

  group('TaskBloc Unit Tests', () {
    test('initial state is TaskInitial', () {
      expect(taskBloc.state, isA<TaskInitial>());
    });

    blocTest<TaskBloc, TaskState>(
      'emits [TaskLoading, TaskLoaded] when LoadTasks is successful',
      build: () {
        when(() => mockTaskRepository.getTasks()).thenAnswer((_) async => testTasks);
        return taskBloc;
      },
      act: (bloc) => bloc.add(LoadTasks()),
      expect: () => [
        TaskLoading(),
        TaskLoaded(tasks: testTasks),
      ],
      verify: (_) {
        verify(() => mockTaskRepository.getTasks()).called(1);
      },
    );

    blocTest<TaskBloc, TaskState>(
      'emits [TaskLoading, TaskError] when LoadTasks fails',
      build: () {
        when(() => mockTaskRepository.getTasks())
            .thenThrow(Exception('Database error'));
        return taskBloc;
      },
      act: (bloc) => bloc.add(LoadTasks()),
      expect: () => [
        TaskLoading(),
        const TaskError(message: 'Failed to load tasks: Exception: Database error'),
      ],
    );

    blocTest<TaskBloc, TaskState>(
      'adds task successfully',
      build: () {
        when(() => mockTaskRepository.addTask(testTask)).thenAnswer((_) async {});
        when(() => mockTaskRepository.getTasks()).thenAnswer((_) async => [testTask]);
        return taskBloc;
      },
      seed: () => const TaskLoaded(tasks: []),
      act: (bloc) => bloc.add(AddTask(testTask)),
      expect: () => [
        TaskLoaded(tasks: [testTask]),
      ],
      verify: (_) {
        verify(() => mockTaskRepository.addTask(testTask)).called(1);
      },
    );

    blocTest<TaskBloc, TaskState>(
      'updates task successfully',
      build: () {
        when(() => mockTaskRepository.updateTask(testTask)).thenAnswer((_) async {});
        when(() => mockTaskRepository.getTasks()).thenAnswer((_) async => [testTask]);
        return taskBloc;
      },
      seed: () => TaskLoaded(tasks: [testTask.copyWith(title: 'Old Title')]),
      act: (bloc) => bloc.add(UpdateTask(testTask)),
      expect: () => [
        TaskLoaded(tasks: [testTask]),
      ],
    );

    blocTest<TaskBloc, TaskState>(
      'deletes task successfully',
      build: () {
        when(() => mockTaskRepository.deleteTask('1')).thenAnswer((_) async {});
        when(() => mockTaskRepository.getTasks()).thenAnswer((_) async => []);
        return taskBloc;
      },
      seed: () => TaskLoaded(tasks: [testTask]),
      act: (bloc) => bloc.add(const DeleteTask('1')),
      expect: () => [
        const TaskLoaded(tasks: []),
      ],
    );

    blocTest<TaskBloc, TaskState>(
      'toggles task completion',
      build: () {
        when(() => mockTaskRepository.toggleTaskCompletion('1')).thenAnswer((_) async {});
        when(() => mockTaskRepository.getTasks())
            .thenAnswer((_) async => [testTask.copyWith(isCompleted: true)]);
        return taskBloc;
      },
      seed: () => TaskLoaded(tasks: [testTask]),
      act: (bloc) => bloc.add(const ToggleTaskCompletion('1')),
      expect: () => [
        TaskLoaded(tasks: [testTask.copyWith(isCompleted: true)]),
      ],
    );

    blocTest<TaskBloc, TaskState>(
      'reorders tasks successfully',
      build: () {
        when(() => mockTaskRepository.reorderTasks(0, 1)).thenAnswer((_) async {});
        when(() => mockTaskRepository.getTasks()).thenAnswer((_) async => [testTasks[1], testTasks[0]]);
        return taskBloc;
      },
      seed: () => TaskLoaded(tasks: testTasks),
      act: (bloc) => bloc.add(const ReorderTasks(0, 1)),
      expect: () => [
        TaskLoaded(tasks: [testTasks[1], testTasks[0]]),
      ],
    );

    blocTest<TaskBloc, TaskState>(
      'filters tasks by completed',
      build: () => taskBloc,
      seed: () => TaskLoaded(tasks: testTasks),
      act: (bloc) => bloc.add(const FilterTasks(TaskFilter.completed)),
      expect: () => [
        TaskLoaded(
          tasks: testTasks,
          filteredTasks: [testTasks[1]], // Only completed task
          currentFilter: TaskFilter.completed,
        ),
      ],
    );

    blocTest<TaskBloc, TaskState>(
      'filters tasks by pending',
      build: () => taskBloc,
      seed: () => TaskLoaded(tasks: testTasks),
      act: (bloc) => bloc.add(const FilterTasks(TaskFilter.pending)),
      expect: () => [
        TaskLoaded(
          tasks: testTasks,
          filteredTasks: [testTasks[0], testTasks[2]], // Only pending tasks
          currentFilter: TaskFilter.pending,
        ),
      ],
    );

    blocTest<TaskBloc, TaskState>(
      'filters tasks by high priority',
      build: () => taskBloc,
      seed: () => TaskLoaded(tasks: testTasks),
      act: (bloc) => bloc.add(const FilterTasks(TaskFilter.highPriority)),
      expect: () => [
        TaskLoaded(
          tasks: testTasks,
          filteredTasks: [testTasks[2]], // Only high priority tasks
          currentFilter: TaskFilter.highPriority,
        ),
      ],
    );

    blocTest<TaskBloc, TaskState>(
      'sorts tasks by priority',
      build: () => taskBloc,
      seed: () => TaskLoaded(tasks: testTasks),
      act: (bloc) => bloc.add(const SortTasks(TaskSort.priority)),
      expect: () => [
        predicate<TaskLoaded>((state) {
          // Check that tasks are sorted by priority (high first)
          final priorities = state.filteredTasks.map((t) => t.priority).toList();
          return priorities[0] == TaskPriority.high &&
                priorities[1] == TaskPriority.medium &&
                priorities[2] == TaskPriority.medium;
        }),
      ],
    );

    test('does not emit state when adding task in wrong state', () {
      when(() => mockTaskRepository.addTask(testTask)).thenAnswer((_) async {});

      // Start from initial state (not TaskLoaded)
      expect(taskBloc.state, isA<TaskInitial>());

      // Add task should not cause state change from initial state
      taskBloc.add(AddTask(testTask));

      // State should remain initial
      expect(taskBloc.state, isA<TaskInitial>());
    });
  });
}