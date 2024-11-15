
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../inject.dart';
import '../model/note.dart';

class NoteState extends Notifier<List<Note>> {
  NoteState() {
    init();
  }

  Future<void> init() async {
    state = await database.noteDao.findAllNotes();
  }

  void add(Note note) {
    state = [...state, note];
    database.noteDao.insertNote(note);
  }

  void update(Note note) {
    final index = state.indexWhere((element) => element.id == note.id);
    state = [...state]..[index] = note;
    database.noteDao.updateNote(note);
  }

  void delete(Note note) {
    state = state.where((element) => element.id != note.id).toList();
    database.noteDao.deleteNote(note);
  }

  void clear() {
    state = [];
    database.noteDao.deleteAllNotes();
  }

  @override
  List<Note> build() {
    return [];
  }
}

final noteListProvider = NotifierProvider<NoteState, List<Note>>(() => NoteState());