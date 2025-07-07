import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../config/app_config.dart';
import '../../domain/models/message.dart';
import '../../domain/models/chat_session.dart';
import '../widgets/quick_response_button.dart';
import '../widgets/message_bubble.dart';
import '../../../booking/domain/models/booking.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  
  bool _isTyping = false;
  bool _isAgentOnline = true;
  bool _hasIdentifiedCustomer = false;
  String? _customerName;
  String? _customerEmail;
  List<Booking> _customerBookings = [];
  
  // Mock chat session
  late ChatSession _chatSession;
  List<Message> _messages = [];
  
  // Quick responses for common questions
  final List<String> _quickResponses = [
    'My name is John Doe',
    'My email is john.doe@example.com',
    'Check my booking status',
    'I need help with payment',
    'How do I cancel a booking?',
  ];

  @override
  void initState() {
    super.initState();
    _initializeChat();
    _loadMockMessages();
    _loadMockCustomerData();
  }

  void _initializeChat() {
    _chatSession = ChatSession(
      id: 'chat_${DateTime.now().millisecondsSinceEpoch}',
      userId: 'user_123',
      agentId: 'agent_001',
      agentName: 'EdoTalent Support',
      createdAt: DateTime.now(),
      lastMessageAt: DateTime.now(),
    );
  }

  void _loadMockMessages() {
    _messages = [
      Message(
        id: '1',
        senderId: 'agent_001',
        senderName: 'EdoTalent Support',
        content: 'Hello! Welcome to EdoTalentHub Support. I\'m here to help you with any questions about your bookings, payments, or our services.\n\nTo provide you with the best assistance, could you please tell me your name or email address? This will help me look up your account and booking information.',
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
        isFromAgent: true,
      ),
    ];
  }

  void _loadMockCustomerData() async {
    // Temporarily disabled for web compatibility
    // final userId = FirebaseAuth.instance.currentUser?.uid;
    // final query = await FirebaseFirestore.instance
    //     .collection('bookings')
    //     .where('customerId', isEqualTo: userId)
    //     .get();
    
    // Demo data for testing
    final userId = 'demo_user_id';
    _customerBookings = <Booking>[]; // Empty list for demo
    setState(() {});
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    final userMessage = _messageController.text.trim();
    final message = Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: 'user_123',
      senderName: 'You',
      content: userMessage,
      timestamp: DateTime.now(),
      isFromAgent: false,
    );

    setState(() {
      _messages.add(message);
    });

    _messageController.clear();
    _scrollToBottom();

    // Process the message and generate intelligent response
    _processUserMessage(userMessage);
  }

  void _processUserMessage(String userMessage) {
    setState(() {
      _isTyping = true;
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        final response = _generateIntelligentResponse(userMessage);
        
        final agentMessage = Message(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          senderId: 'agent_001',
          senderName: 'EdoTalent Support',
          content: response,
          timestamp: DateTime.now(),
          isFromAgent: true,
        );

        setState(() {
          _messages.add(agentMessage);
          _isTyping = false;
        });

        _scrollToBottom();
      }
    });
  }

  String _generateIntelligentResponse(String userMessage) {
    final lowerMessage = userMessage.toLowerCase();
    
    // Check if user is providing identification
    if (!_hasIdentifiedCustomer) {
      if (_extractEmail(userMessage) != null) {
        _customerEmail = _extractEmail(userMessage);
        _hasIdentifiedCustomer = true;
        // Send both welcome and booking status
        Future.delayed(const Duration(milliseconds: 100), () {
          final statusMsg = Message(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            senderId: 'agent_001',
            senderName: 'EdoTalent Support',
            content: _generateBookingStatusResponse(),
            timestamp: DateTime.now(),
            isFromAgent: true,
          );
          setState(() {
            _messages.add(statusMsg);
          });
          _scrollToBottom();
        });
        return _generateWelcomeResponse();
      } else if (_extractName(userMessage) != null) {
        _customerName = _extractName(userMessage);
        _hasIdentifiedCustomer = true;
        // Send both welcome and booking status
        Future.delayed(const Duration(milliseconds: 100), () {
          final statusMsg = Message(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            senderId: 'agent_001',
            senderName: 'EdoTalent Support',
            content: _generateBookingStatusResponse(),
            timestamp: DateTime.now(),
            isFromAgent: true,
          );
          setState(() {
            _messages.add(statusMsg);
          });
          _scrollToBottom();
        });
        return _generateWelcomeResponse();
      } else if (lowerMessage.contains('help') || lowerMessage.contains('booking') || lowerMessage.contains('payment')) {
        // Handle help requests from unidentified customers
        return 'I\'d be happy to help you! To provide you with the most accurate assistance, I need to identify your account first.\n\n' +
               'Could you please provide your:\n' +
               '• Email address, or\n' +
               '• Full name\n\n' +
               'This will help me look up your bookings and provide personalized support.';
      } else {
        return 'I couldn\'t find your email or name in that message. Could you please provide your email address or full name so I can look up your account?';
      }
    }

    // Handle reference number lookups
    final referenceNumber = _extractReferenceNumber(userMessage);
    if (referenceNumber != null) {
      return _generateReferenceNumberResponse(referenceNumber);
    }

    // Handle booking status inquiries
    if (lowerMessage.contains('status') || lowerMessage.contains('booking')) {
      return _generateBookingStatusResponse();
    }

    // Handle payment inquiries
    if (lowerMessage.contains('payment') || lowerMessage.contains('pay') || lowerMessage.contains('money')) {
      return _generatePaymentResponse();
    }

    // Handle cancellation requests
    if (lowerMessage.contains('cancel') || lowerMessage.contains('refund')) {
      return _generateCancellationResponse();
    }

    // Handle artist contact requests
    if (lowerMessage.contains('artist') || lowerMessage.contains('contact') || lowerMessage.contains('call')) {
      return _generateArtistContactResponse();
    }

    // Handle general help requests
    if (lowerMessage.contains('help') || lowerMessage.contains('issue') || lowerMessage.contains('problem')) {
      return _generateGeneralHelpResponse();
    }

    // Default response
    return _generateDefaultResponse();
  }

  String? _extractEmail(String message) {
    final emailRegex = RegExp(r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b');
    final match = emailRegex.firstMatch(message);
    return match?.group(0);
  }

  String? _extractName(String message) {
    // Simple name extraction - look for common name patterns
    final words = message.split(' ');
    for (int i = 0; i < words.length - 1; i++) {
      final potentialName = '${words[i]} ${words[i + 1]}';
      if (potentialName.length >= 3 && 
          !potentialName.toLowerCase().contains('my') &&
          !potentialName.toLowerCase().contains('is') &&
          !potentialName.toLowerCase().contains('the')) {
        return potentialName;
      }
    }
    return null;
  }

  String? _extractReferenceNumber(String message) {
    // Look for ETH- pattern followed by alphanumeric characters
    final refRegex = RegExp(r'ETH-\d{8}-[A-Z0-9]{5}', caseSensitive: false);
    final match = refRegex.firstMatch(message);
    return match?.group(0)?.toUpperCase();
  }

  String _generateWelcomeResponse() {
    final name = _customerName ?? 'there';
    final bookingCount = _customerBookings.length;
    
    return 'Welcome back, $name! 👋\n\nI found your account with $bookingCount booking${bookingCount != 1 ? 's' : ''}.\n\nHow can I help you today? You can:\n• Check your booking status\n• Get help with payments\n• Contact your artists\n• Report any issues\n\nJust let me know what you need!';
  }

  String _generateReferenceNumberResponse(String referenceNumber) {
    try {
      final booking = _customerBookings.firstWhere(
        (b) => b.referenceNumber.toUpperCase() == referenceNumber.toUpperCase(),
      );

      final status = _getStatusDescription(booking.status);
      final date = DateFormat('MMM dd, yyyy').format(booking.eventDate);
      
      String response = 'I found your booking with reference **${booking.referenceNumber}**:\n\n';
      response += '📅 **Event Type:** ${booking.eventType}\n';
      response += '📍 **Location:** ${booking.eventLocation}\n';
      response += '📅 **Date:** $date\n';
      response += '⏰ **Duration:** ${booking.duration} hours\n';
      response += '🎭 **Artist:** ${booking.artistName}\n';
      response += '💰 **Amount:** ₦${booking.totalAmount.toStringAsFixed(0)}\n';
      response += '📋 **Status:** $status\n\n';

      // Add specific information based on status
      switch (booking.status) {
        case 'awaiting_payment':
          response += '💳 **Payment Required**\n';
          response += 'Please complete your payment to confirm this booking.\n';
          break;
        case 'payment_pending_verification':
          response += '🔍 **Payment Under Review**\n';
          response += 'We\'re verifying your payment. You\'ll be notified once confirmed.\n';
          break;
        case 'confirmed':
          response += '✅ **Booking Confirmed**\n';
          response += 'Your booking is confirmed! Your artist will contact you soon.\n';
          break;
        case 'completed':
          response += '✅ **Event Completed**\n';
          response += 'Your event has been completed successfully.\n';
          break;
        case 'cancelled':
          response += '❌ **Booking Cancelled**\n';
          response += 'This booking has been cancelled.\n';
          break;
      }

      // Add artist contact info for active bookings
      if (booking.status != 'completed' && booking.status != 'cancelled') {
        if (booking.artistPhone != null || booking.artistEmail != null) {
          response += '\n📞 **Artist Contact:**\n';
          if (booking.artistPhone != null) {
            response += 'Phone: ${booking.artistPhone}\n';
          }
          if (booking.artistEmail != null) {
            response += 'Email: ${booking.artistEmail}\n';
          }
        }
      }

      response += '\nNeed help with this booking?';
      return response;
    } catch (e) {
      return 'I couldn\'t find a booking with reference number **$referenceNumber** in your account.\n\n' +
             'Please check the reference number and try again, or provide your email/name so I can look up your bookings.';
    }
  }

  String _generateBookingStatusResponse() {
    if (_customerBookings.isEmpty) {
      return 'I don\'t see any bookings in your account yet. Would you like to make a new booking or do you have a reference number I can look up?';
    }

    final activeBookings = _customerBookings.where((b) => 
      b.status != 'completed' && b.status != 'cancelled'
    ).toList();

    if (activeBookings.isEmpty) {
      return 'All your bookings have been completed or cancelled. Would you like to make a new booking?';
    }

    String response = 'Here are your active bookings:\n\n';
    
    for (final booking in activeBookings) {
      final status = _getStatusDescription(booking.status);
      final date = DateFormat('MMM dd, yyyy').format(booking.eventDate);
      
      response += '📅 **${booking.eventType}**\n';
      response += '📍 ${booking.eventLocation}\n';
      response += '📅 $date\n';
      response += '🎭 ${booking.artistName}\n';
      response += '💰 ₦${booking.totalAmount.toStringAsFixed(0)}\n';
      response += '📋 Status: $status\n';
      response += '🔢 Ref: ${booking.referenceNumber}\n\n';
    }

    response += 'Need help with any of these bookings?';
    return response;
  }

  String _getStatusDescription(String status) {
    switch (status) {
      case 'pending': return '⏳ Pending';
      case 'confirmed': return '✅ Confirmed';
      case 'awaiting_payment': return '💳 Awaiting Payment';
      case 'payment_pending_verification': return '🔍 Payment Verification';
      case 'booking_confirmed': return '✅ Booking Confirmed';
      case 'completed': return '✅ Completed';
      case 'cancelled': return '❌ Cancelled';
      default: return status;
    }
  }

  String _generatePaymentResponse() {
    final pendingPayments = _customerBookings.where((b) => 
      b.status == 'awaiting_payment' || b.status == 'payment_pending_verification'
    ).toList();

    if (pendingPayments.isEmpty) {
      return 'I don\'t see any pending payments in your account. All your bookings are either paid or completed. Is there something specific about payments you\'d like to know?';
    }

    String response = 'I found ${pendingPayments.length} booking${pendingPayments.length != 1 ? 's' : ''} with pending payments:\n\n';
    
    for (final booking in pendingPayments) {
      response += '🔢 **Reference:** ${booking.referenceNumber}\n';
      response += '💰 **Amount:** ₦${booking.totalAmount.toStringAsFixed(0)}\n';
      response += '📅 **Event:** ${booking.eventType} on ${DateFormat('MMM dd, yyyy').format(booking.eventDate)}\n';
      
      if (booking.status == 'awaiting_payment') {
        response += '💳 **Status:** Payment Required\n';
        response += 'Please make payment via bank transfer to complete your booking.\n\n';
      } else {
        response += '🔍 **Status:** Payment Under Review\n';
        response += 'We\'re verifying your payment. You\'ll be notified once confirmed.\n\n';
      }
    }

    response += 'Need help with the payment process?';
    return response;
  }

  String _generateCancellationResponse() {
    final cancellableBookings = _customerBookings.where((b) => 
      b.status == 'pending' || b.status == 'confirmed'
    ).toList();

    if (cancellableBookings.isEmpty) {
      return 'I don\'t see any bookings that can be cancelled at the moment. All your bookings are either completed, already cancelled, or in a final stage.\n\nIf you need to cancel a booking, please provide the reference number.';
    }

    String response = 'I found ${cancellableBookings.length} booking${cancellableBookings.length != 1 ? 's' : ''} that can be cancelled:\n\n';
    
    for (final booking in cancellableBookings) {
      response += '🔢 **Reference:** ${booking.referenceNumber}\n';
      response += '📅 **Event:** ${booking.eventType} on ${DateFormat('MMM dd, yyyy').format(booking.eventDate)}\n';
      response += '💰 **Amount:** ₦${booking.totalAmount.toStringAsFixed(0)}\n\n';
    }

    response += 'To cancel a booking, please provide the reference number and I\'ll help you with the process.';
    return response;
  }

  String _generateArtistContactResponse() {
    final activeBookings = _customerBookings.where((b) => 
      b.status != 'completed' && b.status != 'cancelled'
    ).toList();

    if (activeBookings.isEmpty) {
      return 'I don\'t see any active bookings where you need to contact artists. Would you like to make a new booking?';
    }

    String response = 'Here are your artists\' contact information:\n\n';
    
    for (final booking in activeBookings) {
      response += '🎭 **${booking.artistName}**\n';
      response += '📅 ${booking.eventType} on ${DateFormat('MMM dd, yyyy').format(booking.eventDate)}\n';
      if (booking.artistPhone != null) {
        response += '📞 Phone: ${booking.artistPhone}\n';
      }
      if (booking.artistEmail != null) {
        response += '📧 Email: ${booking.artistEmail}\n';
      }
      response += '\n';
    }

    response += 'You can contact them directly or I can help you send a message.';
    return response;
  }

  String _generateGeneralHelpResponse() {
    return 'I\'m here to help! Here are some common things I can assist you with:\n\n' +
           '🔍 **Check booking status** - I can look up your bookings\n' +
           '💳 **Payment issues** - Help with payments and refunds\n' +
           '📞 **Contact artists** - Get artist contact information\n' +
           '❌ **Cancellations** - Help cancel or modify bookings\n' +
           '📋 **General questions** - About our services\n\n' +
           'What specific issue are you experiencing?';
  }

  String _generateDefaultResponse() {
    return 'I understand you\'re asking about something. To provide you with the most accurate help, could you please:\n\n' +
           '1. Be more specific about what you need\n' +
           '2. Provide a booking reference number if applicable\n' +
           '3. Tell me if this is about payments, bookings, or something else\n\n' +
           'I\'m here to help, but I need a bit more information to assist you properly!';
  }

  List<String> _getQuickResponses() {
    if (!_hasIdentifiedCustomer) {
      return [
        'My name is John Doe',
        'My email is john.doe@example.com',
        'I need help with a booking',
        'How do I make a new booking?',
        'What payment methods do you accept?',
      ];
    } else {
      return [
        'Check my booking status',
        'I need help with payment',
        'How do I cancel a booking?',
        'Contact an artist',
        'Report an issue',
      ];
    }
  }

  void _sendQuickResponse(String response) {
    final message = Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: 'user_123',
      senderName: 'You',
      content: response,
      timestamp: DateTime.now(),
      isFromAgent: false,
    );

    setState(() {
      _messages.add(message);
    });

    _scrollToBottom();
    _processUserMessage(response);
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConfig.backgroundColor,
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: AppConfig.primaryColor,
              child: const Icon(Icons.support_agent, color: Colors.white),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _chatSession.agentName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _isAgentOnline ? Colors.green : Colors.grey,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _isAgentOnline ? 'Online' : 'Offline',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        backgroundColor: AppConfig.primaryColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {
              // TODO: Show chat options
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Quick Responses
          if (_messages.length <= 3)
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _hasIdentifiedCustomer ? 'Quick Actions' : 'Quick Identification',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppConfig.textSecondaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _getQuickResponses().map((response) => 
                      QuickResponseButton(
                        text: response,
                        onTap: () => _sendQuickResponse(response),
                      ),
                    ).toList(),
                  ),
                ],
              ),
            ),
          
          // Messages
          Expanded(
            child: Scrollbar(
              thumbVisibility: true,
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: _messages.length + (_isTyping ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == _messages.length && _isTyping) {
                    return _buildTypingIndicator();
                  }
                  return MessageBubble(message: _messages[index]);
                },
              ),
            ),
          ),
          
          // Message Input
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTypingDot(0),
                _buildTypingDot(1),
                _buildTypingDot(2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypingDot(int index) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 600 + (index * 200)),
      margin: const EdgeInsets.symmetric(horizontal: 2),
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: Colors.grey[600],
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(24),
              ),
              child: TextField(
                controller: _messageController,
                focusNode: _focusNode,
                decoration: const InputDecoration(
                  hintText: 'Type your message...',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                maxLines: null,
                textCapitalization: TextCapitalization.sentences,
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(
              color: AppConfig.primaryColor,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white),
              onPressed: _sendMessage,
            ),
          ),
        ],
      ),
    );
  }
} 