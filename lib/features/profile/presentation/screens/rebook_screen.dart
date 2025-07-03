import 'package:flutter/material.dart';
import '../../../../config/app_config.dart';

class RebookScreen extends StatelessWidget {
  final String artist;
  const RebookScreen({Key? key, required this.artist}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _dateController = TextEditingController();
    final _notesController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rebook Artist'),
        backgroundColor: AppConfig.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Artist', style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(artist, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 24),
            TextField(
              controller: _dateController,
              decoration: const InputDecoration(
                labelText: 'Event Date',
                prefixIcon: Icon(Icons.event),
              ),
              readOnly: true,
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100),
                );
                if (picked != null) {
                  _dateController.text = picked.toString().split(' ')[0];
                }
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'Notes',
                prefixIcon: Icon(Icons.note),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Booking request sent!')),
                  );
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppConfig.primaryColor,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Submit Booking'),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 