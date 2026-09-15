abstract class ErrorMessageHelper {
  static String getErrorType(dynamic error) {
    final errorStr = error?.toString().toLowerCase() ?? '';

    if (errorStr.contains('invalid phone number') ||
        errorStr.contains('invalid credentials') ||
        errorStr.contains('unauthorized') ||
        errorStr.contains('401')) {
      return 'Authentication error';
    }

    if (errorStr.contains('timeout') ||
        errorStr.contains('socketexception') ||
        errorStr.contains('connection refused') ||
        errorStr.contains('network is unreachable') ||
        errorStr.contains('clientexception') ||
        errorStr.contains('failed host lookup')) {
      return 'Network error';
    }

    if (errorStr.contains('500') ||
        errorStr.contains('502') ||
        errorStr.contains('503') ||
        errorStr.contains('internal server error')) {
      return 'Server error';
    }

    return 'Login error';
  }

  static String getUserFriendlyMessage(dynamic error) {
    if (error == null) {
      return 'Something went wrong. Please try again.';
    }

    final String errorStr = error.toString().toLowerCase();

    if (errorStr.contains('invalid phone number') ||
        errorStr.contains('invalid credentials') ||
        errorStr.contains('phone number or password') ||
        errorStr.contains('unauthorized') ||
        errorStr.contains('401')) {
      return 'The phone number or password you entered is incorrect. Please try again.';
    }

  if (errorStr.contains('phone number and password are required')) {
      return 'Please enter both your phone number and password.';
    }

    if (errorStr.contains('token missing')) {
      return 'Login succeeded, but the server did not return a token.';
    }

    if (errorStr.contains('unexpected login response format')) {
      return 'The server returned an invalid login response.';
    }

    if (errorStr.contains('login failed') ||
        errorStr.contains('unexpected error during login')) {
      return 'We couldn’t sign you in right now. Please try again in a moment.';
    }

    if (errorStr.contains('failed to load profile data') ||
        errorStr.contains('profile data') ||
        errorStr.contains('failed to load your profile')) {
      return 'We couldn’t load your profile right now. Please try again.';
    }

    if (errorStr.contains('unexpected response format') ||
        errorStr.contains('failed to fetch initial state') ||
        errorStr.contains('failed to load initial state') ||
        errorStr.contains('failed to connect to detection hub') ||
        errorStr.contains('failed to parse signalr update')) {
      return 'We couldn’t load the latest information right now. Please try again.';
    }

    if (errorStr.contains('not found') ||
        errorStr.contains('لم يتم العثور') ||
        errorStr.contains('could not be found')) {
      return 'The requested information is not available right now. Please try again.';
    }

    if (errorStr.contains('500') ||
        errorStr.contains('502') ||
        errorStr.contains('503') ||
        errorStr.contains('internal server error')) {
      return 'The service is temporarily unavailable. Please try again later.';
    }

    if (errorStr.contains('404')) {
      return 'The requested information could not be found. Please try again.';
    }

    if (errorStr.contains('timeout')) {
      return 'The request is taking longer than expected. Please try again.';
    }

    if (errorStr.contains('failed to fetch') ||
        errorStr.contains('socketexception') ||
        errorStr.contains('connection refused') ||
        errorStr.contains('network is unreachable') ||
        errorStr.contains('clientexception') ||
        errorStr.contains('failed host lookup')) {
      return 'Please check your internet connection and try again.';
    }

    return 'Something went wrong. Please try again.';
  }
}