class AppConstants {

  static const String usersCollection = 'users';
  static const String postsCollection = 'posts';

  static const List<String> categories = [
    'All',
    'Technology',
    'Career',
    'Study Abroad',
    'General Discussion',
  ];

  static const List<String> interestCategories = [
    'Technology',
    'Career',
    'Study Abroad',
    'General Discussion',
  ];

  static const Map<String, String> categoryEmoji = {
    'All': '🌐',
    'Technology': '💻',
    'Career': '💼',
    'Study Abroad': '✈️',
    'General Discussion': '💬',
  };

  static const int minPasswordLength = 6;
  static const int maxPostLength = 500;
  static const int minPostLength = 10;

  static const double defaultPadding = 16.0;
  static const double cardRadius = 14.0;
  static const double buttonRadius = 12.0;
  static const double chipRadius = 99.0;
  static const double defaultElevation = 0.0;

  static const String logoPath = 'assets/logo/logo.png';

  static const String appName = 'Student Hub';
  static const String appTagline = 'Connecting campus minds';

  static const String successTitle = 'Success';
  static const String errorTitle = 'Oops!';
  static const String warningTitle = 'Hold on!';
  static const String infoTitle = 'Info';
}
