import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Замени `ci_demo` на реальное имя твоего проекта, если оно отличается
import 'package:ci_demo/features/tasks/domain/task.dart';
import 'package:ci_demo/features/tasks/domain/repositories/task_repository.dart';
import 'package:ci_demo/features/tasks/presentation/bloc/tasks_bloc.dart';
import 'package:ci_demo/features/tasks/presentation/bloc/tasks_event.dart';
import 'package:ci_demo/features/tasks/presentation/bloc/tasks_state.dart';

// 1. Создаем Mock класс на основе нашего абстрактного репозитория
class MockTaskRepository extends Mock implements TaskRepository {}

void main() {
  late MockTaskRepository mockTaskRepository;
  late TasksBloc tasksBloc;

  // Подготавливаем тестовые данные (fake data)
  final tTask = Task(id: '1', title: 'Test Task', isCompleted: false);
  final tTasksList = [tTask];

  // setUp выполняется перед КАЖДЫМ тестом, обеспечивая чистый state
  setUp(() {
    mockTaskRepository = MockTaskRepository();
    tasksBloc = TasksBloc(taskRepository: mockTaskRepository);
  });

  // tearDown очищает ресурсы после теста
  tearDown(() {
    tasksBloc.close();
  });

  test('initial state should be TasksInitial', () {
    expect(tasksBloc.state, equals(TasksInitial()));
  });

  // Тестируем успешный сценарий (async действия и loading states)
  blocTest<TasksBloc, TasksState>(
    'emits [TasksLoading, TasksLoaded] when LoadTasks is added and succeeds',
    build: () {
      // Настраиваем mock: когда вызовут getTasks, верни tTasksList
      when(() => mockTaskRepository.getTasks())
          .thenAnswer((_) async => tTasksList);
      return tasksBloc;
    },
    act: (bloc) => bloc.add(LoadTasks()),
    expect: () => [
      TasksLoading(),
      TasksLoaded(tTasksList),
    ],
  );

  // Тестируем сценарий ошибки (error states)
  blocTest<TasksBloc, TasksState>(
    'emits [TasksLoading, TasksError] when LoadTasks fails',
    build: () {
      // Настраиваем mock: когда вызовут getTasks, выбрось исключение
      when(() => mockTaskRepository.getTasks())
          .thenThrow(Exception('Failed to load'));
      return tasksBloc;
    },
    act: (bloc) => bloc.add(LoadTasks()),
    expect: () => [
      TasksLoading(),
      const TasksError('Exception: Failed to load'),
    ],
  );
}