class MessageGenerator {
  static const Map<String, Map<String, String>> _messageMap = {
    "en": {
      "un-expected-error": "Some un expected error happened!",
      "un-expected-error-message": "Some un expected error happened!",
      "auth-welcome": "Input your credentials here to log in to the system.",
      "auth-visit-site-guide":
          "To explore in-depth instructions for utilizing this rapid starter Flutter project, head over to https://github.com/midhunarmid/to_do_app to kick off your journey.",
      "login-title": "Login to your\nAccount",
      "sample-description": "This is the page of Arkroot",
    },
  };

  static const Map<String, Map<String, String>> _labelMap = {
    "en": {
      "OK": "OK",
      "sign_in": "Sign In",
      "google-sign-in": "Sign in with Google",
    },
  };

  static String getMessage(String message) {
    return (_messageMap[getLanguage()] ?? {})[message] ?? message;
  }

  static String getLabel(String label) {
    return (_labelMap[getLanguage()] ?? {})[label] ?? label;
  }

  static String getLanguage() {
    // Implement multi language support here
    return "en";
  }
}
