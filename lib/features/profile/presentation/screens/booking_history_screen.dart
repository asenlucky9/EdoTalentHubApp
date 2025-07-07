import 'package:flutter/material.dart';
import '../../../../config/app_config.dart';
import 'booking_detail_screen.dart';

class BookingHistoryScreen extends StatelessWidget {
  const BookingHistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bookings = [
      {
        'artist': 'DJ Spinall',
        'date': '2024-05-01',
        'status': 'Completed',
        'location': 'Benin City',
        'price': '₦50,000',
        'contact': '+2348012345678',
        'notes': 'Birthday party',
        'rated': 'false',
      },
      {
        'artist': 'MC Edo',
        'date': '2024-04-15',
        'status': 'Cancelled',
        'location': 'Ekpoma',
        'price': '₦30,000',
        'contact': '+2348098765432',
        'notes': 'Wedding',
        'rated': 'false',
      },
      {
        'artist': 'Edo Dancers',
        'date': '2024-03-20',
        'status': 'Completed',
        'location': 'Auchi',
        'price': '₦70,000',
        'contact': '+2348076543210',
        'notes': 'Cultural event',
        'rated': 'true',
      },
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking History'),
        backgroundColor: AppConfig.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Scrollbar(
        thumbVisibility: true,
        child: ListView.separated(
          itemCount: bookings.length,
          separatorBuilder: (context, i) => const Divider(),
          itemBuilder: (context, i) {
            final b = bookings[i];
            return ListTile(
              leading: const Icon(Icons.event),
              title: Text(b['artist']!),
              subtitle: Text('Date: ${b['date']}'),
              trailing: Text(b['status']!, style: TextStyle(
                color: b['status'] == 'Completed' ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              )),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BookingDetailScreen(booking: Map<String, String>.from(b)),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
} 