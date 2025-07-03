import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:hive/hive.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../config/app_config.dart';
import '../../../artists/domain/models/artist.dart';
import '../../domain/models/booking.dart';
import 'booking_confirmation_screen.dart';
import '../../../../shared/utils/booking_utils.dart';

class BookingScreen extends ConsumerStatefulWidget {
  final Artist artist;
  
  const BookingScreen({super.key, required this.artist});

  @override
  ConsumerState<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends ConsumerState<BookingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _locationController = TextEditingController();
  final _requirementsController = TextEditingController();
  final _guestsController = TextEditingController();
  
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  TimeOfDay _selectedTime = const TimeOfDay(hour: 18, minute: 0);
  String _selectedEventType = 'Wedding';
  int _selectedDuration = 4;
  String _selectedPaymentMethod = 'Bank Transfer';
  String _selectedTimeOfDay = 'Afternoon';
  
  // Add-ons/extras
  bool _addMC = false;
  bool _addVideographer = false;
  bool _addEventVenue = false;
  
  bool _isLoading = false;

  // Add state for selected add-ons
  Artist? _selectedMC;
  Artist? _selectedVideographer;
  Artist? _selectedVenue;

  // Add state to track if user is on review page
  bool _showReviewPage = false;

  final List<String> _eventTypes = [
    'Wedding',
    'Birthday Party',
    'Corporate Event',
    'Private Party',
    'Festival',
    'Cultural Event',
    'Other'
  ];

  final List<String> _talentCategories = [
    'Musicians / Bands',
    'DJs',
    'MCs / Comedians',
    'Cultural Dance Groups',
    'Videographers',
    'Event Venues',
    'Equipment Rentals',
    'Others',
  ];

  final List<int> _durations = [2, 3, 4, 5, 6, 8, 10, 12];

  final List<String> _paymentMethods = [
    'Bank Transfer',
  ];

  final List<String> _timeOfDayOptions = [
    'Morning',
    'Afternoon',
    'Evening',
    'Night',
  ];

  // Mock unavailable dates for demo (in production, fetch from backend)
  final List<DateTime> _unavailableDates = [
    DateTime.now().add(const Duration(days: 2)),
    DateTime.now().add(const Duration(days: 5)),
    DateTime.now().add(const Duration(days: 10)),
  ];

  // Example price ranges for event types (could be loaded from artist.pricing)
  final Map<String, List<int>> _eventTypePriceRanges = {
    'Wedding': [100000, 200000],
    'Birthday Party': [50000, 100000],
    'Corporate Event': [80000, 180000],
    'Private Party': [40000, 90000],
    'Festival': [120000, 250000],
    'Cultural Event': [70000, 150000],
    'Other': [30000, 80000],
  };

  // Add-ons pricing
  final Map<String, double> _addOnsPricing = {
    'MC': 30000,
    'Videographer': 40000,
    'Event Venue': 100000,
  };

  int get _guestCount => int.tryParse(_guestsController.text) ?? 0;

  List<int> get _selectedEventPriceRange => _eventTypePriceRanges[_selectedEventType] ?? [50000, 100000];

  double get _basePrice {
    // Start with the average of the range
    double base = (_selectedEventPriceRange[0] + _selectedEventPriceRange[1]) / 2;
    // Adjust for location (example: +10% if not Benin City)
    if (_locationController.text.isNotEmpty && !_locationController.text.toLowerCase().contains('benin')) {
      base *= 1.1;
    }
    // Adjust for guest count (example: +10% if > 200 guests)
    if (_guestCount > 200) {
      base *= 1.1;
    } else if (_guestCount > 100) {
      base *= 1.05;
    }
    return base;
  }

  double get _addOnsTotal {
    double total = 0;
    if (_addMC && _addOnsPricing['MC'] != null) total += _addOnsPricing['MC']!;
    if (_addVideographer && _addOnsPricing['Videographer'] != null) total += _addOnsPricing['Videographer']!;
    if (_addEventVenue && _addOnsPricing['Event Venue'] != null) total += _addOnsPricing['Event Venue']!;
    return total;
  }

  double get _serviceFee => (_basePrice + _addOnsTotal) * 0.10;
  double get _calculatedPrice => _basePrice + _addOnsTotal + _serviceFee;

  String get _selectedDayOfWeek => DateFormat('EEEE').format(_selectedDate);

