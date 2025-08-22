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

  /// From Firestore document
  factory TaskModel.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return TaskModel(
      id: doc.id,
      content: data["content"] ?? "",
      isCompleted: data["isCompleted"] ?? false,
      createdAt: (data["createdAt"] as Timestamp).toDate(),
      updatedAt: (data["updatedAt"] as Timestamp).toDate(),
    );
  }

  /// To Firestore map
  Map<String, dynamic> toMap() {
    return {
      "content": content,
      "isCompleted": isCompleted,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
    };
  }

  /// Copy with (for updating values immutably)
  TaskModel copyWith({
    String? content,
    bool? isCompleted,
    DateTime? updatedAt,
  }) {
    return TaskModel(
      id: id,
      content: content ?? this.content,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
