import 'package:flutter/material.dart';
import '../../../../config/app_config.dart';
import 'rebook_screen.dart';
import 'message_artist_screen.dart';

class BookingDetailScreen extends StatefulWidget {
  final Map<String, String> booking;
  const BookingDetailScreen({Key? key, required this.booking}) : super(key: key);

  @override
  State<BookingDetailScreen> createState() => _BookingDetailScreenState();
}

class _BookingDetailScreenState extends State<BookingDetailScreen> {
  late Map<String, String> booking;
  double? _rating;

  @override
  void initState() {
    super.initState();
    booking = Map<String, String>.from(widget.booking);
    _rating = booking['rated'] == 'true' && booking['rating'] != null
        ? double.tryParse(booking['rating']!)
        : null;
  }

  void _cancelBooking() {
    setState(() {
      booking['status'] = 'Cancelled';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Booking cancelled.')),
    );
  }

  void _showRatingDialog() async {
    double tempRating = 3;
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rate this Booking'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('How would you rate this experience?'),
            const SizedBox(height: 16),
            StatefulBuilder(
              builder: (context, setState) => Slider(
                value: tempRating,
                min: 1,
                max: 5,
                divisions: 4,
                label: tempRating.toStringAsFixed(1),
                onChanged: (val) => setState(() => tempRating = val),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _rating = tempRating;
                booking['rated'] = 'true';
                booking['rating'] = tempRating.toStringAsFixed(1);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Thank you for your rating!')),
              );
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Details'),
        backgroundColor: AppConfig.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Scrollbar(
          thumbVisibility: true,
          child: ListView(
            children: [
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Artist'),
                subtitle: Text(booking['artist'] ?? ''),
              ),
              ListTile(
                leading: const Icon(Icons.event),
                title: const Text('Date'),
                subtitle: Text(booking['date'] ?? ''),
              ),
              ListTile(
                leading: const Icon(Icons.location_on),
                title: const Text('Location'),
                subtitle: Text(booking['location'] ?? ''),
              ),
              ListTile(
                leading: const Icon(Icons.attach_money),
                title: const Text('Price'),
                subtitle: Text(booking['price'] ?? ''),
              ),
              ListTile(
                leading: const Icon(Icons.phone),
                title: const Text('Artist Contact'),
                subtitle: Text(booking['contact'] ?? ''),
              ),
              ListTile(
                leading: const Icon(Icons.info),
                title: const Text('Status'),
                subtitle: Text(booking['status'] ?? ''),
              ),
              if (booking['notes'] != null && booking['notes']!.isNotEmpty)
                ListTile(
                  leading: const Icon(Icons.note),
                  title: const Text('Notes'),
                  subtitle: Text(booking['notes']!),
                ),
              if (booking['status'] == 'Completed')
                ListTile(
                  leading: const Icon(Icons.star),
                  title: const Text('Rating'),
                  subtitle: _rating != null
                      ? Row(
                          children: [
                            ...List.generate(_rating!.round(), (i) => const Icon(Icons.star, color: Colors.amber, size: 20)),
                            ...List.generate(5 - _rating!.round(), (i) => const Icon(Icons.star_border, color: Colors.amber, size: 20)),
                            const SizedBox(width: 8),
                            Text('${_rating!.toStringAsFixed(1)}/5'),
                          ],
                        )
                      : const Text('Not rated yet'),
                ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (booking['status'] != 'Cancelled' && booking['status'] != 'Completed')
                    ElevatedButton(
                      onPressed: _cancelBooking,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppConfig.errorColor,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Cancel Booking'),
                    ),
                  if (booking['status'] == 'Completed' && booking['rated'] != 'true')
                    const SizedBox(width: 16),
                  if (booking['status'] == 'Completed' && booking['rated'] != 'true')
                    ElevatedButton(
                      onPressed: _showRatingDialog,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppConfig.primaryColor,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Rate Booking'),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RebookScreen(artist: booking['artist'] ?? ''),
                        ),
                      );
                    },
                    icon: const Icon(Icons.repeat),
                    label: const Text('Rebook'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppConfig.primaryColor,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MessageArtistScreen(artist: booking['artist'] ?? ''),
                        ),
                      );
                    },
                    icon: const Icon(Icons.message),
                    label: const Text('Message Artist'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppConfig.secondaryColor,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Center(
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppConfig.primaryColor,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Back'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 