  bool get _isDateAvailable {
    return !_unavailableDates.any((d) =>
      d.year == _selectedDate.year &&
      d.month == _selectedDate.month &&
      d.day == _selectedDate.day
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _locationController.dispose();
    _requirementsController.dispose();
    _guestsController.dispose();
    super.dispose();
  }

  double get _eventTypePrice {
    if (widget.artist.pricing != null && widget.artist.pricing!.containsKey(_selectedEventType)) {
      final price = widget.artist.pricing![_selectedEventType];
      if (price != null) {
        return (price as num).toDouble();
      }
    }
    return widget.artist.price;
  }

  double get _totalAmount {
    return _eventTypePrice * _selectedDuration;
  }

  // Helper to get sample artists for dropdowns
  List<Artist> get _mcList => _getSampleArtists('MCs / Comedians');
  List<Artist> get _videographerList => _getSampleArtists('Videographers');
  List<Artist> get _venueList => _getSampleArtists('Event Venues');

  List<Artist> _getSampleArtists(String category) {
    // Replicate the logic from category_artists_screen.dart
    switch (category) {
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
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConfig.backgroundColor,
      appBar: AppBar(
        title: Text(_showReviewPage ? 'Review Booking' : 'Book Artist'),
        backgroundColor: AppConfig.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _showReviewPage ? _buildReviewPage() : SingleChildScrollView(
        child: Column(
          children: [
            // Step Indicator
            _buildStepIndicator(),
            // Artist Info Header
            _buildArtistHeader(),
            // Artist Availability
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: Row(
                children: [
                  Icon(
                    widget.artist.isAvailable ? Icons.check_circle : Icons.cancel,
                    color: widget.artist.isAvailable ? Colors.green : Colors.red,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    widget.artist.isAvailable ? 'Available for Booking' : 'Not Available',
                    style: TextStyle(
                      color: widget.artist.isAvailable ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            // Date-specific Availability
            if (widget.artist.isAvailable)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                child: Row(
                  children: [
                    Icon(
                      _isDateAvailable ? Icons.event_available : Icons.event_busy,
                      color: _isDateAvailable ? Colors.green : Colors.red,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _isDateAvailable ? 'Available on selected date' : 'Not available on selected date',
                      style: TextStyle(
                        color: _isDateAvailable ? Colors.green : Colors.red,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    if (!_isDateAvailable)
                      const SizedBox(width: 12),
                    if (!_isDateAvailable)
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Send Inquiry'),
                              content: const Text('We will notify the artist about your interest for this date. You will be contacted if the artist becomes available.'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          );
                        },
                        child: const Text('Ask for Availability'),
                      ),
                  ],
                ),
              ),
            // Booking Form (only if available and date is available)
            if (widget.artist.isAvailable && _isDateAvailable)
              _buildBookingForm()
            else if (widget.artist.isAvailable && !_isDateAvailable)
              Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'This artist is not available on the selected date. You can ask for availability or choose another date.',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              )
            else if (!widget.artist.isAvailable)
              Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'This artist is currently not available for booking.',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: (widget.artist.isAvailable && _isDateAvailable) ? _buildBottomBar() : null,
    );
  }

  Widget _buildStepIndicator() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 4,
              decoration: BoxDecoration(
                color: AppConfig.primaryColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppConfig.primaryColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'Step 1 of 2',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArtistHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: AppConfig.primaryGradient,
        boxShadow: AppConfig.cardShadow,
      ),
      child: Row(
        children: [
          // Artist Image
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white.withOpacity(0.2),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                widget.artist.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Icon(
                  Icons.music_note,
                  color: Colors.white,
                  size: 40,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Artist Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.artist.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.artist.category,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${widget.artist.rating} (${widget.artist.reviewCount} reviews)',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
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
    );
  }

  Widget _buildBookingForm() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Event Details Section
            _buildSectionTitle('Event Details'),
            const SizedBox(height: 16),
            
            // Event Type
            _buildDropdownField(
              label: 'Event Type',
              value: _selectedEventType,
              items: _eventTypes,
              onChanged: (value) {
                setState(() {
                  _selectedEventType = value!;
                });
              },
            ),
            
            const SizedBox(height: 16),
            
            // Date
            _buildDateField(),
            
            const SizedBox(height: 8),
            
            // Show day of week
            Text(
              'Day: $_selectedDayOfWeek',
              style: TextStyle(
                color: AppConfig.primaryColor,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Time of Day Dropdown
            _buildDropdownField(
              label: 'Time of Day',
              value: _selectedTimeOfDay,
              items: _timeOfDayOptions,
              onChanged: (value) {
                setState(() {
                  _selectedTimeOfDay = value!;
                });
              },
            ),
            
            const SizedBox(height: 16),
            
            // Number of Guests
            _buildTextField(
              controller: _guestsController,
              label: 'Number of Guests',
              icon: Icons.people,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter number of guests';
                }
                if (int.tryParse(value) == null || int.parse(value) <= 0) {
                  return 'Enter a valid number';
                }
                if (int.parse(value) > 1000) {
                  return 'Maximum 1000 guests allowed';
                }
                return null;
              },
            ),
            
            const SizedBox(height: 16),
            
            // Duration
            _buildDropdownField(
              label: 'Duration (hours)',
              value: _selectedDuration.toString(),
              items: _durations.map((d) => d.toString()).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedDuration = int.parse(value!);
                });
              },
            ),
            
            const SizedBox(height: 24),
            
            // Add-ons Section
            _buildSectionTitle('Additional Services'),
            const SizedBox(height: 8),
            Text(
              'Select any additional services you need',
              style: TextStyle(
                color: AppConfig.textSecondaryColor,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 16),
            _buildAddOnOption('MC', 'Add a professional MC to your event', _addMC, (value) {
              setState(() {
                _addMC = value ?? false;
                if (!_addMC) _selectedMC = null;
              });
            }),
            if (_addMC)
              Padding(
                padding: const EdgeInsets.only(left: 8, bottom: 12),
                child: DropdownButtonFormField<Artist>(
                  value: _selectedMC,
                  items: _mcList.map((mc) => DropdownMenuItem(
                    value: mc,
                    child: Text(mc.name),
                  )).toList(),
                  onChanged: (mc) => setState(() => _selectedMC = mc),
                  decoration: InputDecoration(
                    labelText: 'Select MC',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
            _buildAddOnOption('Videographer', 'Capture your event with a professional videographer', _addVideographer, (value) {
              setState(() {
                _addVideographer = value ?? false;
                if (!_addVideographer) _selectedVideographer = null;
              });
            }),
            if (_addVideographer)
              Padding(
                padding: const EdgeInsets.only(left: 8, bottom: 12),
                child: DropdownButtonFormField<Artist>(
                  value: _selectedVideographer,
                  items: _videographerList.map((v) => DropdownMenuItem(
                    value: v,
                    child: Text(v.name),
                  )).toList(),
                  onChanged: (v) => setState(() => _selectedVideographer = v),
                  decoration: InputDecoration(
                    labelText: 'Select Videographer',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
            _buildAddOnOption('Event Venue', 'Book a recommended event venue', _addEventVenue, (value) {
              setState(() {
                _addEventVenue = value ?? false;
                if (!_addEventVenue) _selectedVenue = null;
              });
            }),
            if (_addEventVenue)
              Padding(
                padding: const EdgeInsets.only(left: 8, bottom: 12),
                child: DropdownButtonFormField<Artist>(
                  value: _selectedVenue,
                  items: _venueList.map((v) => DropdownMenuItem(
                    value: v,
                    child: Text(v.name),
                  )).toList(),
                  onChanged: (v) => setState(() => _selectedVenue = v),
                  decoration: InputDecoration(
                    labelText: 'Select Event Venue',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
            const SizedBox(height: 24),
            
            // Contact Information Section
            _buildSectionTitle('Contact Information'),
            const SizedBox(height: 16),
            
            _buildTextField(
              controller: _nameController,
              label: 'Full Name',
              icon: Icons.person,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your name';
                }
                if (value.trim().split(' ').length < 2) {
                  return 'Please enter your full name';
                }
                return null;
              },
            ),
            
            const SizedBox(height: 16),
            
            _buildTextField(
              controller: _phoneController,
              label: 'Phone Number',
              icon: Icons.phone,
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your phone number';
                }
                if (value.length < 10) {
                  return 'Please enter a valid phone number';
                }
                return null;
              },
            ),
            
            const SizedBox(height: 16),
            
            _buildTextField(
              controller: _emailController,
              label: 'Email (Optional)',
              icon: Icons.email,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value != null && value.isNotEmpty) {
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                }
                return null;
              },
            ),
            
            const SizedBox(height: 16),
            
            _buildTextField(
              controller: _locationController,
              label: 'Event Location',
              icon: Icons.location_on,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter event location';
                }
                if (value.length < 10) {
                  return 'Please provide a detailed address';
                }
                return null;
              },
            ),
            
            const SizedBox(height: 16),
            
            _buildTextField(
              controller: _requirementsController,
              label: 'Special Requirements (Optional)',
              icon: Icons.note,
              maxLines: 3,
            ),
            
            const SizedBox(height: 24),
            
            // Payment Method Section
            _buildSectionTitle('Payment Method'),
            const SizedBox(height: 16),
            
            _buildDropdownField(
              label: 'Payment Method',
              value: _selectedPaymentMethod,
              items: _paymentMethods,
              onChanged: (value) {
                setState(() {
                  _selectedPaymentMethod = value!;
                });
              },
            ),
            
            const SizedBox(height: 24),
            
            // Pricing Summary
            _buildPricingSummary(),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if ((_formKey.currentState == null || !_formKey.currentState!.validate()) || !_validateAddOns()) {
                        return;
                      }
                      setState(() {
                        _showReviewPage = true;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppConfig.primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Review Booking'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppConfig.textPrimaryColor,
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppConfig.textPrimaryColor,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: DropdownButtonFormField<String>(
            value: value,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            items: items.map((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(item),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Date',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppConfig.textPrimaryColor,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _selectDate,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_today, color: AppConfig.primaryColor),
                const SizedBox(width: 8),
                Text(
                  DateFormat('MMM dd, yyyy').format(_selectedDate),
                  style: TextStyle(
                    color: AppConfig.textPrimaryColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Time',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppConfig.textPrimaryColor,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _selectTime,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Row(
              children: [
                Icon(Icons.access_time, color: AppConfig.primaryColor),
                const SizedBox(width: 8),
                Text(
                  _selectedTime.format(context),
                  style: TextStyle(
                    color: AppConfig.textPrimaryColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppConfig.textPrimaryColor,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          validator: validator,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: AppConfig.primaryColor),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppConfig.primaryColor),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildAddOnOption(String title, String description, bool value, Function(bool?) onChanged) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: value ? AppConfig.primaryColor : Colors.grey[300]!,
          width: value ? 2 : 1,
        ),
      ),
      child: CheckboxListTile(
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: AppConfig.textPrimaryColor,
          ),
        ),
        subtitle: Text(
          description,
          style: TextStyle(
            color: AppConfig.textSecondaryColor,
            fontSize: 12,
          ),
        ),
        value: value,
        onChanged: onChanged,
        activeColor: AppConfig.primaryColor,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }

  Widget _buildPricingSummary() {
    return Card(
      margin: const EdgeInsets.only(bottom: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Pricing Summary', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppConfig.primaryColor)),
            const SizedBox(height: 12),
            _buildPriceRow('Base Price', _basePrice),
            if (_addMC && _addOnsPricing['MC'] != null) _buildPriceRow('MC', _addOnsPricing['MC']!),
            if (_addVideographer && _addOnsPricing['Videographer'] != null) _buildPriceRow('Videographer', _addOnsPricing['Videographer']!),
            if (_addEventVenue && _addOnsPricing['Event Venue'] != null) _buildPriceRow('Event Venue', _addOnsPricing['Event Venue']!),
            _buildPriceRow('Service Fee (10%)', _serviceFee),
            const Divider(height: 24),
            _buildPriceRow('Total', _calculatedPrice, isTotal: true),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceRow(String label, double value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontWeight: isTotal ? FontWeight.bold : FontWeight.w500, fontSize: isTotal ? 16 : 14)),
          Text('₦${_formatPrice(value)}', style: TextStyle(fontWeight: isTotal ? FontWeight.bold : FontWeight.w500, fontSize: isTotal ? 16 : 14, color: isTotal ? AppConfig.primaryColor : null)),
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
                  'Total Amount',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppConfig.textSecondaryColor,
                  ),
                ),
                Text(
                  '₦${_formatPrice(_calculatedPrice)}',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppConfig.primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().add(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  Future<void> _submitBooking() async {
    if (_formKey.currentState == null || !_formKey.currentState!.validate()) {
      return;
    }

    // Validate required fields
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your name')),
      );
      return;
    }

    if (_phoneController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your phone number')),
      );
      return;
    }

    if (_locationController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter the event location')),
      );
      return;
    }

    if (_guestsController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter the number of guests')),
      );
      return;
    }

    // Validate add-ons if selected
    if (!_validateAddOns()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // Create booking object
      final booking = Booking(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        customerId: 'demo_user_id', // Temporarily disabled for web compatibility
        artistId: widget.artist.id,
        eventType: _selectedEventType,
        eventDate: DateTime(
          _selectedDate.year,
          _selectedDate.month,
          _selectedDate.day,
        ),
        eventLocation: _locationController.text.trim(),
        duration: _selectedDuration,
        totalAmount: _calculatedPrice,
        status: 'pending',
        specialRequirements: _buildSpecialRequirements(),
        customerName: _nameController.text.trim(),
        customerPhone: _phoneController.text.trim(),
        customerEmail: _emailController.text.trim().isEmpty 
            ? null 
            : _emailController.text.trim(),
        artistName: widget.artist.name,
        artistPhone: widget.artist.phone,
        artistEmail: widget.artist.email,
        paymentMethod: _selectedPaymentMethod,
        selectedMCId: _selectedMC?.id,
        selectedMCName: _selectedMC?.name,
        selectedVideographerId: _selectedVideographer?.id,
        selectedVideographerName: _selectedVideographer?.name,
        selectedVenueId: _selectedVenue?.id,
        selectedVenueName: _selectedVenue?.name,
        referenceNumber: BookingUtils.generateReferenceNumber(),
        artistImageUrl: widget.artist.imageUrl,
      );

      // Save to Hive local storage
      final box = await Hive.openBox<Booking>('bookings');
      await box.add(booking);
      // Save to Firestore
      // await FirebaseFirestore.instance.collection('bookings').add(booking.toJson());
      // Temporarily disabled for web compatibility
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Booking saved successfully!')),
        );
      }

      // Navigate to confirmation screen
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => BookingConfirmationScreen(booking: booking),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Booking failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  String _buildSpecialRequirements() {
    List<String> requirements = [];
    if (_requirementsController.text.isNotEmpty) {
      requirements.add(_requirementsController.text);
    }
    requirements.add('Time of Day: $_selectedTimeOfDay');
    if (_addMC) requirements.add('MC');
    if (_addVideographer) requirements.add('Videographer');
    if (_addEventVenue) requirements.add('Event Venue');
    return requirements.join('\n');
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

  // Add a method to validate add-on selections
  bool _validateAddOns() {
    if (_addMC && _selectedMC == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an MC.')),
      );
      return false;
    }
    if (_addVideographer && _selectedVideographer == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a Videographer.')),
      );
      return false;
    }
    if (_addEventVenue && _selectedVenue == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an Event Venue.')),
      );
      return false;
    }
    return true;
  }

  // Add the review page widget
  Widget _buildReviewPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Review Your Booking', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppConfig.primaryColor)),
          const SizedBox(height: 24),
          // Main Artist
          _buildReviewSection('Main Artist', widget.artist.name),
          // Add-ons
          if (_addMC && _selectedMC != null)
            _buildReviewSection('MC', _selectedMC!.name),
          if (_addVideographer && _selectedVideographer != null)
            _buildReviewSection('Videographer', _selectedVideographer!.name),
          if (_addEventVenue && _selectedVenue != null)
            _buildReviewSection('Event Venue', _selectedVenue!.name),
          const SizedBox(height: 16),
          // Event Details
          _buildReviewSection('Event Type', _selectedEventType),
          _buildReviewSection('Date', DateFormat('MMM dd, yyyy').format(_selectedDate)),
          _buildReviewSection('Time of Day', _selectedTimeOfDay),
          _buildReviewSection('Guests', _guestsController.text),
          _buildReviewSection('Duration', '$_selectedDuration hours'),
          _buildReviewSection('Location', _locationController.text),
          if (_requirementsController.text.isNotEmpty)
            _buildReviewSection('Special Requirements', _requirementsController.text),
          const SizedBox(height: 24),
          // Pricing
          _buildPricingSummary(),
          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _showReviewPage = false;
                    });
                  },
                  child: const Text('Edit'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Single Confirm Booking button at the bottom
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _submitBooking,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConfig.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text(
                      'Confirm Booking',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewSection(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 120, child: Text('$label:', style: const TextStyle(fontWeight: FontWeight.w600))),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 15))),
        ],
      ),
    );
  }
} 