import 'package:flutter/material.dart';
import 'package:learning_clean_code/features/home/controllers/todo_controller.dart';

import '../models/todo.dart';
import 'widgets/todo_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TodoController _controller = TodoController();

  List<Todo> _todos = [];
  bool loading = false;

  void loadTodos() async {
    setState(() {
      loading = true;
    });
    final todos = await _controller.fetchTodos();
    setState(() {
      _todos = todos;
    });
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    loadTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Todo App'), centerTitle: true),
      body: RefreshIndicator(
        onRefresh: () async {
          loadTodos();
        },
        child: loading
            ? Center(child: CircularProgressIndicator())
            : ListView(
                children: [
                  _todos.isEmpty
                      ? Center(child: Text("No todos"))
                      : TodoList(todos: _todos),
                ],
              ),
      ),
    );
  }
}
