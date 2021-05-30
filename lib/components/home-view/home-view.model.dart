import 'package:momentum/momentum.dart';

import 'package:log_book/constants.dart';
import 'package:log_book/models/index.dart';

import 'index.dart';

class HomeViewModel extends MomentumModel<HomeViewController> {
  HomeViewModel(
    HomeViewController controller, {
    this.todos,
    this.logBooks,
    this.loading,
    this.sideBarLoading,
    this.sideBarSignal,
    this.entryDate,
    this.viewMode,
    this.editLogBook,
  }) : super(controller);

  final SideBarSignal sideBarSignal;
  final List<Todo> todos;
  final List<LogBook> logBooks;
  final bool loading;
  final DateTime entryDate;
  final bool sideBarLoading;
  final LogBook editLogBook;
  final ViewMode viewMode;

  @override
  void update({
    SideBarSignal sideBarSignal,
    List<Todo> todos,
    List<LogBook> logBooks,
    bool loading,
    DateTime entryDate,
    bool sideBarLoading,
    LogBook editLogBook,
    ViewMode viewMode,
  }) {
    HomeViewModel(
      controller,
      viewMode:  viewMode ?? this.viewMode,
      entryDate: entryDate ?? this.entryDate,
      sideBarSignal: sideBarSignal ?? this.sideBarSignal,
      todos: todos ?? this.todos,
      logBooks: logBooks ?? this.logBooks,
      loading: loading ?? this.loading,
      sideBarLoading: sideBarLoading ?? this.sideBarLoading,
      editLogBook: editLogBook ?? this.editLogBook,
    ).updateMomentum();
  }
}
