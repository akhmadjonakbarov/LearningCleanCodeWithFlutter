class Todo {
  final int id;
  final String title;
  final bool completed;
  Todo({required this.id, required this.title, required this.completed});

  toMap() {
    return {'id': id, 'title': title, 'completed': completed};
  }

  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      id: int.parse(map['id'].toString()),
      title: map['todo'] ?? "Unknown",
      completed: map['completed'],
    );
  }
}
