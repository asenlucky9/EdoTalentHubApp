import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:edotalenthubapp/config/app_config.dart';
import 'package:edotalenthubapp/shared/models/user_model.dart';
import 'package:edotalenthubapp/shared/providers/user_provider.dart';
import 'package:edotalenthubapp/features/search/presentation/screens/search_screen.dart';
import 'package:edotalenthubapp/features/booking/presentation/screens/bookings_list_screen.dart';
import 'package:edotalenthubapp/features/chat/presentation/screens/chat_screen.dart';

class UserQuickActions extends ConsumerWidget {
  const UserQuickActions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    
    if (user == null) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(20),
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
          Row(
            children: [
              Icon(
                Icons.flash_on,
                color: AppConfig.primaryColor,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'Quick Actions',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppConfig.textPrimaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          // Role-specific actions
          if (user.role == UserRole.customer) _buildCustomerActions(context, user),
          if (user.role == UserRole.artist) _buildArtistActions(context, user),
          if (user.role == UserRole.agent) _buildAgentActions(context, user),
          
          const SizedBox(height: 16),
          
          // Common actions for all users
          _buildCommonActions(context, user),
        ],
      ),
    );
  }

  Widget _buildCustomerActions(BuildContext context, UserModel user) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildQuickActionCard(
                'Book an Artist',
                Icons.event_available,
                AppConfig.primaryColor,
                'Find and book verified Edo talents',
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
                'My Bookings',
                Icons.calendar_month,
                AppConfig.secondaryColor,
                'View and manage your bookings',
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BookingsListScreen(),
                    ),
                  );
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
                'Get Support',
                Icons.support_agent,
                Colors.blue,
                'Chat with our support team',
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ChatScreen(),
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
                Colors.purple,
                'Discover Edo cultural events',
                () {
                  // TODO: Navigate to cultural events
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Cultural events coming soon!')),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildArtistActions(BuildContext context, UserModel user) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildQuickActionCard(
                'My Bookings',
                Icons.calendar_month,
                AppConfig.primaryColor,
                'View incoming bookings',
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BookingsListScreen(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildQuickActionCard(
                'Update Profile',
                Icons.edit,
                AppConfig.secondaryColor,
                'Edit your artist profile',
                () {
                  // TODO: Navigate to artist profile edit
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Artist profile edit coming soon!')),
                  );
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
                'Earnings',
                Icons.account_balance_wallet,
                Colors.green,
                'View your earnings',
                () {
                  // TODO: Navigate to earnings
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Earnings dashboard coming soon!')),
                  );
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildQuickActionCard(
                'Support',
                Icons.support_agent,
                Colors.blue,
                'Get artist support',
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ChatScreen(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAgentActions(BuildContext context, UserModel user) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildQuickActionCard(
                'Manage Bookings',
                Icons.admin_panel_settings,
                AppConfig.primaryColor,
                'Oversee all bookings',
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BookingsListScreen(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildQuickActionCard(
                'Artist Management',
                Icons.people,
                AppConfig.secondaryColor,
                'Manage artist accounts',
                () {
                  // TODO: Navigate to artist management
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Artist management coming soon!')),
                  );
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
                'Reports',
                Icons.analytics,
                Colors.green,
                'View platform analytics',
                () {
                  // TODO: Navigate to reports
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Analytics dashboard coming soon!')),
                  );
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildQuickActionCard(
                'Support',
                Icons.support_agent,
                Colors.blue,
                'Agent support',
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ChatScreen(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCommonActions(BuildContext context, UserModel user) {
    return Column(
      children: [
        const Divider(),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildQuickActionCard(
                'Notifications',
                Icons.notifications,
                Colors.orange,
                'Manage notifications',
                () {
                  // TODO: Navigate to notifications
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Notifications settings coming soon!')),
                  );
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildQuickActionCard(
                'Help Center',
                Icons.help,
                Colors.grey,
                'Get help and support',
                () {
                  // TODO: Navigate to help center
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Help center coming soon!')),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActionCard(
    String title,
    IconData icon,
    Color color,
    String description,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
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
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppConfig.textPrimaryColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: TextStyle(
                fontSize: 11,
                color: AppConfig.textSecondaryColor,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
} 