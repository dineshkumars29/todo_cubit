import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'package:todocubit/cubits/todo_filter/todo_filter_cubit.dart';
import 'package:todocubit/cubits/todo_list/todo_list_cubit.dart';
import 'package:todocubit/cubits/todo_search/todo_search_cubit.dart';
import 'package:todocubit/models/todo_model.dart';

part 'filtered_todos_state.dart';

class FilteredTodosCubit extends Cubit<FilteredTodosState> {
  late StreamSubscription todoFilterSubscription;
  late StreamSubscription todoSearchSubscription;
  late StreamSubscription todoListSubscription;

  final TodoFilterCubit todoFilterCubit;
  final TodoSearchCubit todoSearchCubit;
  final TodoListCubit todoListCubit;

  FilteredTodosCubit({
    required this.todoFilterCubit,
    required this.todoSearchCubit,
    required this.todoListCubit,
  }) : super(FilteredTodosState.initial()) {
    todoFilterSubscription =
        todoFilterCubit.stream.listen((TodoFilterState todoFilterState) {
      setFilteredTodos();
    });
    todoSearchSubscription =
        todoSearchCubit.stream.listen((TodoSearchState todoSearchState) {
      setFilteredTodos();
    });
    todoListSubscription =
        todoListCubit.stream.listen((TodoListState todoListState) {
      setFilteredTodos();
    });
  }

  void setFilteredTodos() {
    List<Todo> tempFilteredTodos;
    switch (todoFilterCubit.state.filter) {
      case Filter.active:
        tempFilteredTodos = todoListCubit.state.todos
            .where((Todo todo) => !todo.completed!)
            .toList();
        break;
      case Filter.completed:
        tempFilteredTodos = todoListCubit.state.todos
            .where((Todo todo) => todo.completed!)
            .toList();
        break;
      case Filter.all:
        tempFilteredTodos = todoListCubit.state.todos;
        break;
    }
    if (todoSearchCubit.state.searchTerm.isNotEmpty) {
      tempFilteredTodos = todoListCubit.state.todos
          .where((Todo todo) => todo.desc!
              .toLowerCase()
              .contains(todoSearchCubit.state.searchTerm))
          .toList();
    }
    emit(state.copyWith(filteredTodos: tempFilteredTodos));
  }

  @override
  Future<void> close() {
    todoFilterSubscription.cancel();
    todoSearchSubscription.cancel();
    todoListSubscription.cancel();
    return super.close();
  }
}
