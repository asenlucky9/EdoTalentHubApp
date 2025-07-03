class ChatSession {
  final String id;
  final String userId;
  final String agentId;
  final String agentName;
  final DateTime createdAt;
  final DateTime lastMessageAt;
  final bool isActive;
  final String status; // 'active', 'resolved', 'pending'

  ChatSession({
    required this.id,
    required this.userId,
    required this.agentId,
    required this.agentName,
    required this.createdAt,
    required this.lastMessageAt,
    this.isActive = true,
    this.status = 'active',
  });

  factory ChatSession.fromJson(Map<String, dynamic> json) {
    return ChatSession(
      id: json['id'],
      userId: json['userId'],
      agentId: json['agentId'],
      agentName: json['agentName'],
      createdAt: DateTime.parse(json['createdAt']),
      lastMessageAt: DateTime.parse(json['lastMessageAt']),
      isActive: json['isActive'] ?? true,
      status: json['status'] ?? 'active',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'agentId': agentId,
      'agentName': agentName,
      'createdAt': createdAt.toIso8601String(),
      'lastMessageAt': lastMessageAt.toIso8601String(),
      'isActive': isActive,
      'status': status,
    };
  }

  ChatSession copyWith({
    String? id,
    String? userId,
    String? agentId,
    String? agentName,
    DateTime? createdAt,
    DateTime? lastMessageAt,
    bool? isActive,
    String? status,
  }) {
    return ChatSession(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      agentId: agentId ?? this.agentId,
      agentName: agentName ?? this.agentName,
      createdAt: createdAt ?? this.createdAt,
      lastMessageAt: lastMessageAt ?? this.lastMessageAt,
      isActive: isActive ?? this.isActive,
      status: status ?? this.status,
    );
  }
} 