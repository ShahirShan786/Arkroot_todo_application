import 'package:arkroot_todo_app/core/data/models/task_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TaskServiceRemoteDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  TaskServiceRemoteDataSource(this._firestore, this._auth);

  // Reference to the current user task collection with debug logging
  CollectionReference<Map<String, dynamic>> get _taskCollection {
    final userId = _auth.currentUser!.uid;
    print('Getting task collection for user: $userId'); // Debug log
    return _firestore.collection("Users").doc(userId).collection("tasks");
  }

  // Add new task with debug logging
  Future<void> addTask(String content) async {
    print('Adding task: $content'); // Debug log
    final now = DateTime.now();
    try {
      await _taskCollection.add({
        'content': content,
        "isCompleted": false,
        "createdAt": now,
        "updatedAt": now,
      });
      print('Task added successfully'); // Debug log
    } catch (e) {
      print('Error adding task: $e'); // Debug log
      rethrow;
    }
  }

  // Stream all tasks with debug logging
  Stream<List<TaskModel>> streamTasks() {
    print('Starting task stream...'); // Debug log
    return _taskCollection
        .orderBy("createdAt", descending: true)
        .snapshots()
        .map((snapshot) {
          print('Received ${snapshot.docs.length} tasks from Firestore'); // Debug log
          
          final tasks = <TaskModel>[];
          for (final doc in snapshot.docs) {
            try {
              print('Processing document ${doc.id}: ${doc.data()}'); // Debug log
              final task = TaskModel.fromDocumentSnapshot(doc);
              tasks.add(task);
            } catch (e) {
              print('Error processing document ${doc.id}: $e'); // Debug log
            }
          }
          
          print('Successfully parsed ${tasks.length} tasks'); // Debug log
          return tasks;
        });
  }

  // Toggle task completion with debug logging
  Future<void> toggleTask(String taskId, bool currentStatus) async {
    print('Toggling task $taskId from $currentStatus to ${!currentStatus}'); // Debug log
    try {
      await _taskCollection.doc(taskId).update({
        "isCompleted": !currentStatus,
        "updatedAt": DateTime.now()
      });
      print('Task toggled successfully'); // Debug log
    } catch (e) {
      print('Error toggling task: $e'); // Debug log
      rethrow;
    }
  }

  // Edit task with debug logging
  Future<void> editTask(String taskId, String newContent) async {
    print('Editing task $taskId to: $newContent'); // Debug log
    try {
      await _taskCollection.doc(taskId).update({
        "content": newContent,
        "updatedAt": DateTime.now()
      });
      print('Task edited successfully'); // Debug log
    } catch (e) {
      print('Error editing task: $e'); // Debug log
      rethrow;
    }
  }

  // Delete task with debug logging
  Future<void> deleteTask(String taskId) async {
    print('Deleting task: $taskId'); // Debug log
    try {
      await _taskCollection.doc(taskId).delete();
      print('Task deleted successfully'); // Debug log
    } catch (e) {
      print('Error deleting task: $e'); // Debug log
      rethrow;
    }
  }
}