import 'package:Arkroot/core/data/datasources/task_service_remote_data_source.dart';
import 'package:Arkroot/core/data/models/task_model.dart';
import 'package:Arkroot/core/presentation/reverpode_providers/auth_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Task service provider that depends on auth state
final taskServiceProvider = Provider<TaskServiceRemoteDataSource?>((ref) {
  final authState = ref.watch(authNotifierProvider);

  return authState.when(
    data: (user) {
      if (user != null) {
        return TaskServiceRemoteDataSource(
          FirebaseFirestore.instance,
          FirebaseAuth.instance,
        );
      }
      return null;
    },
    loading: () => null,
    error: (_, __) => null,
  );
});

// Stream Provider for tasks
final taskProvider = StreamProvider.autoDispose<List<TaskModel>>((ref) {
  final taskService = ref.watch(taskServiceProvider);
  final authState = ref.watch(authNotifierProvider);

  // Return empty stream if no user is authenticated or service is null
  if (taskService == null) {
    return Stream.value([]);
  }

  return authState.when(
    data: (user) {
      if (user != null) {
        return taskService.streamTasks();
      }
      return Stream.value([]);
    },
    loading: () => Stream.value([]),
    error: (_, __) => Stream.value([]),
  );
});

// Provider to hold the search query
final searchQueryProvider = StateProvider<String>((ref) => '');

// Provider that combines tasks with search functionality
final filteredTasksProvider = Provider<AsyncValue<List<TaskModel>>>((ref) {
  final tasks = ref.watch(taskProvider);
  final searchQuery = ref.watch(searchQueryProvider).toLowerCase();

  return tasks.when(
    data: (taskList) {
      if (searchQuery.isEmpty) {
        return AsyncData(taskList);
      }
      final filtered =
          taskList
              .where((task) => task.title.toLowerCase().contains(searchQuery))
              .toList();
      return AsyncData(filtered);
    },
    loading: () => const AsyncLoading<List<TaskModel>>(),
    error:
        (error, stackTrace) => AsyncError<List<TaskModel>>(error, stackTrace),
  );
});

// Provider for search statistics
final searchStatsProvider = Provider<Map<String, dynamic>?>((ref) {
  final allTasks = ref.watch(taskProvider);
  final filteredTasks = ref.watch(filteredTasksProvider);
  final searchQuery = ref.watch(searchQueryProvider);
  final authState = ref.watch(authNotifierProvider);

  // Return null if user is not authenticated
  return authState.when(
    data: (user) {
      if (user == null) return null;

      return allTasks.when(
        data: (allTaskList) {
          return filteredTasks.when(
            data: (filteredTaskList) {
              return {
                'totalTasks': allTaskList.length,
                'filteredTasks': filteredTaskList.length,
                'pendingCount':
                    filteredTaskList.where((task) => !task.isCompleted).length,
                'completedCount':
                    filteredTaskList.where((task) => task.isCompleted).length,
                'isSearching': searchQuery.isNotEmpty,
                'searchQuery': searchQuery,
              };
            },
            loading: () => null,
            error: (e, _) => null,
          );
        },
        loading: () => null,
        error: (e, _) => null,
      );
    },
    loading: () => null,
    error: (_, __) => null,
  );
});
