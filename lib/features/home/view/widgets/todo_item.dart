import 'package:flutter/material.dart';
import 'package:learning_clean_code/design_system/styles/text_style.dart';
import 'package:learning_clean_code/features/home/models/todo.dart';

class TodoItem extends StatelessWidget {
  const TodoItem({super.key, required this.todo});

  final Todo todo;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        todo.title,
        style: SatoshiTextStyle.headline4.copyWith(
          decoration: todo.completed
              ? TextDecoration.lineThrough
              : TextDecoration.none,
          color: todo.completed ? Colors.grey : Colors.black,
        ),
      ),
      leading: Checkbox(value: todo.completed, onChanged: (val) {}),
      trailing: IconButton(
        onPressed: () {},
        icon: Icon(Icons.delete, color: Colors.red.shade400),
      ),
    );
  }
}
