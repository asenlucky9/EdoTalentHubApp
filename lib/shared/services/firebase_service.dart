import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:typed_data';

class FirebaseService {
  static FirebaseAuth? _auth;
  static FirebaseFirestore? _firestore;
  static FirebaseStorage? _storage;
  static FirebaseMessaging? _messaging;

  // Getters for Firebase instances
  static FirebaseAuth get auth => _auth!;
  static FirebaseFirestore get firestore => _firestore!;
  static FirebaseStorage get storage => _storage!;
  static FirebaseMessaging get messaging => _messaging!;

  // Initialize Firebase services
  static Future<void> initialize() async {
    try {
      // Initialize Firebase Auth
      _auth = FirebaseAuth.instance;
      
      // Initialize Firestore
      _firestore = FirebaseFirestore.instance;
      
      // Initialize Storage
      _storage = FirebaseStorage.instance;
      
      // Initialize Messaging
      _messaging = FirebaseMessaging.instance;
      
      // Request notification permissions
      await _requestNotificationPermissions();
      
      // Enable offline persistence
      await enableOfflinePersistence();
      
      debugPrint('Firebase services initialized successfully');
    } catch (e) {
      debugPrint('Error initializing Firebase services: $e');
    }
  }

  // Request notification permissions
  static Future<void> _requestNotificationPermissions() async {
    try {
      NotificationSettings settings = await _messaging!.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
      
      debugPrint('User granted permission: ${settings.authorizationStatus}');
    } catch (e) {
      debugPrint('Error requesting notification permissions: $e');
    }
  }

  // Get current user
  static User? get currentUser => _auth?.currentUser;

  // Check if user is signed in
  static bool get isSignedIn => _auth?.currentUser != null;

  // Get user ID
  static String? get userId => _auth?.currentUser?.uid;

  // Get user email
  static String? get userEmail => _auth?.currentUser?.email;

  // Sign out
  static Future<void> signOut() async {
    try {
      await _auth?.signOut();
      debugPrint('User signed out successfully');
    } catch (e) {
      debugPrint('Error signing out: $e');
      rethrow;
    }
  }

  // Delete user account
  static Future<void> deleteUser() async {
    try {
      await _auth?.currentUser?.delete();
      debugPrint('User account deleted successfully');
    } catch (e) {
      debugPrint('Error deleting user account: $e');
      rethrow;
    }
  }

  // Get FCM token
  static Future<String?> getFCMToken() async {
    try {
      return await _messaging?.getToken();
    } catch (e) {
      debugPrint('Error getting FCM token: $e');
      return null;
    }
  }

  // Subscribe to topic
  static Future<void> subscribeToTopic(String topic) async {
    try {
      await _messaging?.subscribeToTopic(topic);
      debugPrint('Subscribed to topic: $topic');
    } catch (e) {
      debugPrint('Error subscribing to topic: $e');
    }
  }

  // Unsubscribe from topic
  static Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _messaging?.unsubscribeFromTopic(topic);
      debugPrint('Unsubscribed from topic: $topic');
    } catch (e) {
      debugPrint('Error unsubscribing from topic: $e');
    }
  }

  // Get Firestore collection reference
  static CollectionReference<Map<String, dynamic>> collection(String path) {
    return _firestore!.collection(path);
  }

  // Get Firestore document reference
  static DocumentReference<Map<String, dynamic>> document(String path) {
    return _firestore!.doc(path);
  }

  // Get Storage reference
  static Reference storageRef(String path) {
    return _storage!.ref().child(path);
  }

  // Upload file to Storage
  static Future<String> uploadFile(String path, Uint8List bytes) async {
    try {
      final ref = storageRef(path);
      final uploadTask = ref.putData(bytes);
      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      debugPrint('Error uploading file: $e');
      rethrow;
    }
  }

  // Delete file from Storage
  static Future<void> deleteFile(String path) async {
    try {
      final ref = storageRef(path);
      await ref.delete();
      debugPrint('File deleted successfully: $path');
    } catch (e) {
      debugPrint('Error deleting file: $e');
      rethrow;
    }
  }

  // Batch write operations
  static WriteBatch batch() {
    return _firestore!.batch();
  }

  // Run transaction
  static Future<T> runTransaction<T>(TransactionHandler<T> handler) async {
    return await _firestore!.runTransaction(handler);
  }

  // Enable offline persistence
  static Future<void> enableOfflinePersistence() async {
    try {
      _firestore!.settings = const Settings(
        persistenceEnabled: true,
        cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
      );
      debugPrint('Offline persistence enabled');
    } catch (e) {
      debugPrint('Error enabling offline persistence: $e');
    }
  }

  // Clear offline cache
  static Future<void> clearOfflineCache() async {
    try {
      await _firestore!.clearPersistence();
      debugPrint('Offline cache cleared');
    } catch (e) {
      debugPrint('Error clearing offline cache: $e');
    }
  }

  // Get server timestamp
  static FieldValue get serverTimestamp => FieldValue.serverTimestamp();

  // Get array union
  static FieldValue arrayUnion(List<dynamic> elements) {
    return FieldValue.arrayUnion(elements);
  }

  // Get array remove
  static FieldValue arrayRemove(List<dynamic> elements) {
    return FieldValue.arrayRemove(elements);
  }

  // Get increment
  static FieldValue increment(num value) {
    return FieldValue.increment(value);
  }

  // Check if Firebase is initialized
  static bool get isInitialized => _auth != null && _firestore != null && _storage != null;

  // Dispose Firebase services (for testing purposes)
  static Future<void> dispose() async {
    try {
      await _auth?.signOut();
      await _firestore?.terminate();
      await _firestore?.clearPersistence();
      debugPrint('Firebase services disposed');
    } catch (e) {
      debugPrint('Error disposing Firebase services: $e');
    }
  }
} 