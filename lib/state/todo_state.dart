
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:note_flutter/model/todo.dart';

import '../inject.dart';

class TodoNotifier extends Notifier<List<Todo>> {
  TodoNotifier()  { init(); }

  Future<void> init() async {
    state = await database.todoDao.findAllTodos();
  }

  void add(Todo todo) {
    state = [...state, todo];
    database.todoDao.insertTodo(todo);
  }

  void update(Todo todo) {
    final index = state.indexWhere((element) => element.id == todo.id);
    state = [...state]..[index] = todo;
    database.todoDao.updateTodo(todo);
  }

  void delete(Todo todo) {
    state = state.where((element) => element.id != todo.id).toList();
    database.todoDao.deleteTodo(todo);
  }

  void clear() {
    state = [];
    database.todoDao.deleteAllTodos();
  }

  @override
  List<Todo> build() {
    return [];
  }
}

final todoListProvider = NotifierProvider<TodoNotifier, List<Todo>>(() => TodoNotifier());
