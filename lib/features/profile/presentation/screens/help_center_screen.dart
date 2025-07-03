import 'package:flutter/material.dart';
import '../../../../config/app_config.dart';

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help Center'),
        backgroundColor: AppConfig.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: const [
          Text('Frequently Asked Questions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 16),
          Text('Q: How do I book an artist?'),
          Text('A: Go to the search tab, find your preferred artist, and click book.'),
          SizedBox(height: 16),
          Text('Q: How do I contact support?'),
          Text('A: Use the Contact Support option in your profile.'),
          SizedBox(height: 16),
          Text('Q: How do I edit my profile?'),
          Text('A: Tap the edit icon on your profile page.'),
        ],
      ),
    );
  }
} 