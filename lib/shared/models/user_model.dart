// import 'package:cloud_firestore/cloud_firestore.dart';

// User roles enum
enum UserRole {
  customer,
  artist,
  agent,
  admin,
}

enum UserStatus {
  active,
  inactive,
  suspended,
  pending,
  verified,
}

class UserModel {
  final String id;
  final String email;
  final String fullName;
  final String? phoneNumber;
  final String? profileImageUrl;
  final UserRole role;
  final UserStatus status;
  final String? bio;
  final String? location;
  final String? city;
  final List<String>? categories;
  final Map<String, dynamic>? preferences;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? lastLoginAt;
  final bool isEmailVerified;
  final bool isPhoneVerified;
  final bool profileCompleted;
  final Map<String, dynamic>? metadata;

  UserModel({
    required this.id,
    required this.email,
    required this.fullName,
    this.phoneNumber,
    this.profileImageUrl,
    required this.role,
    required this.status,
    this.bio,
    this.location,
    this.city,
    this.categories,
    this.preferences,
    required this.createdAt,
    required this.updatedAt,
    this.lastLoginAt,
    required this.isEmailVerified,
    required this.isPhoneVerified,
    required this.profileCompleted,
    this.metadata,
  });

  // Factory constructor to create UserModel from Map
  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      id: data['id'] ?? '',
      email: data['email'] ?? '',
      fullName: data['fullName'] ?? '',
      phoneNumber: data['phoneNumber'],
      profileImageUrl: data['profileImageUrl'],
      role: UserRole.values.firstWhere(
        (role) => role.toString().split('.').last == data['role'],
        orElse: () => UserRole.customer,
      ),
      status: UserStatus.values.firstWhere(
        (status) => status.toString().split('.').last == data['status'],
        orElse: () => UserStatus.pending,
      ),
      bio: data['bio'],
      location: data['location'],
      city: data['city'],
      categories: data['categories'] != null 
          ? List<String>.from(data['categories'])
          : null,
      preferences: data['preferences'],
      createdAt: data['createdAt'] != null 
          ? DateTime.parse(data['createdAt'])
          : DateTime.now(),
      updatedAt: data['updatedAt'] != null 
          ? DateTime.parse(data['updatedAt'])
          : DateTime.now(),
      lastLoginAt: data['lastLoginAt'] != null 
          ? DateTime.parse(data['lastLoginAt'])
          : null,
      isEmailVerified: data['isEmailVerified'] ?? false,
      isPhoneVerified: data['isPhoneVerified'] ?? false,
      profileCompleted: data['profileCompleted'] ?? false,
      metadata: data['metadata'],
    );
  }

  // Factory constructor to create UserModel from Firestore document
  factory UserModel.fromJson(Map<String, dynamic> data) {
    return UserModel(
      id: data['id'] ?? '',
      email: data['email'] ?? '',
      fullName: data['fullName'] ?? '',
      phoneNumber: data['phoneNumber'],
      profileImageUrl: data['profileImageUrl'],
      role: UserRole.values.firstWhere(
        (role) => role.toString().split('.').last == data['role'],
        orElse: () => UserRole.customer,
      ),
      status: UserStatus.values.firstWhere(
        (status) => status.toString().split('.').last == data['status'],
        orElse: () => UserStatus.pending,
      ),
      bio: data['bio'],
      location: data['location'],
      city: data['city'],
      categories: data['categories'] != null 
          ? List<String>.from(data['categories'])
          : null,
      preferences: data['preferences'],
      createdAt: data['createdAt'] != null 
          ? DateTime.parse(data['createdAt'].toString())
          : DateTime.now(),
      updatedAt: data['updatedAt'] != null 
          ? DateTime.parse(data['updatedAt'].toString())
          : DateTime.now(),
      lastLoginAt: data['lastLoginAt'] != null 
          ? DateTime.parse(data['lastLoginAt'].toString())
          : null,
      isEmailVerified: data['isEmailVerified'] ?? false,
      isPhoneVerified: data['isPhoneVerified'] ?? false,
      profileCompleted: data['profileCompleted'] ?? false,
      metadata: data['metadata'],
    );
  }

  // Convert UserModel to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'profileImageUrl': profileImageUrl,
      'role': role.toString().split('.').last,
      'status': status.toString().split('.').last,
      'bio': bio,
      'location': location,
      'city': city,
      'categories': categories,
      'preferences': preferences,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'lastLoginAt': lastLoginAt?.toIso8601String(),
      'isEmailVerified': isEmailVerified,
      'isPhoneVerified': isPhoneVerified,
      'profileCompleted': profileCompleted,
      'metadata': metadata,
    };
  }

  // Create a copy of UserModel with updated fields
  UserModel copyWith({
    String? id,
    String? email,
    String? fullName,
    String? phoneNumber,
    String? profileImageUrl,
    UserRole? role,
    UserStatus? status,
    String? bio,
    String? location,
    String? city,
    List<String>? categories,
    Map<String, dynamic>? preferences,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastLoginAt,
    bool? isEmailVerified,
    bool? isPhoneVerified,
    bool? profileCompleted,
    Map<String, dynamic>? metadata,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      role: role ?? this.role,
      status: status ?? this.status,
      bio: bio ?? this.bio,
      location: location ?? this.location,
      city: city ?? this.city,
      categories: categories ?? this.categories,
      preferences: preferences ?? this.preferences,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      isPhoneVerified: isPhoneVerified ?? this.isPhoneVerified,
      profileCompleted: profileCompleted ?? this.profileCompleted,
      metadata: metadata ?? this.metadata,
    );
  }

  // Check if user is an artist
  bool get isArtist => role == UserRole.artist;

  // Check if user is a customer
  bool get isCustomer => role == UserRole.customer;

  // Check if user is an agent
  bool get isAgent => role == UserRole.agent;

  // Check if user is an admin
  bool get isAdmin => role == UserRole.admin;

  // Check if user is verified
  bool get isVerified => status == UserStatus.verified;

  // Check if user is active
  bool get isActive => status == UserStatus.active;

  // Get display name (full name or email if full name is empty)
  String get displayName => fullName.isNotEmpty ? fullName : email;

  // Get initials for avatar
  String get initials {
    if (fullName.isEmpty) return email.substring(0, 2).toUpperCase();
    
    final names = fullName.split(' ');
    if (names.length >= 2) {
      return '${names[0][0]}${names[1][0]}'.toUpperCase();
    }
    return fullName.substring(0, 2).toUpperCase();
  }

  @override
  String toString() {
    return 'UserModel(id: $id, email: $email, fullName: $fullName, role: $role, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
} 