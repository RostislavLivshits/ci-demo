import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/task_repository.dart';
import 'tasks_event.dart';
import 'tasks_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  // Dependency Injection: репозиторий передается снаружи
  final TaskRepository taskRepository;

  TaskBloc({required this.taskRepository}) : super(TaskInitial()) {
    on<LoadTask>(_onLoadTask);
    // Обработчик AddTask добавим позже, чтобы двигаться мелкими шагами
    // on<AddTask>(_onAddTask);
  }
  Future<void> _onLoadTask(LoadTask event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    try {
      final tasks = await taskRepository.getTasks();
      emit(TaskLoaded(tasks));
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }
}
