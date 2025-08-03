import 'package:cloud_firestore/cloud_firestore.dart';

class TaskModel {
  final String? id;
  final String userId;
  final String title;
  final String subject;
  final String description;
  final String category;
  final double price;
  final String status; // 'Menunggu', 'Proses', 'Selesai'
  final DateTime deadline;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final List<String> attachments;
  final String? note;

  TaskModel({
    this.id,
    required this.userId,
    required this.title,
    required this.subject,
    required this.description,
    required this.category,
    required this.price,
    required this.status,
    required this.deadline,
    required this.createdAt,
    this.updatedAt,
    this.attachments = const [],
    this.note,
  });

  // Create TaskModel from Firestore document
  factory TaskModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return TaskModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      title: data['title'] ?? '',
      subject: data['subject'] ?? '',
      description: data['description'] ?? '',
      category: data['category'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      status: data['status'] ?? 'Menunggu',
      deadline: (data['deadline'] as Timestamp?)?.toDate() ?? DateTime.now(),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
      attachments: List<String>.from(data['attachments'] ?? []),
      note: data['note'],
    );
  }

  // Convert TaskModel to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'title': title,
      'subject': subject,
      'description': description,
      'category': category,
      'price': price,
      'status': status,
      'deadline': Timestamp.fromDate(deadline),
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
      'attachments': attachments,
      'note': note,
    };
  }

  // Create a copy with updated fields
  TaskModel copyWith({
    String? id,
    String? userId,
    String? title,
    String? subject,
    String? description,
    String? category,
    double? price,
    String? status,
    DateTime? deadline,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<String>? attachments,
    String? note,
  }) {
    return TaskModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      subject: subject ?? this.subject,
      description: description ?? this.description,
      category: category ?? this.category,
      price: price ?? this.price,
      status: status ?? this.status,
      deadline: deadline ?? this.deadline,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      attachments: attachments ?? this.attachments,
      note: note ?? this.note,
    );
  }

  @override
  String toString() {
    return 'TaskModel(id: $id, title: $title, status: $status, price: $price)';
  }
}
