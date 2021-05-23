import 'package:log_book/constants.dart';

/// general response model for services
class AppResponse {
  final ResponseAction action;
  final String message;
  final data;

  AppResponse({
    this.action,
    this.message,
    this.data,
  });

  @override
  String toString() =>
      'AppResponse(action: $action, message: $message, data: $data)';
}
