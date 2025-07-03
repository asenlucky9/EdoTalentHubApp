import 'package:flutter/material.dart';
import '../../../../config/app_config.dart';
import '../../domain/models/artist.dart';
import '../widgets/artist_card.dart';
import 'artist_detail_screen.dart';

class CategoryArtistsScreen extends StatefulWidget {
  final String category;
  const CategoryArtistsScreen({Key? key, required this.category}) : super(key: key);

  @override
  State<CategoryArtistsScreen> createState() => _CategoryArtistsScreenState();
}

class _CategoryArtistsScreenState extends State<CategoryArtistsScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Artist> _filteredArtists = [];
  String _sortBy = 'Rating';

  // Mock data for demo (should be replaced with real data)
  late final List<Artist> _allArtists;

  @override
  void initState() {
    super.initState();
    _allArtists = _getArtistsForCategory(widget.category);
    _filteredArtists = _allArtists;
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      final search = _searchController.text.toLowerCase();
      _filteredArtists = _allArtists.where((artist) =>
        artist.name.toLowerCase().contains(search) ||
        artist.location.toLowerCase().contains(search) ||
        artist.genres.any((g) => g.toLowerCase().contains(search))
      ).toList();
    });
  }

  void _sortArtists() {
    setState(() {
      if (_sortBy == 'Rating') {
        _filteredArtists.sort((a, b) => b.rating.compareTo(a.rating));
      } else if (_sortBy == 'Price (Low-High)') {
        _filteredArtists.sort((a, b) => a.price.compareTo(b.price));
      } else if (_sortBy == 'Price (High-Low)') {
        _filteredArtists.sort((a, b) => b.price.compareTo(a.price));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConfig.backgroundColor,
      appBar: AppBar(
        title: Text('${widget.category}'),
        backgroundColor: AppConfig.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Festive gradient header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppConfig.primaryColor, AppConfig.accentColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppConfig.primaryColor.withOpacity(0.12),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Explore ${widget.category}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Find the best ${widget.category.toLowerCase()} for your event!',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 20),
                // Search bar
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppConfig.primaryColor.withOpacity(0.07),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search ${widget.category.toLowerCase()}... ',
                      hintStyle: TextStyle(color: Colors.grey[500]),
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.search, color: AppConfig.primaryColor),
                      contentPadding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Sort dropdown
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              children: [
                const Text('Sort by:', style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(width: 12),
                DropdownButton<String>(
                  value: _sortBy,
                  items: const [
                    DropdownMenuItem(value: 'Rating', child: Text('Rating')),
                    DropdownMenuItem(value: 'Price (Low-High)', child: Text('Price (Low-High)')),
                    DropdownMenuItem(value: 'Price (High-Low)', child: Text('Price (High-Low)')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _sortBy = value!;
                    });
                    _sortArtists();
                  },
                ),
                const Spacer(),
                Text('${_filteredArtists.length} found', style: TextStyle(color: AppConfig.textSecondaryColor)),
              ],
            ),
          ),
          // Artists grid/list
          Expanded(
            child: _filteredArtists.isEmpty
                ? Center(
                    child: Text(
                      'No ${widget.category.toLowerCase()} found.',
                      style: TextStyle(color: Colors.grey[600], fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.75,
                    ),
                    itemCount: _filteredArtists.length,
                    itemBuilder: (context, index) {
                      final artist = _filteredArtists[index];
                      return ArtistCard(
                        artist: artist,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ArtistDetailScreen(artist: artist),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  List<Artist> _getArtistsForCategory(String category) {
    switch (category) {
      case 'Musicians / Bands':
        return [
          Artist(
            id: 'm1',
            name: 'Guitar Master',
            category: 'Musician',
            location: 'Benin City',
            rating: 4.7,
            reviewCount: 89,
            price: 60000,
            imageUrl: 'https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?w=400&h=300&fit=crop',
            bio: 'A captivating guitarist delivering soulful performances for weddings, corporate events, and private parties.',
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
            imageUrl: 'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?w=400&h=300&fit=crop',
            bio: 'Elegant pianist specializing in classical and contemporary music for upscale events and galas.',
            genres: ['Classical', 'Contemporary', 'Jazz'],
            experience: '12 years',
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
            imageUrl: 'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?w=400&h=300&fit=crop',
            bio: 'Versatile DJ spinning the latest Afrobeat, Hip-hop, and R&B hits for unforgettable parties.',
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
            imageUrl: 'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?w=400&h=300&fit=crop',
            bio: 'Afrobeat specialist DJ, energizing crowds at festivals, weddings, and club nights.',
            genres: ['Afrobeat', 'Highlife', 'Juju'],
            experience: '7 years',
          ),
        ];
      case 'MCs / Comedians':
        return [
          Artist(
            id: 'mc1',
            name: 'MC Bright',
            category: 'MC',
            location: 'Ekpoma',
            rating: 4.2,
            reviewCount: 89,
            price: 30000,
            imageUrl: 'https://images.unsplash.com/photo-1464983953574-0892a716854b?w=400&h=300&fit=crop',
            bio: 'Dynamic MC bringing energy and humor to weddings, birthdays, and corporate events.',
            genres: ['Wedding MC', 'Corporate Events'],
            experience: '3 years',
          ),
          Artist(
            id: 'mc2',
            name: 'Comedian Joy',
            category: 'Comedian',
            location: 'Benin City',
            rating: 4.5,
            reviewCount: 102,
            price: 35000,
            imageUrl: 'https://images.unsplash.com/photo-1464983953574-0892a716854b?w=400&h=300&fit=crop',
            bio: 'Award-winning comedian known for witty performances and crowd engagement at major events.',
            genres: ['Stand-up', 'Comedy Shows'],
            experience: '6 years',
          ),
        ];
      case 'Cultural Dance Groups':
        return [
          Artist(
            id: 'cg1',
            name: 'Edo Heritage Dancers',
            category: 'Cultural Group',
            location: 'Benin City',
            rating: 4.9,
            reviewCount: 156,
            price: 150000,
            imageUrl: 'https://images.unsplash.com/photo-1506744038136-46273834b3fb?w=400&h=300&fit=crop',
            bio: 'Authentic Edo cultural dance troupe performing at festivals, weddings, and state events.',
            genres: ['Traditional', 'Cultural', 'Festival'],
            experience: '10+ years',
          ),
          Artist(
            id: 'cg2',
            name: 'Royal Drummers of Edo',
            category: 'Cultural Group',
            location: 'Uromi',
            rating: 4.7,
            reviewCount: 88,
            price: 120000,
            imageUrl: 'https://images.unsplash.com/photo-1506744038136-46273834b3fb?w=400&h=300&fit=crop',
            bio: 'Renowned drumming group delivering electrifying performances rooted in Edo tradition.',
            genres: ['Drumming', 'Cultural', 'Ceremonial'],
            experience: '8 years',
          ),
        ];
      case 'Videographers':
        return [
          Artist(
            id: 'v1',
            name: 'Visionary Films',
            category: 'Videographer',
            location: 'Auchi',
            rating: 4.6,
            reviewCount: 94,
            price: 90000,
            imageUrl: 'https://images.unsplash.com/photo-1515378791036-0648a3ef77b2?w=400&h=300&fit=crop',
            bio: 'Creative videographer capturing memorable moments for weddings, concerts, and documentaries.',
            genres: ['Events', 'Documentary', 'Weddings'],
            experience: '4 years',
          ),
          Artist(
            id: 'v2',
            name: 'Cinematic Studios',
            category: 'Videographer',
            location: 'Benin City',
            rating: 4.8,
            reviewCount: 120,
            price: 110000,
            imageUrl: 'https://images.unsplash.com/photo-1515378791036-0648a3ef77b2?w=400&h=300&fit=crop',
            bio: 'Award-winning studio specializing in high-quality event and promotional videos.',
            genres: ['Events', 'Promotional', 'Weddings'],
            experience: '7 years',
          ),
        ];
      case 'Event Venues':
        return [
          Artist(
            id: 'ev1',
            name: 'Royal Palace Hall',
            category: 'Event Venue',
            location: 'Benin City',
            rating: 4.7,
            reviewCount: 80,
            price: 250000,
            imageUrl: 'https://images.unsplash.com/photo-1506744038136-46273834b3fb?w=400&h=300&fit=crop',
            bio: 'Elegant event hall with modern amenities, perfect for weddings, conferences, and galas.',
            genres: ['Weddings', 'Conferences', 'Galas'],
            experience: '5 years',
          ),
          Artist(
            id: 'ev2',
            name: 'Garden View Arena',
            category: 'Event Venue',
            location: 'Uromi',
            rating: 4.5,
            reviewCount: 65,
            price: 180000,
            imageUrl: 'https://images.unsplash.com/photo-1506744038136-46273834b3fb?w=400&h=300&fit=crop',
            bio: 'Scenic outdoor venue ideal for cultural festivals, receptions, and large gatherings.',
            genres: ['Festivals', 'Receptions', 'Outdoor Events'],
            experience: '3 years',
          ),
        ];
      case 'Equipment Rentals':
        return [
          Artist(
            id: 'eq1',
            name: 'SoundPro Rentals',
            category: 'Equipment Rental',
            location: 'Benin City',
            rating: 4.6,
            reviewCount: 70,
            price: 40000,
            imageUrl: 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=400&h=300&fit=crop',
            bio: 'Reliable provider of sound and lighting equipment for events of all sizes.',
            genres: ['Sound', 'Lighting', 'Events'],
            experience: '6 years',
          ),
          Artist(
            id: 'eq2',
            name: 'EventGear Hub',
            category: 'Equipment Rental',
            location: 'Ekpoma',
            rating: 4.4,
            reviewCount: 55,
            price: 35000,
            imageUrl: 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=400&h=300&fit=crop',
            bio: 'Affordable rental service for event essentials including tents, chairs, and decor.',
            genres: ['Tents', 'Chairs', 'Decor'],
            experience: '4 years',
          ),
        ];
      case 'Others':
        return [
          Artist(
            id: 'ot1',
            name: 'Master of Ceremony',
            category: 'Other',
            location: 'Benin City',
            rating: 4.3,
            reviewCount: 40,
            price: 25000,
            imageUrl: 'https://images.unsplash.com/photo-1464983953574-0892a716854b?w=400&h=300&fit=crop',
            bio: 'Experienced MC available for all event types, ensuring smooth flow and engagement.',
            genres: ['MC', 'Events'],
            experience: '5 years',
          ),
          Artist(
            id: 'ot2',
            name: 'Traditional Costume Rental',
            category: 'Other',
            location: 'Uromi',
            rating: 4.2,
            reviewCount: 28,
            price: 15000,
            imageUrl: 'https://images.unsplash.com/photo-1464983953574-0892a716854b?w=400&h=300&fit=crop',
            bio: 'Rent authentic Edo costumes for cultural events, photoshoots, and celebrations.',
            genres: ['Costume', 'Cultural'],
            experience: '2 years',
          ),
        ];
      default:
        return [];
    }
  }
} 