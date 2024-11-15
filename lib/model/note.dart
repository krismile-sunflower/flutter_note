
import 'package:floor/floor.dart';

@entity
class Note {
  @primaryKey
  String id;
  String title;
  String content;
  String showContent;
  String date;

  Note({required this.id, required this.title, required this.content, required this.showContent, required this.date});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'showContent': showContent,
      'date': date,
    };
  }

  factory Note.fromMap(Map<String, dynamic> json) => new Note(
    id: json["id"],
    title: json["title"],
    content: json["content"],
    showContent: json["showContent"],
    date: json["date"],
  );
}