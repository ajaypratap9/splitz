import 'package:intl/intl.dart';

class CurrencyFormatter {
  static final NumberFormat _indianFormat = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 2,
  );

  static final NumberFormat _indianFormatNoDecimal = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 0,
  );

  /// Format paise to rupee string: 10050 → "₹100.50"
  static String formatPaise(int paise) {
    final rupees = paise / 100.0;
    return _indianFormat.format(rupees);
  }

  /// Format paise to rupee string without decimals: 10050 → "₹101"
  static String formatPaiseRounded(int paise) {
    final rupees = (paise / 100.0).round();
    return _indianFormatNoDecimal.format(rupees);
  }

  /// Format rupee amount: 1000.50 → "₹1,000.50"
  static String formatRupees(double rupees) {
    return _indianFormat.format(rupees);
  }

  /// Convert rupees to paise: 100.50 → 10050
  static int rupeesToPaise(double rupees) {
    return (rupees * 100).round();
  }

  /// Convert paise to rupees: 10050 → 100.50
  static double paiseToRupees(int paise) {
    return paise / 100.0;
  }

  /// Format with Indian numbering (1,00,000)
  static String formatIndian(double value) {
    if (value < 0) {
      return '-${formatIndian(-value)}';
    }

    final parts = value.toStringAsFixed(2).split('.');
    final integerPart = parts[0];
    final decimalPart = parts.length > 1 ? parts[1] : '00';

    if (integerPart.length <= 3) {
      return '₹$integerPart.$decimalPart';
    }

    final lastThree = integerPart.substring(integerPart.length - 3);
    final remaining = integerPart.substring(0, integerPart.length - 3);

    final buffer = StringBuffer();
    for (int i = 0; i < remaining.length; i++) {
      if (i > 0 && (remaining.length - i) % 2 == 0) {
        buffer.write(',');
      }
      buffer.write(remaining[i]);
    }
    buffer.write(',');
    buffer.write(lastThree);

    return '₹$buffer.$decimalPart';
  }

  /// Format paise with Indian numbering
  static String formatPaiseIndian(int paise) {
    return formatIndian(paise / 100.0);
  }
}
