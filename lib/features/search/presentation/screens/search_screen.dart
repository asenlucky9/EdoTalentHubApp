import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../config/app_config.dart';
import '../../../artists/domain/models/artist.dart';
import '../../../artists/presentation/screens/artist_detail_screen.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';
  String _selectedLocation = 'All';
  String _selectedPriceRange = 'All';
  String _selectedRating = 'All';
  
  List<Artist> _filteredArtists = [];
  bool _isLoading = false;

  final List<String> _categories = [
    'All',
    'Musicians / Bands',
    'DJs',
    'MCs / Comedians',
    'Cultural Dance Groups',
    'Videographers',
    'Event Venues',
    'Equipment Rentals',
    'Others',
  ];

  final List<String> _locations = [
    'All',
    'Benin City',
    'Ekpoma',
    'Auchi',
    'Uromi',
    'Irrua',
    'Abudu',
    'Ehor'
  ];

  final List<String> _priceRanges = [
    'All',
    'Under ₦50K',
    '₦50K - ₦100K',
    '₦100K - ₦200K',
    '₦200K - ₦500K',
    'Above ₦500K'
  ];

  final List<String> _ratings = [
    'All',
    '4.5+ Stars',
    '4.0+ Stars',
    '3.5+ Stars',
    '3.0+ Stars'
  ];

  // Mock artists data
  final List<Artist> _allArtists = [
    Artist(
      id: '1',
      name: 'DJ Master K',
      category: 'DJ',
      location: 'Benin City',
      rating: 4.8,
      reviewCount: 127,
      price: 80000,
      imageUrl: 'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=400&h=300&fit=crop',
      bio: 'Professional DJ with 5+ years experience in Afrobeat, Hip-hop, and R&B.',
      genres: ['Afrobeat', 'Hip-hop', 'R&B'],
      experience: '5 years',
    ),
    Artist(
      id: '2',
      name: 'MC Bright',
      category: 'MC',
      location: 'Ekpoma',
      rating: 4.2,
      reviewCount: 89,
      price: 30000,
      imageUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&h=300&fit=crop',
      bio: 'Dynamic MC specializing in weddings and corporate events.',
      genres: ['Wedding MC', 'Corporate Events'],
      experience: '3 years',
    ),
    Artist(
      id: '3',
      name: 'Cultural Group Edo',
      category: 'Cultural Group',
      location: 'Benin City',
      rating: 4.9,
      reviewCount: 156,
      price: 150000,
      imageUrl: 'https://images.unsplash.com/photo-1516450360452-9312f5e86fc7?w=400&h=300&fit=crop',
      bio: 'Traditional Edo cultural performances for festivals and ceremonies.',
      genres: ['Traditional', 'Cultural', 'Festival'],
      experience: '10+ years',
    ),
    Artist(
      id: '4',
      name: 'Photographer Pro',
      category: 'Photographer',
      location: 'Auchi',
      rating: 4.6,
      reviewCount: 94,
      price: 45000,
      imageUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&h=300&fit=crop',
      bio: 'Professional photographer specializing in events and portraits.',
      genres: ['Events', 'Portraits', 'Weddings'],
      experience: '4 years',
    ),
    Artist(
      id: '5',
      name: 'Videographer Max',
      category: 'Videographer',
      location: 'Uromi',
      rating: 4.4,
      reviewCount: 67,
      price: 60000,
      imageUrl: 'https://images.unsplash.com/photo-1516450360452-9312f5e86fc7?w=400&h=300&fit=crop',
      bio: 'Creative videographer for events and promotional content.',
      genres: ['Events', 'Promotional', 'Documentary'],
      experience: '6 years',
    ),
    Artist(
      id: '6',
      name: 'Akobeghian',
      category: 'Musician',
      location: 'Benin City',
      rating: 4.8,
      reviewCount: 200,
      price: 120000,
      imageUrl: 'assets/images/akobeghian.jpg',
      bio: 'Akobeghian has been active since the early 1990s, merging Edo-language storytelling with highlife rhythms. His music often carries spiritual, cultural, and ancestral themes—performed with theatricality and pride for Benin traditions. Hits like Ewemade, Umanatoumwen, and Ifinakhuenode are beloved at cultural events and reflect his mission to preserve Edo heritage. Albums: Begibegi (2024), Owonwon (2023), Oyiya (2023), Tesu Hukua (2023), Oseh (2023), Akobe in America (Live, 2023), Ewemade (2022), Umanatuomwen (2015), 10 Years Anniversary (2022), Ibah (2022), Aboninki (2022).',
      genres: ['Highlife', 'Edo Storytelling'],
      experience: 'Since early 1990s',
      videoUrls: [
        'https://www.youtube.com/watch?v=uZVfAEs-0gs&list=RDuZVfAEs-0gs&start_radio=1',
        'https://www.youtube.com/watch?v=FKsUPsErNq8&list=RDFKsUPsErNq8&start_radio=1',
      ],
    ),
    Artist(
      id: '7',
      name: 'Adviser Nowamagbe',
      category: 'Musician',
      location: 'Benin City',
      rating: 4.7,
      reviewCount: 150,
      price: 100000,
      imageUrl: 'assets/images/nowamagbe.jpg',
      bio: 'Adviser Nowamagbe, known as "Masses Chairman" and Music Ambassador for Democracy in Nigeria, uses music to critique government corruption and social issues. His titles like "Questions and Assignment for New Oshiomole" and "Mr. Subsidy" especially target Edo State governance and national policies, pulsating with protest narratives.\n\nAlbums/EPs: Fool At 40 (album), Democracy On Trial (EP), Egiau People (album).',
      genres: ['Highlife', 'Protest', 'Edo Social Commentary'],
      experience: 'Since 1990s',
      videoUrls: [
        'https://www.youtube.com/watch?v=pa_Nhrrrytg&list=RDpa_Nhrrrytg&start_radio=1&t=15s',
        'https://www.youtube.com/watch?v=t72eDaVN7Cg&list=RDt72eDaVN7Cg&start_radio=1',
      ],
    ),
    Artist(
      id: '8',
      name: 'MC Smooth',
      category: 'MC',
      location: 'Benin City',
      rating: 4.5,
      reviewCount: 112,
      price: 40000,
      imageUrl: 'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=400&h=300&fit=crop',
      bio: 'Professional MC with smooth delivery.',
      genres: ['Weddings', 'Parties', 'Corporate'],
      experience: '5 years',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _filteredArtists = _allArtists;
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _applyFilters();
  }

  void _applyFilters() {
    setState(() {
      _isLoading = true;
    });

    // Simulate loading
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _filteredArtists = _allArtists.where((artist) {
            // Search text filter
            final searchText = _searchController.text.toLowerCase();
            final matchesSearch = searchText.isEmpty ||
                artist.name.toLowerCase().contains(searchText) ||
                artist.category.toLowerCase().contains(searchText) ||
                artist.location.toLowerCase().contains(searchText) ||
                artist.genres.any((genre) => genre.toLowerCase().contains(searchText));

            // Category filter
            final matchesCategory = _selectedCategory == 'All' ||
                artist.category == _selectedCategory;

            // Location filter
            final matchesLocation = _selectedLocation == 'All' ||
                artist.location == _selectedLocation;

            // Price range filter
            bool matchesPrice = true;
            switch (_selectedPriceRange) {
              case 'Under ₦50K':
                matchesPrice = artist.price < 50000;
                break;
              case '₦50K - ₦100K':
                matchesPrice = artist.price >= 50000 && artist.price <= 100000;
                break;
              case '₦100K - ₦200K':
                matchesPrice = artist.price >= 100000 && artist.price <= 200000;
                break;
              case '₦200K - ₦500K':
                matchesPrice = artist.price >= 200000 && artist.price <= 500000;
                break;
              case 'Above ₦500K':
                matchesPrice = artist.price > 500000;
                break;
            }

            // Rating filter
            bool matchesRating = true;
            switch (_selectedRating) {
              case '4.5+ Stars':
                matchesRating = artist.rating >= 4.5;
                break;
              case '4.0+ Stars':
                matchesRating = artist.rating >= 4.0;
                break;
              case '3.5+ Stars':
                matchesRating = artist.rating >= 3.5;
                break;
              case '3.0+ Stars':
                matchesRating = artist.rating >= 3.0;
                break;
            }

            return matchesSearch && matchesCategory && matchesLocation && matchesPrice && matchesRating;
          }).toList();

          _isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConfig.backgroundColor,
      appBar: AppBar(
        title: const Text('Search'),
        backgroundColor: AppConfig.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
            // Search Bar
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search artists, events, venues... ',
                prefixIcon: Icon(Icons.search, color: AppConfig.primaryColor),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Recent Searches
            Text('Recent Searches', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppConfig.textPrimaryColor)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
      children: [
                _buildRecentSearchChip('Wedding DJ'),
                _buildRecentSearchChip('Cultural dancers'),
                _buildRecentSearchChip('MC for party'),
              ],
            ),
            const SizedBox(height: 16),
            // Filters (category, location, price, rating)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterDropdown('Category', _categories, _selectedCategory, (val) => setState(() => _selectedCategory = val!)),
                  const SizedBox(width: 8),
                  _buildFilterDropdown('Location', _locations, _selectedLocation, (val) => setState(() => _selectedLocation = val!)),
                  const SizedBox(width: 8),
                  _buildFilterDropdown('Price', _priceRanges, _selectedPriceRange, (val) => setState(() => _selectedPriceRange = val!)),
                  const SizedBox(width: 8),
                  _buildFilterDropdown('Rating', _ratings, _selectedRating, (val) => setState(() => _selectedRating = val!)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Results
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _filteredArtists.isEmpty
                      ? Center(child: Text('No results found', style: TextStyle(color: AppConfig.textSecondaryColor)))
                      : Scrollbar(
                          thumbVisibility: true,
                          thickness: 8,
                          radius: const Radius.circular(8),
                          interactive: true,
                          child: ListView.builder(
                            itemCount: _filteredArtists.length,
                            itemBuilder: (context, index) {
                              final artist = _filteredArtists[index];
                              return _buildArtistListCard(artist);
                            },
                          ),
                        ),
            ),
          ],
        ),
        ),
      );
    }

  Widget _buildRecentSearchChip(String label) {
    return Chip(
      label: Text(label),
      backgroundColor: AppConfig.primaryColor.withOpacity(0.08),
      labelStyle: TextStyle(color: AppConfig.primaryColor, fontWeight: FontWeight.w600),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }

  Widget _buildArtistListCard(Artist artist) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ArtistDetailScreen(artist: artist),
                      ),
                    );
                  },
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: artist.imageUrl.startsWith('http')
              ? Image.network(
                  artist.imageUrl,
                  width: 56,
                  height: 56,
                  fit: BoxFit.cover,
                )
              : Image.asset(
                  artist.imageUrl,
                  width: 56,
                  height: 56,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey[300],
                    child: Icon(
                      Icons.music_note,
                      color: Colors.grey[600],
                      size: 40,
                    ),
                  ),
                ),
        ),
        title: Row(
          children: [
            Text(
              artist.name,
              style: TextStyle(fontWeight: FontWeight.bold, color: AppConfig.textPrimaryColor),
            ),
            const SizedBox(width: 6),
            Icon(Icons.verified, color: Colors.green, size: 16),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              artist.category,
              style: TextStyle(fontSize: 13, color: AppConfig.textSecondaryColor),
            ),
            Row(
              children: [
                Icon(Icons.star, color: Colors.amber, size: 14),
                const SizedBox(width: 2),
                Text(
                  artist.rating.toString(),
                  style: TextStyle(fontSize: 12, color: AppConfig.textSecondaryColor),
                ),
                const SizedBox(width: 8),
                Text('(${artist.reviewCount} reviews)', style: TextStyle(fontSize: 12, color: AppConfig.textSecondaryColor)),
              ],
            ),
            Text(
              '₦${_formatPrice(artist.price)}',
              style: TextStyle(fontWeight: FontWeight.bold, color: AppConfig.primaryColor, fontSize: 13),
            ),
          ],
        ),
        trailing: Icon(Icons.arrow_forward_ios, color: AppConfig.primaryColor, size: 18),
      ),
    );
  }

  Widget _buildFilterDropdown(String label, List<String> options, String value, ValueChanged<String?> onChanged) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: value,
        items: options.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
        onChanged: onChanged,
        style: TextStyle(color: AppConfig.textPrimaryColor, fontWeight: FontWeight.w500),
        dropdownColor: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  String _formatPrice(double price) {
    if (price < 1000) {
      return price.toStringAsFixed(0);
    } else if (price < 100000) {
      return '${(price / 1000).toStringAsFixed(1)}K';
    } else {
      return '${(price / 100000).toStringAsFixed(1)}M';
    }
  }
} 