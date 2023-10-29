part of 'todo_list_cubit.dart';

class TodoListState extends Equatable {
  final List<Todo> todos;
  const TodoListState({
    required this.todos,
  });

  factory TodoListState.initial(){
    return TodoListState(todos: [
      Todo(id: "1", desc: "helllo man"),
      Todo(id: "2", desc: "helllo women"),
      Todo(id: "3", desc: "helllo people"),
    ]);
  }


  @override
  List<Object?> get props => [todos];

  @override
  String toString() => 'TodoListState(todos: $todos)';

  TodoListState copyWith({
    List<Todo>? todos,
  }) {
    return TodoListState(
      todos: todos ?? this.todos,
    );
  }
}
