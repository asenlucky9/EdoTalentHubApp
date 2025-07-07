import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';

import '../../../../config/app_config.dart';
import '../../../../shared/models/user_model.dart';
import '../../../../shared/providers/user_provider.dart';
import 'edit_profile_screen.dart';
import 'notifications_screen.dart';
import 'privacy_screen.dart';
import 'payment_methods_screen.dart';
import 'booking_history_screen.dart';
import 'help_center_screen.dart';
import 'contact_support_screen.dart';
import 'feedback_screen.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(currentUserProvider);
    print('Current user: ' + userAsync.toString());
    if (userAsync == null) {
      return Scaffold(
        backgroundColor: AppConfig.backgroundColor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(
                'Loading profile... (No user found)',
                style: TextStyle(
                  color: AppConfig.textSecondaryColor,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final user = userAsync;
    final userActions = ref.read(userActionsProvider);
    
    return Scaffold(
      backgroundColor: AppConfig.backgroundColor,
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: AppConfig.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () async {
              final updatedUser = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProfileScreen(user: user),
                ),
              );
              if (updatedUser != null && updatedUser is UserModel) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Profile updated successfully!')),
                );
              }
            },
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
      body: Scrollbar(
        thumbVisibility: true,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Header
              Center(
                child: Column(
                  children: [
                    // Profile Avatar
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppConfig.primaryColor.withOpacity(0.1),
                        border: Border.all(
                          color: AppConfig.primaryColor,
                          width: 3,
                        ),
                      ),
                      child: user.profileImageUrl != null
                          ? ClipOval(
                              child: Image.network(
                                user.profileImageUrl!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return _buildAvatarFallback(user);
                                },
                              ),
                            )
                          : _buildAvatarFallback(user),
                    ),
                    const SizedBox(height: 16),
                    
                    // User Name
                    Text(
                      user.fullName,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppConfig.textPrimaryColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    
                    // User Email
                    Text(
                      user.email,
                      style: const TextStyle(
                        color: AppConfig.textSecondaryColor,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    
                    // Verification Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppConfig.successColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.verified,
                            color: AppConfig.successColor,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Verified Account',
                            style: TextStyle(
                              color: AppConfig.successColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Personal Information Section
              _buildSection(
                title: 'Personal Information',
                children: [
                  _buildInfoTile(
                    icon: Icons.person,
                    title: 'Full Name',
                    subtitle: user.fullName,
                  ),
                  _buildInfoTile(
                    icon: Icons.email,
                    title: 'Email',
                    subtitle: user.email,
                    trailing: user.isEmailVerified
                        ? const Icon(Icons.verified, color: AppConfig.successColor, size: 20)
                        : null,
                  ),
                  _buildInfoTile(
                    icon: Icons.phone,
                    title: 'Phone Number',
                    subtitle: user.phoneNumber ?? 'Not provided',
                    trailing: user.isPhoneVerified
                        ? const Icon(Icons.verified, color: AppConfig.successColor, size: 20)
                        : null,
                  ),
                  _buildInfoTile(
                    icon: Icons.location_on,
                    title: 'Location',
                    subtitle: user.location ?? 'Not specified',
                  ),
                  if (user.bio != null)
                    _buildInfoTile(
                      icon: Icons.info,
                      title: 'Bio',
                      subtitle: user.bio!,
                    ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // Account Settings Section
              _buildSection(
                title: 'Account Settings',
                children: [
                  _buildSettingsTile(
                    icon: Icons.notifications,
                    title: 'Notifications',
                    subtitle: 'Manage your notification preferences',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const NotificationsScreen()),
                    ),
                  ),
                  _buildSettingsTile(
                    icon: Icons.security,
                    title: 'Privacy & Security',
                    subtitle: 'Manage your privacy settings',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const PrivacyScreen()),
                    ),
                  ),
                  _buildSettingsTile(
                    icon: Icons.payment,
                    title: 'Payment Methods',
                    subtitle: 'Manage your payment options',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const PaymentMethodsScreen()),
                    ),
                  ),
                  _buildSettingsTile(
                    icon: Icons.history,
                    title: 'Booking History',
                    subtitle: 'View your past bookings',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const BookingHistoryScreen()),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // Support Section
              _buildSection(
                title: 'Support & Help',
                children: [
                  _buildSettingsTile(
                    icon: Icons.help,
                    title: 'Help Center',
                    subtitle: 'Get help and find answers',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const HelpCenterScreen()),
                    ),
                  ),
                  _buildSettingsTile(
                    icon: Icons.contact_support,
                    title: 'Contact Support',
                    subtitle: 'Get in touch with our team',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ContactSupportScreen()),
                    ),
                  ),
                  _buildSettingsTile(
                    icon: Icons.feedback,
                    title: 'Send Feedback',
                    subtitle: 'Help us improve EdoTalentHub',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const FeedbackScreen()),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // App Info Section
              _buildSection(
                title: 'App Information',
                children: [
                  _buildInfoTile(
                    icon: Icons.info,
                    title: 'App Version',
                    subtitle: '${AppConfig.appVersion}',
                  ),
                  _buildInfoTile(
                    icon: Icons.calendar_today,
                    title: 'Member Since',
                    subtitle: _formatDate(user.createdAt),
                  ),
                  _buildInfoTile(
                    icon: Icons.access_time,
                    title: 'Last Login',
                    subtitle: _formatDate(user.lastLoginAt ?? DateTime.now()),
                  ),
                ],
              ),
              
              const SizedBox(height: 32),
              
              // Logout Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _showLogoutDialog(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppConfig.errorColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppConfig.radiusM),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Logout',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarFallback(UserModel user) {
    return Center(
      child: Text(
        user.initials,
        style: const TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.bold,
          color: AppConfig.primaryColor,
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppConfig.textPrimaryColor,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppConfig.radiusL),
            boxShadow: AppConfig.cardShadow,
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppConfig.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppConfig.radiusM),
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
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppConfig.textSecondaryColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppConfig.textPrimaryColor,
                  ),
                ),
              ],
            ),
          ),
          if (trailing != null) trailing,
        ],
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppConfig.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppConfig.radiusM),
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
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppConfig.textPrimaryColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppConfig.textSecondaryColor,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: AppConfig.textSecondaryColor,
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showLogoutDialog() {
    final userActions = ref.read(userActionsProvider);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await userActions.signOut();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Logged out successfully!'),
                  ),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error logging out: $e'),
                  ),
                );
              }
            },
            style: TextButton.styleFrom(
              foregroundColor: AppConfig.errorColor,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
} 