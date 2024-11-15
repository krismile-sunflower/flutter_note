
import 'package:floor/floor.dart';

@entity
class Todo {
  @primaryKey
  String id;
  String title;
  String description;
  bool done;

  Todo({
    required this.id,
    required this.title,
    required this.description,
    required this.done,
  });

  factory Todo.fromJson(Map<String, dynamic> json) => Todo(
    id: json["id"],
    title: json["title"],
    description: json["description"],
    done: json["done"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "done": done,
  };
}