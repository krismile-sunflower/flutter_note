import 'dart:async';

import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:note_flutter/dao/todo_dao.dart';

import '../dao/note_dao.dart';
import '../model/note.dart';
import '../model/todo.dart';
import 'datetime_converter.dart';

part 'database.g.dart'; // the generated code will be there
@TypeConverters([DateTimeConverter])
@Database(version: 1, entities: [Note, Todo])
abstract class AppDatabase extends FloorDatabase {
  TodoDao get todoDao;
  NoteDao get noteDao;
}