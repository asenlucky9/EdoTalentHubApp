import 'package:hive/hive.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import '../../features/booking/domain/models/booking.dart';
import 'package:flutter/foundation.dart';

class BookingMigrationService {
  static Future<void> migrateHiveToFirestore() async {
    // Temporarily disabled for web compatibility
    debugPrint('Booking migration temporarily disabled for web compatibility');
  }
} 