import 'package:flutter/material.dart';
import 'package:learning_clean_code/features/home/models/todo.dart';
import 'package:learning_clean_code/features/home/view/widgets/todo_item.dart';

class TodoList extends StatelessWidget {
  const TodoList({super.key, required List<Todo> todos}) : _todos = todos;

  final List<Todo> _todos;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _todos.length,
        itemBuilder: (context, index) {
          final todo = _todos[index];
          return TodoItem(todo: todo);
        },
      ),
    );
  }
}
