import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/tasks_bloc.dart';
import '../bloc/tasks_state.dart';

class TaskPage extends StatelessWidget {
  const TaskPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tasks')),
      body: BlocBuilder<TasksBloc, TasksState>(
        builder: (context, state) {
          if (state is TasksInitial || state is TasksLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TasksLoaded) {
            if (state.tasks.isEmpty) {
              return const Center(child: Text('No tasks yet'));
            }
            return ListView.builder(
              itemCount: state.tasks.length,
              itemBuilder: (context, index) {
                final task = state.tasks[index];
                return ListTile(
                  title: Text(task.title),
                  trailing: Checkbox(
                    value: task.isCompleted,
                    onChanged: (_) {}, // Добавим логику позже
                  ),
                );
              },
            );
          } else if (state is TasksError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
