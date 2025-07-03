import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../config/app_config.dart';
import '../../../../shared/services/firebase_user_service.dart';
import '../../../dashboard/presentation/screens/dashboard_screen.dart';

class ArtistApplicationScreen extends StatefulWidget {
  final dynamic user;
  
  const ArtistApplicationScreen({
    Key? key, 
    required this.user,
  }) : super(key: key);

  @override
  State<ArtistApplicationScreen> createState() => _ArtistApplicationScreenState();
}

class _ArtistApplicationScreenState extends State<ArtistApplicationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _locationController = TextEditingController();
  final _bioController = TextEditingController();
  final _experienceController = TextEditingController();
  final _minPriceController = TextEditingController();
  final _maxPriceController = TextEditingController();
  
  String _selectedCategory = 'Musician';
  String _selectedCity = 'Benin City';
  List<String> _selectedGenres = [];
  bool _isLoading = false;

  final List<String> _categories = [
    'Musician',
    'DJ',
    'MC',
    'Cultural Group',
    'Dancer',
    'Comedian',
    'Poet',
    'Other',
  ];

  final List<String> _cities = [
    'Benin City',
    'Ekpoma',
    'Auchi',
    'Uromi',
    'Irrua',
    'Abudu',
    'Ehor',
    'Igueben',
    'Ubiaja',
    'Sabongida-Ora',
    'Otuo',
    'Afuze',
    'Owan',
    'Igarra',
    'Okpe',
    'Ologbo',
    'Udo',
    'Ekiadolor',
    'Isi',
    'Urhonigbe',
  ];

  final List<String> _genres = [
    'Afrobeat',
    'Highlife',
    'Juju',
    'Gospel',
    'Hip Hop',
    'R&B',
    'Pop',
    'Reggae',
    'Jazz',
    'Blues',
    'Rock',
    'Country',
    'Classical',
    'Traditional',
    'Fuji',
    'Apala',
    'Waka',
    'Sakara',
    'Bata',
    'Other',
  ];

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    _bioController.dispose();
    _experienceController.dispose();
    _minPriceController.dispose();
    _maxPriceController.dispose();
    super.dispose();
  }

  String _formatCurrency(String value) {
    if (value.isEmpty) return '';
    
    // Remove all non-digit characters
    String digits = value.replaceAll(RegExp(r'[^\d]'), '');
    
    if (digits.isEmpty) return '';
    
    // Convert to number and format
    int number = int.parse(digits);
    
    if (number >= 1000000) {
      return '₦${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '₦${(number / 1000).toStringAsFixed(0)}K';
    } else {
      return '₦$number';
    }
  }

  double _parseCurrency(String value) {
    if (value.isEmpty) return 0;
    
    // Remove currency symbol and letters
    String digits = value.replaceAll(RegExp(r'[^\d]'), '');
    
    if (digits.isEmpty) return 0;
    
    int number = int.parse(digits);
    
    // Convert back to actual amount
    if (value.contains('M')) {
      return number * 1000000.0;
    } else if (value.contains('K')) {
      return number * 1000.0;
    } else {
      return number.toDouble();
    }
  }

  Future<void> _submitApplication() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() {
      _isLoading = true;
    });

    try {
      // Parse price range
      double minPrice = _parseCurrency(_minPriceController.text);
      double maxPrice = _parseCurrency(_maxPriceController.text);
      
      if (minPrice >= maxPrice) {
        throw Exception('Maximum price must be greater than minimum price');
      }

      // Create pricing map
      Map<String, double> pricing = {
        'min': minPrice,
        'max': maxPrice,
        'average': (minPrice + maxPrice) / 2,
      };

      // Complete artist profile using Firebase service
      await FirebaseUserService.completeArtistProfile(
        userId: widget.user.uid,
        fullName: _fullNameController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        location: _locationController.text.trim(),
        city: _selectedCity,
        bio: _bioController.text.trim(),
        category: _selectedCategory,
        experience: _experienceController.text.trim(),
        genres: _selectedGenres,
        pricing: pricing,
      );

      // Navigate to dashboard
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DashboardScreen()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error submitting application: $e')),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConfig.backgroundColor,
      appBar: AppBar(
        title: const Text('Artist Application'),
        backgroundColor: AppConfig.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                'Artist Application',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppConfig.textPrimaryColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Complete your artist profile to start receiving bookings',
                style: TextStyle(
                  fontSize: 16,
                  color: AppConfig.textSecondaryColor,
                ),
              ),
              const SizedBox(height: 32),

              // Full Name
              TextFormField(
                controller: _fullNameController,
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  hintText: 'Enter your full name',
                  prefixIcon: Icon(Icons.person, color: AppConfig.primaryColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your full name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Phone Number
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  hintText: '+234 801 234 5678',
                  prefixIcon: Icon(Icons.phone, color: AppConfig.primaryColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Category Selection
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: InputDecoration(
                  labelText: 'Artist Category',
                  prefixIcon: Icon(Icons.category, color: AppConfig.primaryColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items: _categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value!;
                  });
                },
              ),
              const SizedBox(height: 20),

              // City Selection
              DropdownButtonFormField<String>(
                value: _selectedCity,
                decoration: InputDecoration(
                  labelText: 'City',
                  prefixIcon: Icon(Icons.location_city, color: AppConfig.primaryColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items: _cities.map((city) {
                  return DropdownMenuItem(
                    value: city,
                    child: Text(city),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCity = value!;
                  });
                },
              ),
              const SizedBox(height: 20),

              // Location
              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(
                  labelText: 'Location',
                  hintText: 'Enter your specific location',
                  prefixIcon: Icon(Icons.location_on, color: AppConfig.primaryColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your location';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Experience
              TextFormField(
                controller: _experienceController,
                decoration: InputDecoration(
                  labelText: 'Years of Experience',
                  hintText: 'e.g., 5 years',
                  prefixIcon: Icon(Icons.work, color: AppConfig.primaryColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your experience';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Genres Selection
              Text(
                'Music Genres (Select all that apply)',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppConfig.textPrimaryColor,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _genres.map((genre) {
                  bool isSelected = _selectedGenres.contains(genre);
                  return FilterChip(
                    label: Text(genre),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedGenres.add(genre);
                        } else {
                          _selectedGenres.remove(genre);
                        }
                      });
                    },
                    selectedColor: AppConfig.primaryColor.withOpacity(0.2),
                    checkmarkColor: AppConfig.primaryColor,
                  );
                }).toList(),
              ),
              if (_selectedGenres.isEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    'Please select at least one genre',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                    ),
                  ),
                ),
              const SizedBox(height: 20),

              // Price Range Section
              Text(
                'Pricing Range',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppConfig.textPrimaryColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Set your minimum and maximum pricing for bookings',
                style: TextStyle(
                  fontSize: 14,
                  color: AppConfig.textSecondaryColor,
                ),
              ),
              const SizedBox(height: 16),

              // Price Range Row
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _minPriceController,
                      decoration: InputDecoration(
                        labelText: 'Minimum Price',
                        hintText: 'e.g., 500K',
                        prefixIcon: Icon(Icons.attach_money, color: AppConfig.primaryColor),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9KkMm₦]')),
                      ],
                      onChanged: (value) {
                        // Format the input
                        String formatted = _formatCurrency(value);
                        if (formatted != value) {
                          _minPriceController.value = TextEditingValue(
                            text: formatted,
                            selection: TextSelection.collapsed(offset: formatted.length),
                          );
                        }
                      },
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter minimum price';
                        }
                        double minPrice = _parseCurrency(value);
                        if (minPrice <= 0) {
                          return 'Please enter a valid price';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _maxPriceController,
                      decoration: InputDecoration(
                        labelText: 'Maximum Price',
                        hintText: 'e.g., 1M',
                        prefixIcon: Icon(Icons.attach_money, color: AppConfig.primaryColor),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9KkMm₦]')),
                      ],
                      onChanged: (value) {
                        // Format the input
                        String formatted = _formatCurrency(value);
                        if (formatted != value) {
                          _maxPriceController.value = TextEditingValue(
                            text: formatted,
                            selection: TextSelection.collapsed(offset: formatted.length),
                          );
                        }
                      },
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter maximum price';
                        }
                        double maxPrice = _parseCurrency(value);
                        if (maxPrice <= 0) {
                          return 'Please enter a valid price';
                        }
                        
                        double minPrice = _parseCurrency(_minPriceController.text);
                        if (maxPrice <= minPrice) {
                          return 'Max price must be higher';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Bio
              TextFormField(
                controller: _bioController,
                decoration: InputDecoration(
                  labelText: 'Bio',
                  hintText: 'Tell us about yourself, your style, and what makes you unique...',
                  prefixIcon: Icon(Icons.info, color: AppConfig.primaryColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your bio';
                  }
                  if (value.trim().length < 50) {
                    return 'Bio must be at least 50 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitApplication,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppConfig.primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Submit Application',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 