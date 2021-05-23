import 'package:log_book/constants.dart';

class AppEvent {
  final ResponseEventAction action;
  final String title;
  final String message;

  /// optional data passed on event
  final data;

  AppEvent({this.action, this.title, this.message, this.data});

  @override
  String toString() =>
      'AppEvent(action: $action, title: $title, message: $message)';
}
