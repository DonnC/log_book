import 'package:log_book/constants.dart';
import 'package:log_book/data/index.dart';
import 'package:log_book/models/index.dart';
import 'package:momentum/momentum.dart';

// service class to perform CRUD operations against sembast db
// @DonnC
// 30 May 2021

/// main app service that performs business logic
class AppService extends MomentumService {
  static final Dao _dao = Dao();

  Future<AppResponse> getTodos() async {
    try {
      final todos = await _dao.getAllTodos();

      return AppResponse(
        data: todos,
        action: ResponseAction.Success,
        message: 'successful',
      );
    }

    // catch error, if any
    catch (e) {
      print(e.toString());
      return AppResponse(
        action: ResponseAction.Error,
        message: e.toString(),
      );
    }
  }

  Future<AppResponse> addTodo(Todo todo) async {
    try {
      final todoId = await _dao.insertTodo(todo);

      return AppResponse(
        data: todoId,
        action: ResponseAction.Success,
        message: 'your todo was saved!',
      );
    }

    // catch error, if any
    catch (e) {
      print(e.toString());
      return AppResponse(
        action: ResponseAction.Error,
        message: e.toString(),
      );
    }
  }

  Future<AppResponse> deleteTodo(Todo todo) async {
    try {
      final todoId = await _dao.deleteTodo(todo);

      return AppResponse(
        data: todoId,
        action: ResponseAction.Success,
        message: 'todo was deleted!',
      );
    }

    // catch error, if any
    catch (e) {
      print(e.toString());
      return AppResponse(
        action: ResponseAction.Error,
        message: e.toString(),
      );
    }
  }

  Future<AppResponse> addLogBook(LogBook logBook) async {
    try {
      final logBkId = await _dao.insertLogBook(logBook);

      return AppResponse(
        data: logBkId,
        action: ResponseAction.Success,
        message: 'your log book entry was saved!',
      );
    }

    // catch error, if any
    catch (e) {
      print(e.toString());
      return AppResponse(
        action: ResponseAction.Error,
        message: e.toString(),
      );
    }
  }

  Future<AppResponse> updateLogBook(LogBook logBook) async {
    try {
      await _dao.updateLogBook(logBook);

      return AppResponse(
        action: ResponseAction.Success,
        message: 'your log book entry was updated!',
      );
    }

    // catch error, if any
    catch (e) {
      print(e.toString());
      return AppResponse(
        action: ResponseAction.Error,
        message: e.toString(),
      );
    }
  }

  Future<AppResponse> deleteLogBook(LogBook logBook) async {
    try {
      await _dao.deleteLogBook(logBook);

      return AppResponse(
        action: ResponseAction.Success,
        message: 'your log book entry was deleted!',
      );
    }

    // catch error, if any
    catch (e) {
      print(e.toString());
      return AppResponse(
        action: ResponseAction.Error,
        message: e.toString(),
      );
    }
  }

  Future<AppResponse> getLogBooks({bool descendSort: false}) async {
    try {
      final logBks = await _dao.getAllLogBooks(descendSort: descendSort);

      return AppResponse(
        data: logBks,
        action: ResponseAction.Success,
        message: 'success',
      );
    }

    // catch error, if any
    catch (e) {
      print(e.toString());
      return AppResponse(
        action: ResponseAction.Error,
        message: e.toString(),
      );
    }
  }
}
