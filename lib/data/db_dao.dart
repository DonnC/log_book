// logbook Database Access Object (dao)
import 'dart:async';

import 'package:sembast/sembast.dart';

import 'package:log_book/models/index.dart';

import 'index.dart';

class Dao {
  // private getter to shorten the amount of code needed to get the
  // singleton instance of an opened database
  static Future<Database> get _db async => await AppDatabase.instance.database;

  static const String _LOG_BOOK_STORE = 'logbook';
  static const String _TODO_STORE = 'todo';

  // a store with int key and Map<String, dynamic> values
  static final _logbookStore = intMapStoreFactory.store(_LOG_BOOK_STORE);
  static final _todoStore = intMapStoreFactory.store(_TODO_STORE);

// ---------------------------------------- logbook CRUD -------------------------------------------------------
  Future<int> insertLogBook(LogBook logBook) async {
    var recordID = await _logbookStore.add(await _db, logBook.toMap());

    return recordID;
  }

  Future<void> updateLogBook(LogBook logBook) async {
    final finder = Finder(filter: Filter.byKey(logBook.id));

    await _logbookStore.update(
      await _db,
      logBook.toMap(),
      finder: finder,
    );
  }

  Future<int> deleteLogBook(LogBook logBook) async {
    final finder = Finder(filter: Filter.byKey(logBook.id));

    var res = await _logbookStore.delete(
      await _db,
      finder: finder,
    );

    return res;
  }

  /// get all logbooks
  Future<List<LogBook>> getAllLogBooks({bool descendSort: false}) async {
    final finder = Finder(
      sortOrders: [
        SortOrder('date', descendSort),
      ],
    );

    final logBookSnapshots =
        await _logbookStore.find(await _db, finder: finder);

    // map result to model
    var _logBooks = logBookSnapshots.map((snapshot) {
      final _book = LogBook.fromMap(snapshot.value);
      // an ID is a key of a record from the database.
      _book.id = snapshot.key;

      // return mapped logbook
      return _book;
    }).toList();

    return _logBooks;
  }

  // ---------------------- todo CRUD ---------------------------------------------------------
  Future<int> insertTodo(Todo todo) async {
    var recordID = await _todoStore.add(await _db, todo.toMap());

    return recordID;
  }

  Future<int> deleteTodo(Todo todo) async {
    final finder = Finder(filter: Filter.byKey(todo.id));

    var res = await _todoStore.delete(
      await _db,
      finder: finder,
    );

    return res;
  }

  /// get all todos
  Future<List<Todo>> getAllTodos() async {
    final finder = Finder(
      sortOrders: [
        SortOrder('createdOn', false),
      ],
    );

    final todoSnapshots = await _todoStore.find(await _db, finder: finder);

    // map result to model
    var _todos = todoSnapshots.map((snapshot) {
      final _todo = Todo.fromMap(snapshot.value);
      // an ID is a key of a record from the database.
      _todo.id = snapshot.key;

      // return mapped todo
      return _todo;
    }).toList();

    return _todos;
  }

// ----------------------------------------------------- GENERAL ----------------------------------------------
  /// delete database store
  Future<void> dropStore() async {
    await _logbookStore.drop(await _db);
    await _todoStore.drop(await _db);
    print('== deleted db stores..i hope you knew what you were doing! ==');
  }

  // ------------------------------------------ DB Backup ---------------------------------------------------
  ///  do a db system backup
  Future<void> backUpDb() async {
    // TODO: Implement db backup
  }
}
