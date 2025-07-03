import 'package:hive/hive.dart';

part 'booking.g.dart';

@HiveType(typeId: 1)
class Booking {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String customerId;
  @HiveField(2)
  final String artistId;
  @HiveField(3)
  final String eventType;
  @HiveField(4)
  final DateTime eventDate;
  @HiveField(5)
  final String eventLocation;
  @HiveField(6)
  final int duration; // in hours
  @HiveField(7)
  final double totalAmount;
  @HiveField(8)
  final String status; // pending, confirmed, completed, cancelled
  @HiveField(9)
  final String? specialRequirements;
  @HiveField(10)
  final DateTime createdAt;
  @HiveField(11)
  final DateTime? updatedAt;
  @HiveField(12)
  final String? paymentStatus; // pending, paid, refunded
  @HiveField(13)
  final String? paymentMethod;
  @HiveField(14)
  final String? transactionId;
  @HiveField(15)
  final String? customerName;
  @HiveField(16)
  final String? customerPhone;
  @HiveField(17)
  final String? customerEmail;
  @HiveField(18)
  final String? artistName;
  @HiveField(19)
  final String? artistPhone;
  @HiveField(20)
  final String? artistEmail;
  @HiveField(21)
  final String? selectedMCId;
  @HiveField(22)
  final String? selectedMCName;
  @HiveField(23)
  final String? selectedVideographerId;
  @HiveField(24)
  final String? selectedVideographerName;
  @HiveField(25)
  final String? selectedVenueId;
  @HiveField(26)
  final String? selectedVenueName;
  @HiveField(27)
  final List<Map<String, dynamic>> activityLog;
  @HiveField(28)
  final String referenceNumber;
  @HiveField(29)
  final String? artistImageUrl;

  Booking({
    required this.id,
    required this.customerId,
    required this.artistId,
    required this.eventType,
    required this.eventDate,
    required this.eventLocation,
    required this.duration,
    required this.totalAmount,
    required this.status,
    this.specialRequirements,
    DateTime? createdAt,
    this.updatedAt,
    this.paymentStatus = 'pending',
    this.paymentMethod,
    this.transactionId,
    this.customerName,
    this.customerPhone,
    this.customerEmail,
    this.artistName,
    this.artistPhone,
    this.artistEmail,
    this.selectedMCId,
    this.selectedMCName,
    this.selectedVideographerId,
    this.selectedVideographerName,
    this.selectedVenueId,
    this.selectedVenueName,
    this.activityLog = const [],
    required this.referenceNumber,
    this.artistImageUrl,
  }) : createdAt = createdAt ?? DateTime.now();

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'] as String,
      customerId: json['customerId'] as String,
      artistId: json['artistId'] as String,
      eventType: json['eventType'] as String,
      eventDate: DateTime.parse(json['eventDate'] as String),
      eventLocation: json['eventLocation'] as String,
      duration: json['duration'] as int,
      totalAmount: (json['totalAmount'] as num).toDouble(),
      status: json['status'] as String,
      specialRequirements: json['specialRequirements'] as String?,
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null 
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
      paymentStatus: json['paymentStatus'] as String?,
      paymentMethod: json['paymentMethod'] as String?,
      transactionId: json['transactionId'] as String?,
      customerName: json['customerName'] as String?,
      customerPhone: json['customerPhone'] as String?,
      customerEmail: json['customerEmail'] as String?,
      artistName: json['artistName'] as String?,
      artistPhone: json['artistPhone'] as String?,
      artistEmail: json['artistEmail'] as String?,
      selectedMCId: json['selectedMCId'] as String?,
      selectedMCName: json['selectedMCName'] as String?,
      selectedVideographerId: json['selectedVideographerId'] as String?,
      selectedVideographerName: json['selectedVideographerName'] as String?,
      selectedVenueId: json['selectedVenueId'] as String?,
      selectedVenueName: json['selectedVenueName'] as String?,
      activityLog: (json['activityLog'] as List<dynamic>?)?.map((e) => Map<String, dynamic>.from(e)).toList() ?? [],
      referenceNumber: json['referenceNumber'] as String,
      artistImageUrl: json['artistImageUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerId': customerId,
      'artistId': artistId,
      'eventType': eventType,
      'eventDate': eventDate.toIso8601String(),
      'eventLocation': eventLocation,
      'duration': duration,
      'totalAmount': totalAmount,
      'status': status,
      'specialRequirements': specialRequirements,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'paymentStatus': paymentStatus,
      'paymentMethod': paymentMethod,
      'transactionId': transactionId,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'customerEmail': customerEmail,
      'artistName': artistName,
      'artistPhone': artistPhone,
      'artistEmail': artistEmail,
      'selectedMCId': selectedMCId,
      'selectedMCName': selectedMCName,
      'selectedVideographerId': selectedVideographerId,
      'selectedVideographerName': selectedVideographerName,
      'selectedVenueId': selectedVenueId,
      'selectedVenueName': selectedVenueName,
      'activityLog': activityLog,
      'referenceNumber': referenceNumber,
      'artistImageUrl': artistImageUrl,
    };
  }

  Booking copyWith({
    String? id,
    String? customerId,
    String? artistId,
    String? eventType,
    DateTime? eventDate,
    String? eventLocation,
    int? duration,
    double? totalAmount,
    String? status,
    String? specialRequirements,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? paymentStatus,
    String? paymentMethod,
    String? transactionId,
    String? customerName,
    String? customerPhone,
    String? customerEmail,
    String? artistName,
    String? artistPhone,
    String? artistEmail,
    String? selectedMCId,
    String? selectedMCName,
    String? selectedVideographerId,
    String? selectedVideographerName,
    String? selectedVenueId,
    String? selectedVenueName,
    List<Map<String, dynamic>>? activityLog,
    String? referenceNumber,
    String? artistImageUrl,
  }) {
    return Booking(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      artistId: artistId ?? this.artistId,
      eventType: eventType ?? this.eventType,
      eventDate: eventDate ?? this.eventDate,
      eventLocation: eventLocation ?? this.eventLocation,
      duration: duration ?? this.duration,
      totalAmount: totalAmount ?? this.totalAmount,
      status: status ?? this.status,
      specialRequirements: specialRequirements ?? this.specialRequirements,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      transactionId: transactionId ?? this.transactionId,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      customerEmail: customerEmail ?? this.customerEmail,
      artistName: artistName ?? this.artistName,
      artistPhone: artistPhone ?? this.artistPhone,
      artistEmail: artistEmail ?? this.artistEmail,
      selectedMCId: selectedMCId ?? this.selectedMCId,
      selectedMCName: selectedMCName ?? this.selectedMCName,
      selectedVideographerId: selectedVideographerId ?? this.selectedVideographerId,
      selectedVideographerName: selectedVideographerName ?? this.selectedVideographerName,
      selectedVenueId: selectedVenueId ?? this.selectedVenueId,
      selectedVenueName: selectedVenueName ?? this.selectedVenueName,
      activityLog: activityLog ?? this.activityLog,
      referenceNumber: referenceNumber ?? this.referenceNumber,
      artistImageUrl: artistImageUrl ?? this.artistImageUrl,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Booking && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Booking(id: $id, referenceNumber: $referenceNumber, eventType: $eventType, eventDate: $eventDate, status: $status)';
  }
} 