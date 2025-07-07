// import 'package:cloud_firestore/cloud_firestore.dart';

enum ArtistCategory {
  musician,
  dj,
  mc,
  culturalGroup,
  videographer,
  photographer,
  soundEngineer,
  eventPlanner,
  caterer,
  decorator,
}

enum ArtistStatus {
  available,
  busy,
  unavailable,
  onBreak,
}

class ArtistProfileModel {
  final String id;
  final String userId;
  final String stageName;
  final String? realName;
  final List<ArtistCategory> categories;
  final String bio;
  final String? location;
  final String? city;
  final String? state;
  final String? country;
  final double? latitude;
  final double? longitude;
  final List<String> skills;
  final List<String> languages;
  final List<String> instruments; // For musicians
  final List<String> musicGenres; // For musicians and DJs
  final List<String> eventTypes;
  final Map<String, double> pricing; // Event type -> Price
  final String? currency;
  final int experienceYears;
  final List<String> certifications;
  final List<String> awards;
  final List<String> portfolioImages;
  final List<String> portfolioVideos;
  final List<String> audioSamples;
  final String? profileImageUrl;
  final String? coverImageUrl;
  final ArtistStatus status;
  final bool isVerified;
  final bool isFeatured;
  final double rating;
  final int totalReviews;
  final int totalBookings;
  final int totalEvents;
  final Map<String, dynamic>? socialMedia;
  final Map<String, dynamic>? equipment;
  final Map<String, dynamic>? availability;
  final List<String>? tags;
  final Map<String, dynamic>? metadata;
  final DateTime createdAt;
  final DateTime updatedAt;

