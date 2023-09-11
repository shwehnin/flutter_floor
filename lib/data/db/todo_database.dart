import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:flutter_floor/data/db/todo.dart';
import 'package:flutter_floor/data/db/todo_dao.dart';

part 'todo_database.g.dart';

@Database(version: 1, entities: [Todo])
abstract class TodoDatabase extends FloorDatabase {
  TodoDao get todoDao;
}
