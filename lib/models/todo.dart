import 'dart:convert';

import 'package:sembast/timestamp.dart';

/// a simple quick todo class model
class Todo {
  int id;
  final String todo;
  final Timestamp createdOn;

  Todo({
    this.id,
    this.todo,
    this.createdOn,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'todo': todo,
      'createdOn': createdOn,
    };
  }

  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      id: map['id'] ?? 0,
      todo: map['todo'] ?? '',
      createdOn: map['createdOn'],
    );
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() => 'Todo(id: $id, todo: $todo, createdOn: $createdOn)';
}
