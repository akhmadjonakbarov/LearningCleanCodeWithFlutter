import 'package:dio/dio.dart';

import '../models/todo.dart';

class TodoService {
  final Dio dio;
  TodoService(this.dio);

  Future<List<Todo>> fetchTodos() async {
    List<Todo> todos = [];
    final response = await dio.get('https://dummyjson.com/todos');
    print(response.data);
    final _todos = response.data['todos'];
    for (var todoMap in _todos) {
      todos.add(Todo.fromMap(todoMap));
    }

    return todos;
  }
}