  ArtistProfileModel({
    required this.id,
    required this.userId,
    required this.stageName,
    this.realName,
    required this.categories,
    required this.bio,
    this.location,
    this.city,
    this.state,
    this.country,
    this.latitude,
    this.longitude,
    required this.skills,
    required this.languages,
    required this.instruments,
    required this.musicGenres,
    required this.eventTypes,
    required this.pricing,
    this.currency,
    required this.experienceYears,
    required this.certifications,
    required this.awards,
    required this.portfolioImages,
    required this.portfolioVideos,
    required this.audioSamples,
    this.profileImageUrl,
    this.coverImageUrl,
    required this.status,
    required this.isVerified,
    required this.isFeatured,
    required this.rating,
    required this.totalReviews,
    required this.totalBookings,
    required this.totalEvents,
    this.socialMedia,
    this.equipment,
    this.availability,
    this.tags,
    this.metadata,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory constructor to create ArtistProfileModel from Firestore document
  factory ArtistProfileModel.fromFirestore(dynamic doc) {
    final data = doc.data() as Map<String, dynamic>;
    
    return ArtistProfileModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      stageName: data['stageName'] ?? '',
      realName: data['realName'],
      categories: (data['categories'] as List<dynamic>? ?? [])
          .map((category) => ArtistCategory.values.firstWhere(
                (cat) => cat.toString().split('.').last == category,
                orElse: () => ArtistCategory.musician,
              ))
          .toList(),
      bio: data['bio'] ?? '',
      location: data['location'],
      city: data['city'],
      state: data['state'],
      country: data['country'],
      latitude: data['latitude']?.toDouble(),
      longitude: data['longitude']?.toDouble(),
      skills: List<String>.from(data['skills'] ?? []),
      languages: List<String>.from(data['languages'] ?? []),
      instruments: List<String>.from(data['instruments'] ?? []),
      musicGenres: List<String>.from(data['musicGenres'] ?? []),
      eventTypes: List<String>.from(data['eventTypes'] ?? []),
      pricing: Map<String, double>.from(data['pricing'] ?? {}),
      currency: data['currency'] ?? 'NGN',
      experienceYears: data['experienceYears'] ?? 0,
      certifications: List<String>.from(data['certifications'] ?? []),
      awards: List<String>.from(data['awards'] ?? []),
      portfolioImages: List<String>.from(data['portfolioImages'] ?? []),
      portfolioVideos: List<String>.from(data['portfolioVideos'] ?? []),
      audioSamples: List<String>.from(data['audioSamples'] ?? []),
      profileImageUrl: data['profileImageUrl'],
      coverImageUrl: data['coverImageUrl'],
      status: ArtistStatus.values.firstWhere(
        (status) => status.toString().split('.').last == data['status'],
        orElse: () => ArtistStatus.available,
      ),
      isVerified: data['isVerified'] ?? false,
      isFeatured: data['isFeatured'] ?? false,
      rating: (data['rating'] ?? 0.0).toDouble(),
      totalReviews: data['totalReviews'] ?? 0,
      totalBookings: data['totalBookings'] ?? 0,
      totalEvents: data['totalEvents'] ?? 0,
      socialMedia: data['socialMedia'],
      equipment: data['equipment'],
      availability: data['availability'],
      tags: data['tags'] != null ? List<String>.from(data['tags']) : null,
      metadata: data['metadata'],
      createdAt: (data['createdAt'] as dynamic).toDate(),
      updatedAt: (data['updatedAt'] as dynamic).toDate(),
    );
  }

  // Convert ArtistProfileModel to Map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'stageName': stageName,
      'realName': realName,
      'categories': categories.map((cat) => cat.toString().split('.').last).toList(),
      'bio': bio,
      'location': location,
      'city': city,
      'state': state,
      'country': country,
      'latitude': latitude,
      'longitude': longitude,
      'skills': skills,
      'languages': languages,
      'instruments': instruments,
      'musicGenres': musicGenres,
      'eventTypes': eventTypes,
      'pricing': pricing,
      'currency': currency,
      'experienceYears': experienceYears,
      'certifications': certifications,
      'awards': awards,
      'portfolioImages': portfolioImages,
      'portfolioVideos': portfolioVideos,
      'audioSamples': audioSamples,
      'profileImageUrl': profileImageUrl,
      'coverImageUrl': coverImageUrl,
      'status': status.toString().split('.').last,
      'isVerified': isVerified,
      'isFeatured': isFeatured,
      'rating': rating,
      'totalReviews': totalReviews,
      'totalBookings': totalBookings,
      'totalEvents': totalEvents,
      'socialMedia': socialMedia,
      'equipment': equipment,
      'availability': availability,
      'tags': tags,
      'metadata': metadata,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  // Create a copy of ArtistProfileModel with updated fields
  ArtistProfileModel copyWith({
    String? id,
    String? userId,
    String? stageName,
    String? realName,
    List<ArtistCategory>? categories,
    String? bio,
    String? location,
    String? city,
    String? state,
    String? country,
    double? latitude,
    double? longitude,
    List<String>? skills,
    List<String>? languages,
    List<String>? instruments,
    List<String>? musicGenres,
    List<String>? eventTypes,
    Map<String, double>? pricing,
    String? currency,
    int? experienceYears,
    List<String>? certifications,
    List<String>? awards,
    List<String>? portfolioImages,
    List<String>? portfolioVideos,
    List<String>? audioSamples,
    String? profileImageUrl,
    String? coverImageUrl,
    ArtistStatus? status,
    bool? isVerified,
    bool? isFeatured,
    double? rating,
    int? totalReviews,
    int? totalBookings,
    int? totalEvents,
    Map<String, dynamic>? socialMedia,
    Map<String, dynamic>? equipment,
    Map<String, dynamic>? availability,
    List<String>? tags,
    Map<String, dynamic>? metadata,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ArtistProfileModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      stageName: stageName ?? this.stageName,
      realName: realName ?? this.realName,
      categories: categories ?? this.categories,
      bio: bio ?? this.bio,
      location: location ?? this.location,
      city: city ?? this.city,
      state: state ?? this.state,
      country: country ?? this.country,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      skills: skills ?? this.skills,
      languages: languages ?? this.languages,
      instruments: instruments ?? this.instruments,
      musicGenres: musicGenres ?? this.musicGenres,
      eventTypes: eventTypes ?? this.eventTypes,
      pricing: pricing ?? this.pricing,
      currency: currency ?? this.currency,
      experienceYears: experienceYears ?? this.experienceYears,
      certifications: certifications ?? this.certifications,
      awards: awards ?? this.awards,
      portfolioImages: portfolioImages ?? this.portfolioImages,
      portfolioVideos: portfolioVideos ?? this.portfolioVideos,
      audioSamples: audioSamples ?? this.audioSamples,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
      status: status ?? this.status,
      isVerified: isVerified ?? this.isVerified,
      isFeatured: isFeatured ?? this.isFeatured,
      rating: rating ?? this.rating,
      totalReviews: totalReviews ?? this.totalReviews,
      totalBookings: totalBookings ?? this.totalBookings,
      totalEvents: totalEvents ?? this.totalEvents,
      socialMedia: socialMedia ?? this.socialMedia,
      equipment: equipment ?? this.equipment,
      availability: availability ?? this.availability,
      tags: tags ?? this.tags,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Get display name (stage name or real name)
  String get displayName => stageName.isNotEmpty ? stageName : (realName ?? 'Unknown Artist');

  // Get primary category
  ArtistCategory get primaryCategory => categories.isNotEmpty ? categories.first : ArtistCategory.musician;

  // Get primary category name
  String get primaryCategoryName => primaryCategory.toString().split('.').last;

  // Get all category names
  List<String> get categoryNames => categories.map((cat) => cat.toString().split('.').last).toList();

  // Get average price
  double get averagePrice {
    if (pricing.isEmpty) return 0.0;
    return pricing.values.reduce((a, b) => a + b) / pricing.length;
  }

  // Get minimum price
  double get minimumPrice {
    if (pricing.isEmpty) return 0.0;
    return pricing.values.reduce((a, b) => a < b ? a : b);
  }

  // Get maximum price
  double get maximumPrice {
    if (pricing.isEmpty) return 0.0;
    return pricing.values.reduce((a, b) => a > b ? a : b);
  }

  // Check if artist is available
  bool get isAvailable => status == ArtistStatus.available;

  // Check if artist is busy
  bool get isBusy => status == ArtistStatus.busy;

  // Get formatted location
  String get formattedLocation {
    final parts = <String>[];
    if (city != null && city!.isNotEmpty) parts.add(city!);
    if (state != null && state!.isNotEmpty) parts.add(state!);
    if (country != null && country!.isNotEmpty) parts.add(country!);
    return parts.join(', ');
  }

  // Get experience level
  String get experienceLevel {
    if (experienceYears < 1) return 'Beginner';
    if (experienceYears < 3) return 'Intermediate';
    if (experienceYears < 5) return 'Experienced';
    if (experienceYears < 10) return 'Professional';
    return 'Expert';
  }

  // Get rating display
  String get ratingDisplay => rating.toStringAsFixed(1);

  // Get total portfolio items
  int get totalPortfolioItems => portfolioImages.length + portfolioVideos.length + audioSamples.length;

  @override
  String toString() {
    return 'ArtistProfileModel(id: $id, stageName: $stageName, categories: $categories, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ArtistProfileModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
} 