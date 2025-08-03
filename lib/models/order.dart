enum OrderStatus { pending, inProgress, completed, cancelled }

extension OrderStatusExtension on OrderStatus {
  String get displayName {
    switch (this) {
      case OrderStatus.pending:
        return 'Menunggu';
      case OrderStatus.inProgress:
        return 'Dalam Proses';
      case OrderStatus.completed:
        return 'Selesai';
      case OrderStatus.cancelled:
        return 'Dibatalkan';
    }
  }

  String get value {
    switch (this) {
      case OrderStatus.pending:
        return 'pending';
      case OrderStatus.inProgress:
        return 'in_progress';
      case OrderStatus.completed:
        return 'completed';
      case OrderStatus.cancelled:
        return 'cancelled';
    }
  }

  static OrderStatus fromString(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return OrderStatus.pending;
      case 'in_progress':
        return OrderStatus.inProgress;
      case 'completed':
        return OrderStatus.completed;
      case 'cancelled':
        return OrderStatus.cancelled;
      default:
        return OrderStatus.pending;
    }
  }
}

class Order {
  final String id;
  final String userId;
  final String title;
  final String description;
  final String subject;
  final DateTime deadline;
  final double price;
  final OrderStatus status;
  final List<String> attachments;
  final DateTime createdAt;
  final DateTime updatedAt;

  Order({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.subject,
    required this.deadline,
    required this.price,
    required this.status,
    this.attachments = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      userId: json['user_id'],
      title: json['title'],
      description: json['description'],
      subject: json['subject'],
      deadline: DateTime.parse(json['deadline']),
      price: json['price'].toDouble(),
      status: OrderStatusExtension.fromString(json['status']),
      attachments: List<String>.from(json['attachments'] ?? []),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'description': description,
      'subject': subject,
      'deadline': deadline.toIso8601String(),
      'price': price,
      'status': status.value,
      'attachments': attachments,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Order copyWith({
    String? id,
    String? userId,
    String? title,
    String? description,
    String? subject,
    DateTime? deadline,
    double? price,
    OrderStatus? status,
    List<String>? attachments,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Order(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      subject: subject ?? this.subject,
      deadline: deadline ?? this.deadline,
      price: price ?? this.price,
      status: status ?? this.status,
      attachments: attachments ?? this.attachments,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Helper methods
  bool get isPending => status == OrderStatus.pending;
  bool get isInProgress => status == OrderStatus.inProgress;
  bool get isCompleted => status == OrderStatus.completed;
  bool get isCancelled => status == OrderStatus.cancelled;

  bool get isOverdue => DateTime.now().isAfter(deadline) && !isCompleted;

  Duration get timeUntilDeadline => deadline.difference(DateTime.now());

  String get formattedPrice {
    return 'Rp ${price.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }
}
