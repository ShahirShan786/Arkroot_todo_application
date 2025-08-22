import 'package:arkroot_todo_app/core/data/datasources/task_service_remote_data_source.dart';
import 'package:arkroot_todo_app/core/data/models/task_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final taskServiceProvider = Provider<TaskServiceRemoteDataSource>(
  (ref){
    return TaskServiceRemoteDataSource(FirebaseFirestore.instance, FirebaseAuth.instance);
  }
);

// Stream Provider
final taskProvider = StreamProvider.autoDispose<List<TaskModel>>(
  (ref){
    return ref.watch(taskServiceProvider).streamTasks();
  },
  );