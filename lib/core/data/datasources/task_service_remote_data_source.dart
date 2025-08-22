import 'package:arkroot_todo_app/core/data/models/task_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TaskServiceRemoteDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  TaskServiceRemoteDataSource(this._firestore, this._auth);

  // reference to the current user task collection
  CollectionReference<Map<String, dynamic>> get _taskCollection {
    final userId = _auth.currentUser!.uid;
    return _firestore.collection("Users").doc(userId).collection("tasks");
  }

  // add new taska
  Future<void> addTask(String content) async {
    final now = DateTime.now();
    await _taskCollection.add({
      'content': content,
      "isCompleted": false,
      "createdAt": now,
      "updatedAt": now,
    });
  }

  // stream all task
Stream<List<TaskModel>> streamTasks() {
  return _taskCollection
      .orderBy("createdAt", descending: true)
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => TaskModel.fromDoc(doc)).toList());
}



  // toggle task completion
  Future<void> toggleTask(String taskId , bool currentStatus) async {
    await _taskCollection.doc(taskId).update({
      "isCompleted" : !currentStatus,
      "updatedAt" : DateTime.now()
     });
  }


  // edit task file 
  Future<void> editTask(String taskId , String newContent)async{
  await _taskCollection.doc(taskId).update({
    "title" : newContent,
    "updatedAt" : DateTime.now()
  });
  }

  // Delete task 
  Future<void> deleteTask(String taskId) async{
    await _taskCollection.doc(taskId).delete();
  }
}
