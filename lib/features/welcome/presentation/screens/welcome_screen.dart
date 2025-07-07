import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../config/app_config.dart';
import '../../../dashboard/presentation/screens/dashboard_screen.dart';
import '../../../auth/presentation/screens/auth_screen.dart';
// import your login and signup screens if available
// import '../../../auth/presentation/screens/login_screen.dart';
// import '../../../auth/presentation/screens/signup_screen.dart';

class WelcomeScreen extends ConsumerWidget {
  const WelcomeScreen({super.key});

  void _navigateToDashboard(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const DashboardScreen()),
    );
  }

  void _navigateToLogin(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AuthScreen()),
    );
  }

  void _navigateToSignUp(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AuthScreen()),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextEditingController spouseController = TextEditingController();
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF8FAF5), Color(0xFFE8F5E9)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
              child: Scrollbar(
                thumbVisibility: true,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo in circular box
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.07),
                              blurRadius: 16,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/images/edo_bronze.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),
                      // App Name
                      Text(
                        'EdoTalentHub',
                        style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                          color: AppConfig.primaryColor,
                          letterSpacing: 1.2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      // Tagline
                      Text(
                        'Connecting Edo Talents to the World',
                        style: TextStyle(
                          fontSize: 18,
                          color: AppConfig.textSecondaryColor,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      // Spouse Name Field
                      TextField(
                        controller: spouseController,
                        decoration: InputDecoration(
                          labelText: 'Spouse Name (optional)',
                          prefixIcon: Icon(Icons.favorite, color: AppConfig.primaryColor),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                          fillColor: Colors.white,
                          filled: true,
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Promotional Section
                      Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        color: AppConfig.primaryColor.withOpacity(0.07),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.verified, color: AppConfig.primaryColor, size: 22),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text('Verified Entertainers & Event Pros', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Icon(Icons.lock, color: AppConfig.primaryColor, size: 22),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text('Secure Bookings & Payments', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Icon(Icons.event_available, color: AppConfig.primaryColor, size: 22),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text('No Double Booking Guarantee', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      // Sign In Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => _navigateToLogin(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppConfig.primaryColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 2,
                          ),
                          child: const Text(
                            'Sign In',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Explore as Guest Button
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () => _navigateToDashboard(context),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppConfig.primaryColor,
                            side: BorderSide(color: AppConfig.primaryColor, width: 2),
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Text(
                            'Explore as Guest',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Sign Up Text Button
                      TextButton(
                        onPressed: () => _navigateToSignUp(context),
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                            color: AppConfig.primaryColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
} 