import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../config/app_config.dart';
import '../../../artists/presentation/screens/artist_detail_screen.dart';
import '../../../artists/domain/models/artist.dart';
import '../../../search/presentation/screens/search_screen.dart';
import '../../../artists/presentation/screens/category_artists_screen.dart';
import '../../../booking/presentation/screens/booking_screen.dart';
import '../../../../shared/providers/user_provider.dart';
import '../widgets/user_quick_actions.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();

  // Example images for demo (replace with real Edo musicians later)
  final List<String> _artistImages = [
    'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?w=400&h=300&fit=crop', // DJ
    'https://images.unsplash.com/photo-1464983953574-0892a716854b?w=400&h=300&fit=crop', // MC
    'https://images.unsplash.com/photo-1506744038136-46273834b3fb?w=400&h=300&fit=crop', // Cultural Group
    'https://images.unsplash.com/photo-1515378791036-0648a3ef77b2?w=400&h=300&fit=crop', // Photographer
    'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=400&h=300&fit=crop', // Videographer
    'https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?w=400&h=300&fit=crop', // Musician
    'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?w=400&h=300&fit=crop', // Musician 2
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    final greeting = _getGreeting();
    final userName = user?.fullName.split(' ').first ?? 'there';
    
    return Scaffold(
      backgroundColor: const Color(0xFFFAFBFC),
      body: RefreshIndicator(
        onRefresh: () async {
          // Simulate refresh
          await Future.delayed(const Duration(seconds: 1));
          setState(() {
            // Refresh the UI
          });
        },
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            // Professional Header with Edo Cultural Elements
            SliverAppBar(
              expandedHeight: 220,
              floating: false,
              pinned: true,
              backgroundColor: AppConfig.primaryColor,
              elevation: 0,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF1B5E20),
                        Color(0xFF2E7D32),
                        Color(0xFF388E3C),
                      ],
                    ),
                  ),
                  child: SafeArea(
          child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
              children: [
                          Row(
                            children: [
                Container(
                                padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.celebration,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                                      'EdoTalentHub',
                        style: TextStyle(
                          color: Colors.white,
                                        fontSize: 24,
                          fontWeight: FontWeight.bold,
                                        letterSpacing: 0.5,
                        ),
                      ),
                                    const SizedBox(height: 4),
                      Text(
                                      'Professional Entertainment Booking Platform',
                        style: TextStyle(
                                        color: Colors.white.withOpacity(0.9),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Trust Badge
                      Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.verified,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Verified',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          
                          // Personalized Welcome Message
                          Text(
                            '$greeting, $userName! 👋',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Ready to find the perfect talent for your event?',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 20),
                          
                          // Enhanced Search Bar with Cultural Elements
                          Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 20,
                                  offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: _searchController,
                          readOnly: true,
                              onTap: () async {
                                HapticFeedback.lightImpact();
                                setState(() {
                                  _searchController.text = 'Searching...';
                                });
                                await Future.delayed(const Duration(milliseconds: 300));
                                setState(() {
                                  _searchController.clear();
                                });
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SearchScreen(),
                              ),
                            );
                          },
                          decoration: InputDecoration(
                                hintText: 'Search for Edo talents, events, cultural groups...',
                                hintStyle: TextStyle(
                                  color: Colors.grey[500],
                                  fontSize: 15,
                                ),
                            border: InputBorder.none,
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: AppConfig.primaryColor,
                                  size: 22,
                                ),
                                suffixIcon: Container(
                                  margin: const EdgeInsets.all(8),
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: AppConfig.primaryColor,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Text(
                                    'Search',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Flexible(child: _buildPromoBanner()),
                    ],
                  ),
                ),
                  ),
                ),
              ),
            ),
            
            // Main Content
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    // Enhanced Quick Stats Section with Trust Indicators
                    _buildQuickStatsSection(),
                    const SizedBox(height: 32),
                    
                    // Cultural Events Banner
                    _buildCulturalEventsBanner(),
                    const SizedBox(height: 32),
                    
                    // Enhanced Categories Section
                    _buildCategoriesSection(),
                    const SizedBox(height: 40),
                    
                    // Featured Artists Section with Quality Badges
                    _buildEnhancedFeaturedArtistsSection(),
                    const SizedBox(height: 40),
                    
                    // Trust & Quality Section
                    _buildTrustQualitySection(),
                    const SizedBox(height: 40),
                    
                    // User Quick Actions Section
                    const UserQuickActions(),
                    const SizedBox(height: 32),
                    
                    // Enhanced Quick Actions Section
                    _buildEnhancedQuickActionsSection(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStatsSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white,
            const Color(0xFFF8F9FA),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  '500+',
                  'Verified Artists',
                  Icons.verified_user,
                  AppConfig.primaryColor,
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: Colors.grey.withOpacity(0.2),
              ),
              Expanded(
                child: _buildStatItem(
                  '1000+',
                  'Successful Events',
                  Icons.event_available,
                  AppConfig.secondaryColor,
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: Colors.grey.withOpacity(0.2),
              ),
              Expanded(
                child: _buildStatItem(
                  '4.8',
                  'Customer Rating',
                  Icons.star,
                  AppConfig.accentColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppConfig.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.security,
                  color: AppConfig.primaryColor,
                  size: 16,
                ),
                const SizedBox(width: 8),
                      Text(
                  'Escrow Protected Payments • Professional Contracts • Quality Guaranteed',
                        style: TextStyle(
                    color: AppConfig.primaryColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
                      ),
                    ],
                  ),
    );
  }

  Widget _buildCulturalEventsBanner() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppConfig.secondaryColor,
            AppConfig.secondaryColor.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppConfig.secondaryColor.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.celebration,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Edo Cultural Events',
                    style: TextStyle(
                    color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Igue Festival • Traditional Weddings • Cultural Performances',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                  ),
                ),
                    ],
                  ),
                ),
          Icon(
            Icons.arrow_forward_ios,
            color: Colors.white,
            size: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                  'Browse Categories',
                        style: TextStyle(
                    fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppConfig.textPrimaryColor,
                        ),
                      ),
                Text(
                  'Find the right talent for your event',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppConfig.textSecondaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                      ),
                    ],
                  ),
            TextButton(
              onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SearchScreen(),
                          ),
                        );
              },
              child: Text(
                'View All',
                style: TextStyle(
                  color: AppConfig.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _buildCategoryIcon(Icons.music_note, 'Musicians / Bands', AppConfig.primaryColor),
            _buildCategoryIcon(Icons.headphones, 'DJs', AppConfig.secondaryColor),
            _buildCategoryIcon(Icons.mic, 'MCs / Comedians', AppConfig.accentColor),
            _buildCategoryIcon(Icons.celebration, 'Cultural Dance Groups', Colors.purple),
            _buildCategoryIcon(Icons.videocam, 'Videographers', Colors.teal),
            _buildCategoryIcon(Icons.location_city, 'Event Venues', Colors.blue),
            _buildCategoryIcon(Icons.speaker, 'Equipment Rentals', Colors.orange),
            _buildCategoryIcon(Icons.more_horiz, 'Others', Colors.grey),
          ],
        ),
      ],
    );
  }

  Widget _buildCategoryIcon(IconData icon, String label, Color color) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoryArtistsScreen(category: label),
          ),
        );
      },
      child: Container(
        width: 80,
        child: Column(
          children: [
            Container(
              width: 60,
              height: 60,
        decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                icon,
                color: color,
                size: 28,
              ),
            ),
            const SizedBox(height: 8),
              Text(
              label,
                style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                  color: AppConfig.textPrimaryColor,
                ),
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String value, String label, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppConfig.textPrimaryColor,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: AppConfig.textSecondaryColor,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildEnhancedFeaturedArtistsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Featured Artists',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppConfig.textPrimaryColor,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SearchScreen(),
                  ),
                );
              },
              child: Text(
                'View All',
          style: TextStyle(
                  color: AppConfig.primaryColor,
            fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 260,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(right: 24),
            children: [
              _buildFeaturedArtistCard(_getArtistsForCategory('DJs')[0]),
              _buildFeaturedArtistCard(_getArtistsForCategory('MCs')[0]),
              _buildFeaturedArtistCard(_getArtistsForCategory('Cultural Groups')[0]),
              _buildFeaturedArtistCard(_getArtistsForCategory('Photographers')[0]),
              _buildFeaturedArtistCard(_getArtistsForCategory('Musicians')[0]),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturedArtistCard(Artist artist) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ArtistDetailScreen(artist: artist),
          ),
        );
      },
      child: Container(
        width: 200,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
              child: Stack(
                children: [
                  Image.network(
              artist.imageUrl,
              height: 110,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 12,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            artist.rating.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.verified,
                            color: Colors.white,
                            size: 12,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Verified',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  artist.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: AppConfig.textPrimaryColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  artist.category,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppConfig.textSecondaryColor,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      artist.rating.toString(),
                      style: TextStyle(
                        fontSize: 12,
                        color: AppConfig.textSecondaryColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  '₦${_formatPrice(artist.price)}',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppConfig.primaryColor,
                  ),
                ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BookingScreen(artist: artist),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppConfig.primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Book Now',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                  ),
                ),
              ],
                  ),
                ),
            ),
          ),
        ],
        ),
      ),
    );
  }

  Widget _buildTrustQualitySection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppConfig.primaryColor.withOpacity(0.05),
            AppConfig.secondaryColor.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppConfig.primaryColor.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Why Choose EdoTalentHub?',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppConfig.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 20),
          _buildTrustItem('Escrow Protection', 'Secure payments held until service completion', Icons.security),
          const SizedBox(height: 16),
          _buildTrustItem('Professional Contracts', 'Legally binding agreements for all parties', Icons.description),
          const SizedBox(height: 16),
          _buildTrustItem('Quality Guarantee', 'Verified artists with performance standards', Icons.verified_user),
          const SizedBox(height: 16),
          _buildTrustItem('24/7 Support', 'Professional agent mediation and support', Icons.support_agent),
        ],
      ),
    );
  }

  Widget _buildTrustItem(String title, String description, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppConfig.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: AppConfig.primaryColor,
            size: 20,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppConfig.textPrimaryColor,
                ),
              ),
              Text(
                description,
                style: TextStyle(
                  fontSize: 14,
                  color: AppConfig.textSecondaryColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEnhancedQuickActionsSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppConfig.primaryColor.withOpacity(0.05),
            AppConfig.secondaryColor.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppConfig.primaryColor.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppConfig.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildQuickActionCard(
                  'Book an Artist',
                  Icons.event_available,
                  AppConfig.primaryColor,
                  'Find and book verified Edo talents for your events',
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SearchScreen(),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildQuickActionCard(
                  'Cultural Events',
                  Icons.celebration,
                  AppConfig.secondaryColor,
                  'Discover traditional Edo festivals and celebrations',
                  () {
                    // TODO: Navigate to cultural events
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildQuickActionCard(
                  'Become an Artist',
                  Icons.person_add,
                  Colors.purple,
                  'Join our platform as a verified Edo talent',
                  () {
                    // TODO: Navigate to artist registration
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildQuickActionCard(
                  'Contact Support',
                  Icons.support_agent,
                  Colors.blue,
                  'Get professional assistance and guidance',
                  () {
                    // TODO: Navigate to support
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionCard(String title, IconData icon, Color color, String description, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.2)),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppConfig.textPrimaryColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(
                fontSize: 12,
                color: AppConfig.textSecondaryColor,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Text(
                  'Get Started',
                  style: TextStyle(
                    fontSize: 12,
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.arrow_forward_ios,
                  color: color,
                  size: 12,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<Artist> _getArtistsForCategory(String category) {
    switch (category) {
      case 'Musicians':
        return [
          Artist(
            id: 'm1',
            name: 'Guitar Master',
            category: 'Musician',
            location: 'Benin City',
            rating: 4.7,
            reviewCount: 89,
            price: 60000,
            imageUrl: _artistImages[5],
            bio: 'Professional guitarist with 8+ years experience.',
            genres: ['Jazz', 'Blues', 'Rock'],
            experience: '8 years',
          ),
          Artist(
            id: 'm2',
            name: 'Piano Virtuoso',
            category: 'Musician',
            location: 'Ekpoma',
            rating: 4.9,
            reviewCount: 156,
            price: 75000,
            imageUrl: _artistImages[6],
            bio: 'Classical and contemporary piano specialist.',
            genres: ['Classical', 'Contemporary', 'Jazz'],
            experience: '12 years',
          ),
          Artist(
            id: 'm3',
            name: 'Drum Master',
            category: 'Musician',
            location: 'Auchi',
            rating: 4.5,
            reviewCount: 67,
            price: 45000,
            imageUrl: _artistImages[5],
            bio: 'Professional drummer for all occasions.',
            genres: ['Rock', 'Jazz', 'Afrobeat'],
            experience: '6 years',
          ),
        ];
      case 'DJs':
        return [
          Artist(
            id: 'dj1',
            name: 'DJ Master K',
            category: 'DJ',
            location: 'Benin City',
            rating: 4.8,
            reviewCount: 127,
            price: 80000,
            imageUrl: _artistImages[0],
            bio: 'Professional DJ with 5+ years experience.',
            genres: ['Afrobeat', 'Hip-hop', 'R&B'],
            experience: '5 years',
          ),
          Artist(
            id: 'dj2',
            name: 'DJ Afro',
            category: 'DJ',
            location: 'Uromi',
            rating: 4.6,
            reviewCount: 94,
            price: 65000,
            imageUrl: _artistImages[0],
            bio: 'Afrobeat specialist DJ.',
            genres: ['Afrobeat', 'Highlife', 'Juju'],
            experience: '7 years',
          ),
          Artist(
            id: 'dj3',
            name: 'DJ Mix',
            category: 'DJ',
            location: 'Irrua',
            rating: 4.4,
            reviewCount: 78,
            price: 55000,
            imageUrl: _artistImages[0],
            bio: 'Versatile DJ for all events.',
            genres: ['Pop', 'Hip-hop', 'Electronic'],
            experience: '4 years',
          ),
        ];
      case 'MCs':
        return [
          Artist(
            id: 'mc1',
            name: 'MC Bright',
            category: 'MC',
            location: 'Ekpoma',
            rating: 4.2,
            reviewCount: 89,
            price: 30000,
            imageUrl: _artistImages[1],
            bio: 'Dynamic MC for weddings and events.',
            genres: ['Wedding MC', 'Corporate Events'],
            experience: '3 years',
          ),
          Artist(
            id: 'mc2',
            name: 'MC Smooth',
            category: 'MC',
            location: 'Benin City',
            rating: 4.5,
            reviewCount: 112,
            price: 40000,
            imageUrl: _artistImages[1],
            bio: 'Professional MC with smooth delivery.',
            genres: ['Weddings', 'Parties', 'Corporate'],
            experience: '5 years',
          ),
          Artist(
            id: 'mc3',
            name: 'MC Energy',
            category: 'MC',
            location: 'Abudu',
            rating: 4.3,
            reviewCount: 67,
            price: 35000,
            imageUrl: _artistImages[1],
            bio: 'High-energy MC for lively events.',
            genres: ['Parties', 'Concerts', 'Festivals'],
            experience: '4 years',
          ),
        ];
      case 'Cultural Groups':
        return [
          Artist(
            id: 'cg1',
            name: 'Cultural Group Edo',
            category: 'Cultural Group',
            location: 'Benin City',
            rating: 4.9,
            reviewCount: 156,
            price: 150000,
            imageUrl: _artistImages[2],
            bio: 'Traditional Edo cultural performances.',
            genres: ['Traditional', 'Cultural', 'Festival'],
            experience: '10+ years',
          ),
          Artist(
            id: 'cg2',
            name: 'Edo Heritage',
            category: 'Cultural Group',
            location: 'Ekpoma',
            rating: 4.7,
            reviewCount: 98,
            price: 120000,
            imageUrl: _artistImages[2],
            bio: 'Preserving Edo cultural heritage.',
            genres: ['Traditional', 'Heritage', 'Ceremonial'],
            experience: '8 years',
          ),
          Artist(
            id: 'cg3',
            name: 'Royal Performers',
            category: 'Cultural Group',
            location: 'Auchi',
            rating: 4.6,
            reviewCount: 87,
            price: 100000,
            imageUrl: _artistImages[2],
            bio: 'Royal cultural performances.',
            genres: ['Royal', 'Traditional', 'Ceremonial'],
            experience: '6 years',
          ),
        ];
      case 'Photographers':
        return [
          Artist(
            id: 'p1',
            name: 'Photographer Pro',
            category: 'Photographer',
            location: 'Auchi',
            rating: 4.6,
            reviewCount: 94,
            price: 45000,
            imageUrl: _artistImages[3],
            bio: 'Professional photographer for events.',
            genres: ['Events', 'Portraits', 'Weddings'],
            experience: '4 years',
          ),
          Artist(
            id: 'p2',
            name: 'Lens Master',
            category: 'Photographer',
            location: 'Benin City',
            rating: 4.8,
            reviewCount: 134,
            price: 60000,
            imageUrl: _artistImages[3],
            bio: 'Creative photographer with artistic vision.',
            genres: ['Creative', 'Portraits', 'Events'],
            experience: '7 years',
          ),
          Artist(
            id: 'p3',
            name: 'Wedding Lens',
            category: 'Photographer',
            location: 'Uromi',
            rating: 4.5,
            reviewCount: 89,
            price: 50000,
            imageUrl: _artistImages[3],
            bio: 'Specialized in wedding photography.',
            genres: ['Weddings', 'Engagements', 'Portraits'],
            experience: '5 years',
          ),
        ];
      default:
        return [
          Artist(
            id: 'default',
            name: 'Artist',
            category: category,
            location: 'Benin City',
            rating: 4.5,
            reviewCount: 50,
            price: 50000,
            imageUrl: _artistImages[4],
            bio: 'Professional artist in $category.',
            genres: ['Professional', 'Experienced'],
            experience: '3 years',
          ),
        ];
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

  Widget _buildPromoBanner() {
    return Container(
      constraints: const BoxConstraints(maxHeight: 48),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppConfig.primaryColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
          children: [
          Icon(Icons.campaign, color: Colors.white, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Cultural Festival Special: 20% off bookings for cultural performances!',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
      ),
    );
  }
} 