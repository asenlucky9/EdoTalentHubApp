class Artist {
  final String id;
  final String name;
  final String category;
  final String location;
  final double rating;
  final int reviewCount;
  final double price;
  final String imageUrl;
  final String bio;
  final List<String> genres;
  final String experience;
  final String? phone;
  final String? email;
  final bool isVerified;
  final bool isAvailable;
  final List<String> portfolio;
  final Map<String, double> pricing;
  final List<String> languages;
  final String? website;
  final List<String> socialMedia;
  final DateTime createdAt;
  final DateTime updatedAt;

  Artist({
    required this.id,
    required this.name,
    required this.category,
    required this.location,
    required this.rating,
    required this.reviewCount,
    required this.price,
    required this.imageUrl,
    required this.bio,
    required this.genres,
    required this.experience,
    this.phone,
    this.email,
    this.isVerified = false,
    this.isAvailable = true,
    this.portfolio = const [],
    this.pricing = const {},
    this.languages = const ['English'],
    this.website,
    this.socialMedia = const [],
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  factory Artist.fromJson(Map<String, dynamic> json) {
    return Artist(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      location: json['location'] as String,
      rating: (json['rating'] as num).toDouble(),
      reviewCount: json['reviewCount'] as int,
      price: (json['price'] as num).toDouble(),
      imageUrl: json['imageUrl'] as String,
      bio: json['bio'] as String,
      genres: List<String>.from(json['genres'] ?? []),
      experience: json['experience'] as String,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      isVerified: json['isVerified'] as bool? ?? false,
      isAvailable: json['isAvailable'] as bool? ?? true,
      portfolio: List<String>.from(json['portfolio'] ?? []),
      pricing: Map<String, double>.from(json['pricing'] ?? {}),
      languages: List<String>.from(json['languages'] ?? ['English']),
      website: json['website'] as String?,
      socialMedia: List<String>.from(json['socialMedia'] ?? []),
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null 
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'location': location,
      'rating': rating,
      'reviewCount': reviewCount,
      'price': price,
      'imageUrl': imageUrl,
      'bio': bio,
      'genres': genres,
      'experience': experience,
      'phone': phone,
      'email': email,
      'isVerified': isVerified,
      'isAvailable': isAvailable,
      'portfolio': portfolio,
      'pricing': pricing,
      'languages': languages,
      'website': website,
      'socialMedia': socialMedia,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  Artist copyWith({
    String? id,
    String? name,
    String? category,
    String? location,
    double? rating,
    int? reviewCount,
    double? price,
    String? imageUrl,
    String? bio,
    List<String>? genres,
    String? experience,
    String? phone,
    String? email,
    bool? isVerified,
    bool? isAvailable,
    List<String>? portfolio,
    Map<String, double>? pricing,
    List<String>? languages,
    String? website,
    List<String>? socialMedia,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Artist(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      location: location ?? this.location,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      bio: bio ?? this.bio,
      genres: genres ?? this.genres,
      experience: experience ?? this.experience,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      isVerified: isVerified ?? this.isVerified,
      isAvailable: isAvailable ?? this.isAvailable,
      portfolio: portfolio ?? this.portfolio,
      pricing: pricing ?? this.pricing,
      languages: languages ?? this.languages,
      website: website ?? this.website,
      socialMedia: socialMedia ?? this.socialMedia,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Artist && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Artist(id: $id, name: $name, category: $category, location: $location)';
  }
} 