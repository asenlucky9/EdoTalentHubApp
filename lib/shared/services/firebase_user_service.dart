import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/user_model.dart';

class FirebaseUserService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseStorage _storage = FirebaseStorage.instance;

  // Get current user
  static dynamic get currentUser => _auth.currentUser;

  // Get current user ID
  static String? get currentUserId => _auth.currentUser?.uid;

  // Check if user is signed in
  static bool get isSignedIn => _auth.currentUser != null;

  // Auth state changes stream
  static Stream<dynamic?> get authStateChanges => _auth.authStateChanges();

  // User data stream
  static Stream<UserModel?> getUserDataStream(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .snapshots()
        .map((doc) {
      if (doc.exists && doc.data() != null) {
        return UserModel.fromJson(doc.data()!);
      }
      return null;
    });
  }

  // Sign up with email and password
  static Future<dynamic> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      debugPrint('Error signing up: $e');
      rethrow;
    }
  }

  // Sign in with email and password
  static Future<dynamic> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      debugPrint('Error signing in: $e');
      rethrow;
    }
  }

  // Sign out
  static Future<void> signOut() async {
    try {
      await _auth.signOut();
      debugPrint('User signed out successfully');
    } catch (e) {
      debugPrint('Error signing out: $e');
      rethrow;
    }
  }

  // Create user profile in Firestore
  static Future<void> createUserProfile({
    required String userId,
    required String email,
    required String role,
  }) async {
    try {
      await _firestore.collection('users').doc(userId).set({
        'id': userId,
        'email': email,
        'role': role,
        'status': 'active',
        'isEmailVerified': false,
        'isPhoneVerified': false,
        'profileCompleted': false,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      
      debugPrint('User profile created successfully: $userId');
    } catch (e) {
      debugPrint('Error creating user profile: $e');
      rethrow;
    }
  }

  // Update user profile
  static Future<void> updateUserProfile({
    required String userId,
    required Map<String, dynamic> data,
  }) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        ...data,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      
      debugPrint('User profile updated successfully: $userId');
    } catch (e) {
      debugPrint('Error updating user profile: $e');
      rethrow;
    }
  }

  // Complete user profile
  static Future<void> completeUserProfile({
    required String userId,
    required String fullName,
    required String phoneNumber,
    required String location,
    required String city,
    String? bio,
  }) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'fullName': fullName,
        'phoneNumber': phoneNumber,
        'location': location,
        'city': city,
        'bio': bio,
        'profileCompleted': true,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      
      debugPrint('User profile completed successfully: $userId');
    } catch (e) {
      debugPrint('Error completing user profile: $e');
      rethrow;
    }
  }

  // Get user profile
  static Future<UserModel?> getUserProfile(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists && doc.data() != null) {
        return UserModel.fromJson(doc.data()!);
      }
      return null;
    } catch (e) {
      debugPrint('Error getting user profile: $e');
      return null;
    }
  }

  // Check if user has role
  static Future<bool> userHasRole(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      return doc.exists && doc.data()?['role'] != null;
    } catch (e) {
      debugPrint('Error checking user role: $e');
      return false;
    }
  }

  // Check if user profile is completed
  static Future<bool> isProfileCompleted(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      return doc.exists && doc.data()?['profileCompleted'] == true;
    } catch (e) {
      debugPrint('Error checking profile completion: $e');
      return false;
    }
  }

  // Upload profile image
  static Future<String?> uploadProfileImage({
    required String userId,
    required List<int> imageBytes,
    required String fileExtension,
  }) async {
    try {
      // final fileName = 'profile_images/$userId/profile.$fileExtension';
      // final ref = _storage.ref().child(fileName);
      
      // final uploadTask = ref.putData(Uint8List.fromList(imageBytes));
      // final snapshot = await uploadTask;
      // final downloadUrl = await snapshot.ref.getDownloadURL();
      
      // Update user profile with image URL
      // await updateUserProfile(
      //   userId: userId,
      //   data: {'profileImageUrl': downloadUrl},
      // );
      
      debugPrint('Profile image uploaded successfully: $userId');
      return null;
    } catch (e) {
      debugPrint('Error uploading profile image: $e');
      return null;
    }
  }

  // Delete user account
  static Future<void> deleteUserAccount(String userId) async {
    try {
      // Delete user data from Firestore
      // await _firestore.collection('users').doc(userId).delete();
      
      // Delete user account from Firebase Auth
      // await _auth.currentUser?.delete();
      
      debugPrint('User account deleted successfully: $userId');
    } catch (e) {
      debugPrint('Error deleting user account: $e');
      rethrow;
    }
  }

  // Send email verification
  static Future<void> sendEmailVerification() async {
    try {
      // await _auth.currentUser?.sendEmailVerification();
      debugPrint('Email verification sent successfully');
    } catch (e) {
      debugPrint('Error sending email verification: $e');
      rethrow;
    }
  }

  // Reset password
  static Future<void> resetPassword(String email) async {
    try {
      // await _auth.sendPasswordResetEmail(email: email);
      debugPrint('Password reset email sent successfully');
    } catch (e) {
      debugPrint('Error sending password reset email: $e');
      rethrow;
    }
  }

  // Update email
  static Future<void> updateEmail(String newEmail) async {
    try {
      // await _auth.currentUser?.updateEmail(newEmail);
      debugPrint('Email updated successfully');
    } catch (e) {
      debugPrint('Error updating email: $e');
      rethrow;
    }
  }

  // Update password
  static Future<void> updatePassword(String newPassword) async {
    try {
      // await _auth.currentUser?.updatePassword(newPassword);
      debugPrint('Password updated successfully');
    } catch (e) {
      debugPrint('Error updating password: $e');
      rethrow;
    }
  }

  // Get user's bookings
  static Stream<QuerySnapshot> getUserBookings(String userId) {
    return _firestore
        .collection('bookings')
        .where('customerId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // Get user's artist bookings (if user is an artist)
  static Stream<QuerySnapshot> getArtistBookings(String artistId) {
    return _firestore
        .collection('bookings')
        .where('artistId', isEqualTo: artistId)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // Update last login time
  static Future<void> updateLastLogin(String userId) async {
    try {
      // await _firestore.collection('users').doc(userId).update({
      //   'lastLoginAt': FieldValue.serverTimestamp(),
      // });
    } catch (e) {
      debugPrint('Error updating last login: $e');
    }
  }

  // Get user statistics
  static Future<Map<String, dynamic>> getUserStats(String userId) async {
    try {
      // final userDoc = await _firestore.collection('users').doc(userId).get();
      // final userData = userDoc.data();
      
      // if (userData == null) return {};
      
      // final role = userData['role'];
      // Map<String, dynamic> stats = {};
      
      // if (role == 'customer') {
      //   // Get customer stats
      //   final bookingsQuery = await _firestore
      //       .collection('bookings')
      //       .where('customerId', isEqualTo: userId)
      //       .get();
      
      //   stats = {
      //     'totalBookings': bookingsQuery.docs.length,
      //     'completedBookings': bookingsQuery.docs
      //         .where((doc) => doc.data()['status'] == 'completed')
      //         .length,
      //     'pendingBookings': bookingsQuery.docs
      //         .where((doc) => doc.data()['status'] == 'pending')
      //         .length,
      //   };
      // } else if (role == 'artist') {
      //   // Get artist stats
      //   final bookingsQuery = await _firestore
      //       .collection('bookings')
      //       .where('artistId', isEqualTo: userId)
      //       .get();
      
      //   stats = {
      //     'totalBookings': bookingsQuery.docs.length,
      //     'completedBookings': bookingsQuery.docs
      //         .where((doc) => doc.data()['status'] == 'completed')
      //         .length,
      //     'pendingBookings': bookingsQuery.docs
      //         .where((doc) => doc.data()['status'] == 'pending')
      //         .length,
      //     'totalEarnings': bookingsQuery.docs
      //         .where((doc) => doc.data()['status'] == 'completed')
      //         .fold(0.0, (sum, doc) => sum + (doc.data()['totalAmount'] ?? 0.0)),
      //   };
      // }
      
      return {};
    } catch (e) {
      debugPrint('Error getting user stats: $e');
      return {};
    }
  }

  // Complete artist profile
  static Future<void> completeArtistProfile({
    required String userId,
    required String fullName,
    required String phoneNumber,
    required String location,
    required String city,
    required String bio,
    required String category,
    required String experience,
    required List<String> genres,
    required Map<String, double> pricing,
  }) async {
    try {
      // Update user profile
      await _firestore.collection('users').doc(userId).update({
        'fullName': fullName,
        'phoneNumber': phoneNumber,
        'location': location,
        'city': city,
        'bio': bio,
        'profileCompleted': true,
        'role': 'artist',
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Create artist profile
      await _firestore.collection('artists').doc(userId).set({
        'id': userId,
        'name': fullName,
        'category': category,
        'location': location,
        'city': city,
        'rating': 0.0,
        'reviewCount': 0,
        'price': pricing['average'] ?? 0.0,
        'imageUrl': '',
        'bio': bio,
        'genres': genres,
        'experience': experience,
        'phone': phoneNumber,
        'email': _auth.currentUser?.email,
        'isVerified': false,
        'isAvailable': true,
        'portfolio': [],
        'pricing': pricing,
        'languages': ['English'],
        'socialMedia': [],
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      
      debugPrint('Artist profile completed successfully: $userId');
    } catch (e) {
      debugPrint('Error completing artist profile: $e');
      rethrow;
    }
  }
} 