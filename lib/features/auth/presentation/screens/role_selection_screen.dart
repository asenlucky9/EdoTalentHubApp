import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../config/app_config.dart';
import '../../../../shared/services/firebase_user_service.dart';
import 'profile_creation_screen.dart';

enum UserRole {
  customer,
  artist,
  agent,
  admin,
}

class RoleSelectionScreen extends StatefulWidget {
  final dynamic user;
  
  const RoleSelectionScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  UserRole? _selectedRole;
  bool _isLoading = false;

  final List<Map<String, dynamic>> _roles = [
    {
      'role': UserRole.customer,
      'title': 'Customer',
      'description': 'Book artists for your events',
      'icon': Icons.person,
      'color': AppConfig.primaryColor,
    },
    {
      'role': UserRole.artist,
      'title': 'Artist',
      'description': 'Offer your talent and services',
      'icon': Icons.music_note,
      'color': AppConfig.secondaryColor,
    },
    {
      'role': UserRole.agent,
      'title': 'Agent',
      'description': 'Manage bookings and events',
      'icon': Icons.business,
      'color': AppConfig.accentColor,
    },
  ];

  Future<void> _selectRole(UserRole role) async {
    setState(() {
      _selectedRole = role;
      _isLoading = true;
    });

    try {
      // Navigate to profile creation
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ProfileCreationScreen(
              user: widget.user,
              userRole: role.toString().split('.').last,
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              
              // Header
              Text(
                'Welcome to EdoTalentHub!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppConfig.textPrimaryColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'How would you like to use the platform?',
                style: TextStyle(
                  fontSize: 16,
                  color: AppConfig.textSecondaryColor,
                ),
              ),
              const SizedBox(height: 40),

              // Role Selection Cards
              Expanded(
                child: ListView.builder(
                  itemCount: _roles.length,
                  itemBuilder: (context, index) {
                    final role = _roles[index];
                    final isSelected = _selectedRole == role['role'];
                    
                    return GestureDetector(
                      onTap: _isLoading ? null : () => _selectRole(role['role']),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected 
                                ? role['color'] 
                                : Colors.grey.withOpacity(0.2),
                            width: isSelected ? 2 : 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: role['color'].withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                role['icon'],
                                color: role['color'],
                                size: 32,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    role['title'],
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: AppConfig.textPrimaryColor,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    role['description'],
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: AppConfig.textSecondaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (isSelected)
                              Icon(
                                Icons.check_circle,
                                color: role['color'],
                                size: 24,
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Loading indicator
              if (_isLoading)
                Center(
                  child: Column(
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 16),
                      Text(
                        'Setting up your account...',
                        style: TextStyle(
                          color: AppConfig.textSecondaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
} 