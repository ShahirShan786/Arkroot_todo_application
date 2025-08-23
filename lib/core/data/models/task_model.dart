import 'package:cloud_firestore/cloud_firestore.dart';

class TaskModel {
  final String id;
  final String content;
  final bool isCompleted;
  final DateTime createdAt;
  final DateTime updatedAt;

  TaskModel({
    required this.id,
    required this.content,
    required this.isCompleted,
    required this.createdAt,
    required this.updatedAt,
  });

  // This is the critical method that needs to be correct
  factory TaskModel.fromDoc(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    try {
      final data = doc.data();
      return TaskModel(
        id: doc.id,
        content: data['content'] ?? '',
        isCompleted: data['isCompleted'] ?? false,
        createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
        updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      );
    } catch (e) {
      print('Error parsing task document ${doc.id}: $e');
      print('Document data: ${doc.data()}');
      rethrow;
    }
  }

  // Alternative factory for DocumentSnapshot (if you need it elsewhere)
  factory TaskModel.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return TaskModel(
      id: doc.id,
      content: data['content'] ?? '',
      isCompleted: data['isCompleted'] ?? false,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'content': content,
      'isCompleted': isCompleted,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}