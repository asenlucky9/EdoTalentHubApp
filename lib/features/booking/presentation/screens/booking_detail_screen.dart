import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../config/app_config.dart';
import '../../domain/models/booking.dart';
import 'package:hive/hive.dart';
import '../../../artists/domain/models/artist.dart';
import 'booking_screen.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class BookingDetailScreen extends StatefulWidget {
  final Booking booking;
  const BookingDetailScreen({super.key, required this.booking});

  @override
  State<BookingDetailScreen> createState() => _BookingDetailScreenState();
}

class _BookingDetailScreenState extends State<BookingDetailScreen> {
  late Booking _booking;
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _booking = widget.booking;
  }

  Future<void> _refreshBooking() async {
    final box = await Hive.openBox<Booking>('bookings');
    final found = box.values.firstWhere((b) => b.id == _booking.id, orElse: () => _booking);
    setState(() {
      _booking = found;
    });
  }

  Future<void> _handleAction(Future<void> Function() action) async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await action();
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'confirmed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'completed':
        return Colors.blue;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _statusIcon(String status) {
    switch (status) {
      case 'confirmed':
        return Icons.check_circle;
      case 'pending':
        return Icons.hourglass_top;
      case 'completed':
        return Icons.verified;
      case 'cancelled':
        return Icons.cancel;
      default:
        return Icons.info;
    }
  }

  IconData _activityIcon(String status, String? note) {
    switch (status) {
      case 'awaiting_contract_signature':
        return Icons.edit_document;
      case 'awaiting_payment':
        return Icons.account_balance;
      case 'payment_pending_verification':
        return Icons.upload_file;
      case 'booking_confirmed':
        return Icons.verified;
      case 'cancelled':
        return Icons.cancel;
      default:
        if (note != null && note.toLowerCase().contains('receipt')) {
          return Icons.receipt_long;
        }
        return Icons.info;
    }
  }

  String _activityMessage(Map<String, dynamic> entry) {
    final status = entry['status'] ?? '';
    final note = entry['note'] ?? '';
    switch (status) {
      case 'awaiting_contract_signature':
        return 'Contract sent to user';
      case 'awaiting_payment':
        return 'User signed contract';
      case 'payment_pending_verification':
        return 'User uploaded payment receipt';
      case 'booking_confirmed':
        return 'Booking confirmed';
      case 'cancelled':
        return 'Booking cancelled';
      default:
        return note;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConfig.backgroundColor,
      appBar: AppBar(
        title: const Text('Booking Details'),
        backgroundColor: AppConfig.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: _refreshBooking,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_loading)
                const LinearProgressIndicator(),
              if (_error != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(_error!, style: const TextStyle(color: Colors.red)),
                ),
              // Status
              Row(
                children: [
                  Icon(_statusIcon(_booking.status), color: _statusColor(_booking.status), size: 32),
                  const SizedBox(width: 12),
                  Text(
                    _booking.status.toUpperCase(),
                    style: TextStyle(
                      color: _statusColor(_booking.status),
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Activity Timeline
              if (_booking.activityLog.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Activity Timeline', style: TextStyle(fontWeight: FontWeight.bold, color: AppConfig.primaryColor)),
                    const SizedBox(height: 8),
                    ..._booking.activityLog.map((entry) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(_activityIcon(entry['status'] ?? '', entry['note']), size: 18, color: _statusColor(entry['status'] ?? '')),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _activityMessage(entry),
                                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                                    ),
                                    if (entry['filePath'] != null && entry['filePath'].toString().isNotEmpty)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 4),
                                        child: Image.file(
                                          File(entry['filePath']),
                                          width: 80,
                                          height: 80,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    if (entry['timestamp'] != null)
                                      Text(
                                        DateFormat('MMM dd, yyyy • hh:mm a').format(DateTime.tryParse(entry['timestamp']) ?? DateTime.now()),
                                        style: const TextStyle(fontSize: 11, color: Colors.grey),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )),
                    const SizedBox(height: 16),
                  ],
                ),
              // Artist
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: AppConfig.primaryColor.withOpacity(0.1),
                    child: Icon(Icons.person, color: AppConfig.primaryColor),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _booking.artistName ?? '',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: AppConfig.textPrimaryColor,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _booking.artistEmail ?? '',
                          style: TextStyle(
                            color: AppConfig.textSecondaryColor,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.phone, color: AppConfig.primaryColor),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Call: ${_booking.artistPhone}')),
                      );
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.email, color: AppConfig.primaryColor),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Email: ${_booking.artistEmail}')),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Event Info
              _infoRow('Event', _booking.eventType),
              _infoRow('Date', DateFormat('MMM dd, yyyy').format(_booking.eventDate)),
              _infoRow('Time', _booking.specialRequirements?.contains('Time of Day:') == true
                  ? _booking.specialRequirements!.split('Time of Day:').last.trim()
                  : ''),
              _infoRow('Location', _booking.eventLocation),
              _infoRow('Duration', '${_booking.duration} hours'),
              _infoRow('Amount', '₦${_booking.totalAmount.toStringAsFixed(0)}'),
              _infoRow('Payment', _booking.paymentMethod ?? ''),
              if (_booking.specialRequirements != null && _booking.specialRequirements!.isNotEmpty)
                _infoRow('Special', _booking.specialRequirements!.replaceAll('Time of Day:', '').trim()),
              const SizedBox(height: 32),
              // Actions
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.support_agent),
                      label: const Text('Contact Support'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppConfig.primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () async {
                        await _handleAction(() async {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Contacting support...')),
                          );
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  if (_booking.status == 'pending' || _booking.status == 'awaiting_payment')
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.cancel),
                        label: const Text('Cancel'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          side: const BorderSide(color: Colors.red),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () async {
                          await _handleAction(() async {
                            final box = await Hive.openBox<Booking>('bookings');
                            final idx = box.values.toList().indexWhere((b) => b.id == _booking.id);
                            if (idx != -1) {
                              final updated = _booking.copyWith(status: 'cancelled');
                              await box.putAt(idx, updated);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Booking cancelled.')),
                              );
                              Navigator.pop(context); // Go back to list
                            }
                          });
                        },
                      ),
                    ),
                ],
              ),
              // Status-driven actions
              if (_booking.status == 'awaiting_contract_signature')
                Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.edit_document),
                      label: const Text('Sign Contract'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () async {
                        await _handleAction(() async {
                          final box = await Hive.openBox<Booking>('bookings');
                          final idx = box.values.toList().indexWhere((b) => b.id == _booking.id);
                          if (idx != -1) {
                            final updated = _booking.copyWith(
                              status: 'awaiting_payment',
                              activityLog: [
                                ..._booking.activityLog,
                                {
                                  'status': 'awaiting_payment',
                                  'note': 'User signed contract',
                                  'timestamp': DateTime.now().toIso8601String(),
                                },
                              ],
                            );
                            await box.putAt(idx, updated);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Contract signed! Please make payment.')),
                            );
                            Navigator.pop(context);
                          }
                        });
                      },
                    ),
                  ),
                ),
              if (_booking.status == 'awaiting_payment')
                Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ElevatedButton.icon(
                        icon: const Icon(Icons.account_balance),
                        label: const Text('Pay Now (Bank Transfer)'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Bank Transfer Details'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text('Bank: EdoTalentHub Bank'),
                                  Text('Account Name: EdoTalentHub'),
                                  Text('Account Number: 1234567890'),
                                  SizedBox(height: 12),
                                  Text('After payment, please upload your receipt.'),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                      OutlinedButton.icon(
                        icon: const Icon(Icons.upload_file),
                        label: const Text('Upload Receipt'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppConfig.primaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () async {
                          await _handleAction(() async {
                            final picker = ImagePicker();
                            final picked = await picker.pickImage(source: ImageSource.gallery);
                            if (picked != null) {
                              final box = await Hive.openBox<Booking>('bookings');
                              final idx = box.values.toList().indexWhere((b) => b.id == _booking.id);
                              if (idx != -1) {
                                final updated = _booking.copyWith(
                                  status: 'payment_pending_verification',
                                  activityLog: [
                                    ..._booking.activityLog,
                                    {
                                      'status': 'payment_pending_verification',
                                      'note': 'User uploaded payment receipt',
                                      'timestamp': DateTime.now().toIso8601String(),
                                      'filePath': picked.path,
                                    },
                                  ],
                                );
                                await box.putAt(idx, updated);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Receipt uploaded! Waiting for admin confirmation.')),
                                );
                                Navigator.pop(context);
                              }
                            }
                          });
                        },
                      ),
                    ],
                  ),
                ),
              if (_booking.status == 'payment_pending_verification')
                Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(Icons.hourglass_top, color: Colors.orange, size: 40),
                        const SizedBox(height: 8),
                        Text(
                          'Waiting for admin to confirm your payment...',
                          style: TextStyle(
                            color: Colors.orange[800],
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              if (_booking.status == 'booking_confirmed')
                Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(Icons.verified, color: Colors.green, size: 40),
                        const SizedBox(height: 8),
                        Text(
                          'Your booking is confirmed! You will be contacted soon.',
                          style: TextStyle(
                            color: Colors.green[800],
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              if (_booking.status == 'declined')
                Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(Icons.cancel, color: Colors.red, size: 40),
                        const SizedBox(height: 8),
                        Text(
                          'Sorry, your booking was declined by the artist.',
                          style: TextStyle(
                            color: Colors.red[800],
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              // Rebook button
              if (_booking.status == 'completed' || _booking.status == 'cancelled')
                Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: Center(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.repeat),
                      label: const Text('Rebook'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppConfig.primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () async {
                        // Find the artist from sample/mock data (for demo)
                        final artist = _findArtistById(_booking.artistId);
                        if (artist != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BookingScreen(artist: artist),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Artist not found for rebooking.')),
                          );
                        }
                      },
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    if (value.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }

  // Helper to find artist by ID from sample/mock data
  Artist? _findArtistById(String id) {
    // Sample artists for demo purposes
    final allArtists = <Artist>[
      Artist(
        id: '1',
        name: 'Edo Dancers',
        category: 'Dancers',
        bio: 'Traditional Edo dancers for cultural events',
        price: 50000,
        rating: 4.8,
        reviewCount: 25,
        imageUrl: 'assets/images/edo_dancers.png',
        email: 'edodancers@example.com',
        phone: '+2348012345678',
        location: 'Benin City, Edo State',
        experience: '5+ years',
        genres: ['Traditional Dance', 'Cultural Events', 'Weddings'],
        portfolio: ['assets/images/edo_dancers.png'],
      ),
      Artist(
        id: '2',
        name: 'Edo Bronze',
        category: 'Musicians',
        bio: 'Traditional Edo music and instruments',
        price: 75000,
        rating: 4.9,
        reviewCount: 32,
        imageUrl: 'assets/images/edo_bronze.png',
        email: 'edobronze@example.com',
        phone: '+2348098765432',
        location: 'Benin City, Edo State',
        experience: '10+ years',
        genres: ['Traditional Music', 'Cultural Events', 'Ceremonies'],
        portfolio: ['assets/images/edo_bronze.png'],
      ),
    ];
    
    try {
      return allArtists.firstWhere((a) => a.id == id);
    } catch (e) {
      return null;
    }
  }
} 