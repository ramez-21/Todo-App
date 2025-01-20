// ignore_for_file: unnecessary_this

part of 'todo_bloc.dart';

enum TodoStatus { initial, loading, success, error }

class TodoState extends Equatable {
  final List<Todo> todos;
  final TodoStatus status;

  const TodoState({
    this.todos = const <Todo>[],
    this.status = TodoStatus.initial,
  });

  TodoState copyWith({
    TodoStatus? status,
    List<Todo>? todos,
  }) {
    return TodoState(
      todos: todos ?? this.todos,
      status: status ?? this.status,
    );
  }

  @override
  factory TodoState.fromJson(Map<String, dynamic> json) {
    try {
      var listOfTodo = (json["todo"] as List<dynamic>)
          .map((e) => Todo.fromJson(e as Map<String, dynamic>))
          .toList();

      return TodoState(
          todos: listOfTodo,
          status: TodoStatus.values.firstWhere(
            (element) => element.name.toString() == json["status"],
          ));
    } catch (e) {
      rethrow;
    }
  }
  Map<String, dynamic> toJson() {
    return {
      "todo": todos,
      "status": status.name,
    };
  }

  @override
  List<Object?> get props => [todos, status];
}
