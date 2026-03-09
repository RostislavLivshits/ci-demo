import 'package:ci_demo/features/tasks/domain/task.dart';

abstract class TaskRepository {
  Future<List<Task>> getTasks();
  Future<void> addTask(Task task);
}
