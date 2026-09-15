import 'package:escapia/core/utils/error_meassage_heper.dart';

enum ErrorType { noInternet, serverUnavailable, unknown }

class AppError {
  final String title;
  final String message;
  final ErrorType type;

  AppError({
    required this.title,
    required this.message,
    required this.type,
  });
}

class ErrorHandler {
  static AppError handle(dynamic error) {
    final String errorStr = error.toString().toLowerCase();

    if (errorStr.contains('500') ||
        errorStr.contains('502') ||
        errorStr.contains('503') ||
        errorStr.contains('404') ||
        errorStr.contains('internal server error') ||
        errorStr.contains('server error') ||
        errorStr.contains('service is temporarily unavailable')) {
      return AppError(
        title: 'Server Error',
        message: ErrorMessageHelper.getUserFriendlyMessage(error),
        type: ErrorType.serverUnavailable,
      );
    }
    if (errorStr.contains('connection refused') ||
        errorStr.contains('failed to connect') ||
        errorStr.contains('server unavailable') ||
        errorStr.contains('failed to connect to detection hub')) {
      return AppError(
        title: 'Server Unavailable',
        message: 'The service is currently unavailable. Please try again in a moment.',
        type: ErrorType.serverUnavailable,
      );
    }

    if (errorStr.contains('socketexception') ||
        errorStr.contains('network is unreachable') ||
        errorStr.contains('no internet') ||
        errorStr.contains('failed host lookup')) {
      return AppError(
        title: 'No Internet Connection',
        message: 'Please check your internet connection and try again.',
        type: ErrorType.noInternet,
      );
    }

    return AppError(
      title: 'Error Occurred',
      message: ErrorMessageHelper.getUserFriendlyMessage(error),
      type: ErrorType.unknown,
    );
  }
}