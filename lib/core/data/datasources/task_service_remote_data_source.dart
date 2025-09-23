import 'package:Arkroot/core/data/models/task_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TaskServiceRemoteDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  TaskServiceRemoteDataSource(this._firestore, this._auth);

  CollectionReference<Map<String, dynamic>> get _taskCollection {
    final userId = _auth.currentUser!.uid;

    return _firestore.collection("Users").doc(userId).collection("tasks");
  }

  Future<void> addTask(String title, String description , DateTime dueDate) async {
    final now = DateTime.now();
    try {
      await _taskCollection.add({
        'title': title,
        'description': description,
        "isCompleted": false,
        "dueDate" : dueDate.toString(),
        "createdAt": now,
        "updatedAt": now,
      });
    } catch (e) {
      rethrow;
    }
  }

  // Stream all tasks with debug logging
  Stream<List<TaskModel>> streamTasks() {
    return _taskCollection
        .orderBy("createdAt", descending: true)
        .snapshots()
        .map((snapshot) {
          final tasks = <TaskModel>[];
          for (final doc in snapshot.docs) {
            try {
              final task = TaskModel.fromDocumentSnapshot(doc);
              tasks.add(task);
            } catch (e) {
              // Debug log
            }
          }

          return tasks;
        });
  }

  // Toggle task completion
  Future<void> toggleTask(String taskId, bool currentStatus) async {
    try {
      await _taskCollection.doc(taskId).update({
        "isCompleted": !currentStatus,
        "updatedAt": DateTime.now(),
      });
    } catch (e) {
      // Debug log
      rethrow;
    }
  }

  // Edit task
  Future<void> editTask(String taskId, String newTitle , String newDescription , String newDueDate) async {
    try {
      await _taskCollection.doc(taskId).update({
        "title": newTitle,
        "description" : newDescription,
        "dueDate" : newDueDate.toString(),
        "updatedAt": DateTime.now(),
      });
    } catch (e) {
      rethrow;
    }
  }

  // Delete task
  Future<void> deleteTask(String taskId) async {
    try {
      await _taskCollection.doc(taskId).delete();
    } catch (e) {
      rethrow;
    }
  }
}
