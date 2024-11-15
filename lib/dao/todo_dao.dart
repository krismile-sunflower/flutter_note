
import 'package:floor/floor.dart';

import '../model/todo.dart';

@dao
abstract class TodoDao {
  @Query('SELECT * FROM Todo')
  Future<List<Todo>> findAllTodos();

  @Query('SELECT * FROM Todo WHERE id = :id')
  Future<Todo?> findTodoById(int id);

  @insert
  Future<void> insertTodo(Todo todo);

  @update
  Future<void> updateTodo(Todo todo);

  @delete
  Future<void> deleteTodo(Todo todo);

  @Query('DELETE FROM Todo')
  Future<void> deleteAllTodos();
}