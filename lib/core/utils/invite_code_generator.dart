import 'dart:math';

class InviteCodeGenerator {
  static const String _chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
  static final Random _random = Random.secure();

  /// Generate a 6-character alphanumeric invite code
  static String generate({int length = 6}) {
    return List.generate(
      length,
      (_) => _chars[_random.nextInt(_chars.length)],
    ).join();
  }

  /// Validate format of an invite code
  static bool isValidFormat(String code) {
    if (code.length != 6) return false;
    return code.split('').every((char) => _chars.contains(char.toUpperCase()));
  }

  /// Format code with spacing for display: "ABC DEF"
  static String formatForDisplay(String code) {
    final upper = code.toUpperCase();
    if (upper.length <= 3) return upper;
    return '${upper.substring(0, 3)} ${upper.substring(3)}';
  }
}
