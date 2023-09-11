import 'package:floor/floor.dart';
import 'package:flutter_floor/data/db/todo.dart';

@dao
abstract class TodoDao {
  @insert
  Future<void> add(Todo todo);

  @Query("SELECT * FROM Todo")
  Stream<List<Todo>> list();

  @Query("SELECT * FROM Todo ORDER BY id DESC LIMIT 1")
  Future<Todo?> findTodoLast();

  @Query("DELETE FROM Todo WHERE id =:id")
  Future<void> delete(int id);

  @Query("SELECT * FROM Todo WHERE id = :id")
  Future<Todo?> findId(int id);

  @Query("UPDATE Todo SET task = :task WHERE id = :id")
  Future<void> updateId(int id, String task);

  @Query("DELETE FROM Todo")
  Future<void> deleteAll();
}
