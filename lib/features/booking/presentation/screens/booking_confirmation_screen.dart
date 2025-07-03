import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../config/app_config.dart';
import '../../domain/models/booking.dart';
import '../../../dashboard/presentation/screens/dashboard_screen.dart';
import '../../../../shared/utils/booking_utils.dart';

class BookingConfirmationScreen extends StatelessWidget {
  final Booking booking;
  const BookingConfirmationScreen({Key? key, required this.booking}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConfig.backgroundColor,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Animated Success Icon
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.green.withOpacity(0.12),
                  ),
                  padding: const EdgeInsets.all(28),
                  child: Icon(
                    Icons.check_circle_rounded,
                    color: Colors.green,
                    size: 80,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Booking Confirmed!',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: AppConfig.primaryColor,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Your booking was successful. You will receive a confirmation email shortly.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppConfig.textSecondaryColor,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 28),
                // Booking Details Card
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Reference Number - Prominently displayed
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppConfig.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppConfig.primaryColor.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.receipt_long,
                                    color: AppConfig.primaryColor,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Booking Reference',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppConfig.primaryColor,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                BookingUtils.formatReferenceNumber(booking.referenceNumber),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: AppConfig.primaryColor,
                                  letterSpacing: 1.2,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Use this reference for payment and tracking',
                                style: TextStyle(
                                  color: AppConfig.textSecondaryColor,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        _buildDetailRow('Event', booking.eventType),
                        _buildDetailRow('Artist', booking.artistName ?? ''),
                        _buildDetailRow('Date', DateFormat('MMM dd, yyyy').format(booking.eventDate)),
                        if (booking.specialRequirements != null && booking.specialRequirements!.contains('Time of Day:'))
                          _buildDetailRow('Time', booking.specialRequirements!.split('Time of Day:').last.trim()),
                        _buildDetailRow('Location', booking.eventLocation),
                        _buildDetailRow('Duration', '${booking.duration} hours'),
                        _buildDetailRow('Amount', '₦${booking.totalAmount.toStringAsFixed(0)}'),
                        _buildDetailRow('Payment', booking.paymentMethod ?? ''),
                        if (booking.specialRequirements != null && booking.specialRequirements!.isNotEmpty)
                          _buildDetailRow('Special', booking.specialRequirements!.replaceAll('Time of Day:', '').trim()),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConfig.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const DashboardScreen()),
                  (route) => false,
                );
              },
              child: const Text(
                'Return to Home',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            '$label:',
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 15),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
} 