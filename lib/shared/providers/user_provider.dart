import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

// Provider for Firebase Auth user
final authUserProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

// Provider for user data from Firestore
final userDataProvider = StreamProvider.family<UserModel?, String>((ref, userId) async* {
  final doc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
  if (doc.exists && doc.data() != null) {
    yield UserModel.fromJson(doc.data()!);
  } else {
    yield null;
  }
});

// Provider for current user's complete data
final currentUserProvider = Provider<UserModel?>((ref) {
  final authUser = ref.watch(authUserProvider).value;
  if (authUser == null) return null;
  
  final userData = ref.watch(userDataProvider(authUser.uid)).value;
  return userData;
});

// Provider for user role
final userRoleProvider = Provider<UserRole?>((ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return null;
  return user.role;
});

// Provider for checking if user profile is completed
final isProfileCompletedProvider = Provider<bool>((ref) {
  final user = ref.watch(currentUserProvider);
  return user?.profileCompleted ?? false;
});

// Provider for user authentication state
final authStateProvider = Provider<AuthState>((ref) {
  final authUser = ref.watch(authUserProvider);
  
  return authUser.when(
    data: (user) {
      if (user == null) return AuthState.unauthenticated;
      return AuthState.authenticated;
    },
    loading: () => AuthState.loading,
    error: (error, stack) => AuthState.error,
  );
});

enum AuthState {
  unauthenticated,
  authenticated,
  loading,
  error,
}

// Provider for user actions
final userActionsProvider = Provider<UserActions>((ref) {
  return UserActions(ref);
});

class UserActions {
  final Ref _ref;
  
  UserActions(this._ref);
  
  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
  
  Future<void> updateProfile(Map<String, dynamic> data) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .update({
      ...data,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
  
  Future<void> deleteAccount() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    
    // Delete user data from Firestore
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .delete();
    
    // Delete user account
    await user.delete();
  }
} 