import 'dart:math';

class BookingUtils {
  static const String _chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  static final Random _random = Random();

  /// Generates a unique booking reference number
  /// Format: ETH-YYYYMMDD-XXXXX
  /// Example: ETH-20241201-A7B9C
  static String generateReferenceNumber() {
    final now = DateTime.now();
    final datePart = '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}';
    final randomPart = List.generate(5, (index) => _chars[_random.nextInt(_chars.length)]).join();
    
    return 'ETH-$datePart-$randomPart';
  }

  /// Formats the reference number for display
  static String formatReferenceNumber(String referenceNumber) {
    // Add spaces for better readability: ETH-20241201-A7B9C
    if (referenceNumber.length >= 16) {
      return '${referenceNumber.substring(0, 4)} ${referenceNumber.substring(4, 12)} ${referenceNumber.substring(12)}';
    }
    return referenceNumber;
  }

  /// Validates if a reference number follows the correct format
  static bool isValidReferenceNumber(String referenceNumber) {
    // Check if it matches ETH-YYYYMMDD-XXXXX format
    final regex = RegExp(r'^ETH-\d{8}-[A-Z0-9]{5}$');
    return regex.hasMatch(referenceNumber);
  }

  /// Extracts date from reference number
  static DateTime? extractDateFromReference(String referenceNumber) {
    try {
      if (referenceNumber.length >= 12) {
        final dateString = referenceNumber.substring(4, 12); // YYYYMMDD
        final year = int.parse(dateString.substring(0, 4));
        final month = int.parse(dateString.substring(4, 6));
        final day = int.parse(dateString.substring(6, 8));
        return DateTime(year, month, day);
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  /// Generates a short booking ID for internal use
  static String generateShortId() {
    return List.generate(8, (index) => _chars[_random.nextInt(_chars.length)]).join();
  }
} 