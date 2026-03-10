// Создаем MockBloc, который позволяет легко подменять states
import 'package:bloc_test/bloc_test.dart';
import 'package:ci_demo/features/tasks/domain/task.dart';
import 'package:ci_demo/features/tasks/presentation/bloc/tasks_bloc.dart';
import 'package:ci_demo/features/tasks/presentation/bloc/tasks_event.dart';
import 'package:ci_demo/features/tasks/presentation/bloc/tasks_state.dart';
import 'package:ci_demo/features/tasks/presentation/pages/task_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTasksBloc extends MockBloc<TasksEvent, TasksState>
    implements TasksBloc {}

void main() {
  late MockTasksBloc mockTasksBloc;
  setUp(() {
    mockTasksBloc = MockTasksBloc();
  });

  // Вспомогательная функция для сборки виджета с замоканным BLoC
  Widget makeTestableWidget(Widget body) {
    return BlocProvider<TasksBloc>.value(
      value: mockTasksBloc,
      child: MaterialApp(home: body),
    );
  }

  testWidgets('должен показывать CircularProgressIndicator при TasksLoading', (
    WidgetTester tester,
  ) async {
    // Устанавливаем нужное состояние в Mock BLoC
    when(() => mockTasksBloc.state).thenReturn(TasksLoading());
    await tester.pumpWidget(makeTestableWidget(const TaskPage()));
    // Проверяем, что индикатор загрузки появился на экране
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('должен показывать список задач при TasksLoaded', (
    WidgetTester tester,
  ) async {
    final tasks = [
      Task(id: '1', title: 'Test Task 1', isCompleted: false),
      Task(id: '2', title: 'Test Task 2', isCompleted: true),
    ];
    when(() => mockTasksBloc.state).thenReturn(TasksLoaded(tasks));
    await tester.pumpWidget(makeTestableWidget(const TaskPage()));
    expect(find.text('Test Task 1'), findsOneWidget);
    expect(find.text('Test Task 2'), findsOneWidget);
    expect(find.byType(ListTile), findsNWidgets(2));
  });

  testWidgets('должен показывать сообщение об ошибке при TasksError', (
      WidgetTester tester,
  ) async {
    when(() => mockTasksBloc.state).thenReturn(const TasksError('Network error'));
    await tester.pumpWidget(makeTestableWidget(const TaskPage()));
    expect(find.text('Error: Network error'), findsOneWidget);
  });
}
