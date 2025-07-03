import 'package:flutter/material.dart';
import '../../../../config/app_config.dart';

class PrivacyScreen extends StatefulWidget {
  const PrivacyScreen({Key? key}) : super(key: key);

  @override
  State<PrivacyScreen> createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen> {
  bool _showProfile = true;
  bool _allowMessages = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy & Security'),
        backgroundColor: AppConfig.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          SwitchListTile(
            title: const Text('Show my profile to others'),
            value: _showProfile,
            onChanged: (val) {
              setState(() {
                _showProfile = val;
              });
            },
          ),
          SwitchListTile(
            title: const Text('Allow direct messages'),
            value: _allowMessages,
            onChanged: (val) {
              setState(() {
                _allowMessages = val;
              });
            },
          ),
        ],
      ),
    );
  }
} 