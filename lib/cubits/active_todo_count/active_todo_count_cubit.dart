import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:todocubit/cubits/todo_list/todo_list_cubit.dart';
import 'package:todocubit/models/todo_model.dart';

part 'active_todo_count_state.dart';

class ActiveTodoCountCubit extends Cubit<ActiveTodoCountState> {
  late final StreamSubscription todoListSubscription;
  final TodoListCubit todoListCubit;
  ActiveTodoCountCubit({required this.todoListCubit})
      : super(ActiveTodoCountState.initial()) {
    todoListSubscription =
        todoListCubit.stream.listen((TodoListState todoListState) {
      final int currentActiveTodo = todoListState.todos
          .where((Todo todo) => !todo.completed!)
          .toList()
          .length;
      emit(state.copyWith(activeTodoCount: currentActiveTodo));
    });
  }

  @override
  Future<void> close() {
    todoListSubscription.cancel();
    return super.close();
  }
}
