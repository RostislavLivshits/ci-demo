import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/task_repository.dart';
import 'tasks_event.dart';
import 'tasks_state.dart';

class TasksBloc extends Bloc<TasksEvent, TasksState> {
  // Dependency Injection: репозиторий передается снаружи
  final TaskRepository taskRepository;

  TasksBloc({required this.taskRepository}) : super(TasksInitial()) {
    on<LoadTasks>(_onLoadTask);
    // Обработчик AddTask добавим позже, чтобы двигаться мелкими шагами
    // on<AddTask>(_onAddTask);
  }
  Future<void> _onLoadTask(LoadTasks event, Emitter<TasksState> emit) async {
   // emit(TasksLoading());
    try {
      final tasks = await taskRepository.getTasks();
      emit(TasksLoaded(tasks));
    } catch (e) {
      emit(TasksError(e.toString()));
    }
  }
}
