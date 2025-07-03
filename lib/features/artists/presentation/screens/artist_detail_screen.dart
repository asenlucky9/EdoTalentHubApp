import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../config/app_config.dart';
import '../../domain/models/artist.dart';
import '../../../booking/presentation/screens/booking_screen.dart';

class ArtistDetailScreen extends ConsumerStatefulWidget {
  final Artist? artist;
  
  const ArtistDetailScreen({super.key, this.artist});

  @override
  ConsumerState<ArtistDetailScreen> createState() => _ArtistDetailScreenState();
}

class _ArtistDetailScreenState extends ConsumerState<ArtistDetailScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isFavorite = false;

  // Mock artist data for demonstration
  late Artist _artist;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    
    // Use provided artist or create mock data
    _artist = widget.artist ?? Artist(
      id: '1',
      name: 'DJ Master K',
      category: 'DJ',
      location: 'Benin City',
      rating: 4.8,
      reviewCount: 127,
      price: 80000,
      imageUrl: 'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=400&h=300&fit=crop',
      bio: 'Professional DJ with over 5 years of experience specializing in Afrobeat, Hip-hop, R&B, and contemporary music. Known for creating unforgettable experiences at weddings, corporate events, and private parties across Edo State.',
      genres: ['Afrobeat', 'Hip-hop', 'R&B', 'Contemporary'],
      experience: '5 years',
      phone: '+234 801 234 5678',
      email: 'djmasterk@example.com',
      isVerified: true,
      isAvailable: true,
      portfolio: [
        'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=300&h=200&fit=crop',
        'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=300&h=200&fit=crop',
        'https://images.unsplash.com/photo-1516450360452-9312f5e86fc7?w=300&h=200&fit=crop',
      ],
      pricing: {
        'Wedding': 80000,
        'Corporate Event': 60000,
        'Birthday Party': 50000,
        'Private Party': 70000,
      },
      languages: ['English', 'Edo'],
      website: 'https://djmasterk.com',
      socialMedia: ['@djmasterk_ig', '@djmasterk_twitter'],
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConfig.backgroundColor,
      body: CustomScrollView(
        slivers: [
          // Custom App Bar with Artist Image
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: AppConfig.primaryColor,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Artist Image
                  Image.network(
                    _artist.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey[300],
                      child: Icon(
                        Icons.music_note,
                        color: Colors.grey[600],
                        size: 80,
                      ),
                    ),
                  ),
                  // Gradient Overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                  // Artist Info Overlay
                  Positioned(
                    bottom: 16,
                    left: 16,
                    right: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            if (_artist.isVerified)
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.verified,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            if (_artist.isVerified) const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _artist.name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  _isFavorite = !_isFavorite;
                                });
                              },
                              icon: Icon(
                                _isFavorite ? Icons.favorite : Icons.favorite_border,
                                color: _isFavorite ? Colors.red : Colors.white,
                                size: 28,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              _getCategoryIcon(_artist.category),
                              color: Colors.white,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${_artist.category} • ${_artist.location}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 20,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${_artist.rating} (${_artist.reviewCount} reviews)',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.share, color: Colors.white),
                onPressed: () {
                  // TODO: Implement share functionality
                },
              ),
            ],
          ),

          // Main Content
          SliverToBoxAdapter(
            child: Column(
              children: [
                // Quick Info Cards
                _buildQuickInfoCards(),
                
                // Tab Bar
                Container(
                  color: Colors.white,
                  child: TabBar(
                    controller: _tabController,
                    labelColor: AppConfig.primaryColor,
                    unselectedLabelColor: AppConfig.textSecondaryColor,
                    indicatorColor: AppConfig.primaryColor,
                    labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    tabs: const [
                      Tab(text: 'About'),
                      Tab(text: 'Videos'),
                      Tab(text: 'Reviews'),
                    ],
                  ),
                ),
                
                // Tab Content
                SizedBox(
                  height: 440,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildAboutTab(),
                      _buildVideosTab(),
                      _buildReviewsTab(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildQuickInfoCards() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: _buildInfoCard(
              'Experience',
              _artist.experience,
              Icons.work,
              AppConfig.primaryColor,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildInfoCard(
              'Languages',
              _artist.languages.join(', '),
              Icons.language,
              AppConfig.secondaryColor,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildInfoCard(
              'Starting Price',
              '₦${_formatPrice(_artist.price)}',
              Icons.attach_money,
              AppConfig.accentColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: AppConfig.cardShadow,
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: AppConfig.textSecondaryColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppConfig.textPrimaryColor,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildAboutTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppConfig.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _artist.bio,
            style: TextStyle(
              fontSize: 16,
              color: AppConfig.textPrimaryColor,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Icon(Icons.work, color: AppConfig.primaryColor, size: 20),
              const SizedBox(width: 8),
              Text('Experience: ', style: TextStyle(fontWeight: FontWeight.bold, color: AppConfig.textPrimaryColor)),
              Text(_artist.experience, style: TextStyle(color: AppConfig.textPrimaryColor)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.language, color: AppConfig.primaryColor, size: 20),
              const SizedBox(width: 8),
              Text('Languages: ', style: TextStyle(fontWeight: FontWeight.bold, color: AppConfig.textPrimaryColor)),
              Text(_artist.languages.join(', '), style: TextStyle(color: AppConfig.textPrimaryColor)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.email, color: AppConfig.primaryColor, size: 20),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Email: ${_artist.email ?? 'Not available'}')),
                  );
                },
                child: Text(_artist.email ?? 'Not available', style: TextStyle(color: AppConfig.primaryColor, decoration: TextDecoration.underline)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.phone, color: AppConfig.primaryColor, size: 20),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Phone: ${_artist.phone ?? 'Not available'}')),
                  );
                },
                child: Text(_artist.phone ?? 'Not available', style: TextStyle(color: AppConfig.primaryColor, decoration: TextDecoration.underline)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (_artist.website?.isNotEmpty == true) ...[
            Row(
              children: [
                Icon(Icons.link, color: AppConfig.primaryColor, size: 20),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Website: ${_artist.website}')),
                    );
                  },
                  child: Text(_artist.website!, style: TextStyle(color: AppConfig.primaryColor, decoration: TextDecoration.underline)),
                ),
              ],
            ),
            const SizedBox(height: 12),
          ],
          if (_artist.socialMedia.isNotEmpty) ...[
            Row(
              children: [
                Icon(Icons.share, color: AppConfig.primaryColor, size: 20),
                const SizedBox(width: 8),
                ..._artist.socialMedia.map((handle) => Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Social: $handle')),
                      );
                    },
                    child: Text(handle, style: TextStyle(color: AppConfig.primaryColor, decoration: TextDecoration.underline)),
                  ),
                )),
              ],
            ),
            const SizedBox(height: 12),
          ],
          // Genres
          Text(
            'Genres',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppConfig.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _artist.genres.map((genre) => Chip(
              label: Text(genre),
              backgroundColor: AppConfig.primaryColor.withOpacity(0.1),
              labelStyle: TextStyle(color: AppConfig.primaryColor),
            )).toList(),
          ),
          const SizedBox(height: 24),
          // Pricing
          Text(
            'Pricing',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppConfig.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 12),
          ..._artist.pricing.entries.map((entry) => Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  entry.key,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppConfig.textPrimaryColor,
                  ),
                ),
                Text(
                  '₦${_formatPrice(entry.value)}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppConfig.primaryColor,
                  ),
                ),
              ],
            ),
          )).toList(),
        ],
      ),
    );
  }

  Widget _buildVideosTab() {
    // Mock video thumbnails (replace with real video widgets later)
    final List<String> videoThumbs = [
      'https://img.youtube.com/vi/dQw4w9WgXcQ/0.jpg',
      'https://img.youtube.com/vi/3JZ_D3ELwOQ/0.jpg',
      'https://img.youtube.com/vi/L_jWHffIx5E/0.jpg',
    ];
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Videos',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppConfig.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.3,
            ),
            itemCount: videoThumbs.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Open video player (not implemented)')),
                  );
                },
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        videoThumbs[index],
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: Colors.grey[300],
                          child: Icon(
                            Icons.videocam,
                            color: Colors.grey[600],
                            size: 40,
                          ),
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.center,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black45,
                            shape: BoxShape.circle,
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(Icons.play_arrow, color: Colors.white, size: 32),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Reviews',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppConfig.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 16),
          
          // Mock reviews
          _buildReviewItem('John Doe', 5.0, 'Amazing DJ! Made our wedding unforgettable.', '2 days ago'),
          _buildReviewItem('Jane Smith', 4.5, 'Great music selection and professional service.', '1 week ago'),
          _buildReviewItem('Mike Johnson', 5.0, 'Highly recommended for any event!', '2 weeks ago'),
        ],
      ),
    );
  }

  Widget _buildReviewItem(String name, double rating, String comment, String date) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: AppConfig.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: AppConfig.primaryColor,
                child: Text(
                  name[0],
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppConfig.textPrimaryColor,
                      ),
                    ),
                    Row(
                      children: [
                        ...List.generate(5, (index) => Icon(
                          Icons.star,
                          color: index < rating ? Colors.amber : Colors.grey[300],
                          size: 16,
                        )),
                        const SizedBox(width: 8),
                        Text(
                          date,
                          style: TextStyle(
                            fontSize: 12,
                            color: AppConfig.textSecondaryColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            comment,
            style: TextStyle(
              fontSize: 14,
              color: AppConfig.textPrimaryColor,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Starting from',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppConfig.textSecondaryColor,
                  ),
                ),
                Text(
                  '₦${_formatPrice(_artist.price)}',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppConfig.primaryColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: _artist.isAvailable ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookingScreen(artist: _artist),
                  ),
                );
              } : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConfig.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                _artist.isAvailable ? 'Book Now' : 'Not Available',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'dj':
        return Icons.headphones;
      case 'mc':
        return Icons.mic;
      case 'musician':
        return Icons.music_note;
      case 'cultural group':
        return Icons.celebration;
      case 'photographer':
        return Icons.camera_alt;
      case 'videographer':
        return Icons.videocam;
      default:
        return Icons.music_note;
    }
  }

  String _formatPrice(double price) {
    if (price >= 1000000) {
      return '${(price / 1000000).toStringAsFixed(1)}M';
    } else if (price >= 1000) {
      return '${(price / 1000).toStringAsFixed(0)}K';
    } else {
      return price.toStringAsFixed(0);
    }
  }
} 