
import 'package:floor/floor.dart';

import '../model/note.dart';

@dao
abstract class NoteDao {
  @Query('SELECT * FROM Note')
  Future<List<Note>> findAllNotes();

  @Query('SELECT * FROM Note WHERE id = :id')
  Future<Note?> findNoteById(int id);

  @insert
  Future<void> insertNote(Note note);

  @update
  Future<void> updateNote(Note note);

  @delete
  Future<void> deleteNote(Note note);

  @Query('DELETE FROM Note')
  Future<void> deleteAllNotes();
}