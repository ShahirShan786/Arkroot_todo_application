import 'package:Arkroot/core/data/models/task_model.dart';
import 'package:Arkroot/core/presentation/pages/home/widgets/build_no_search_result.dart';
import 'package:Arkroot/core/presentation/pages/home/widgets/build_no_task.dart';
import 'package:Arkroot/core/presentation/pages/home/widgets/build_task_item.dart' show buildTaskItem;
import 'package:Arkroot/core/presentation/reverpode_providers/task_service_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Widget buildTaskList(BuildContext context , TextEditingController searchController ,WidgetRef ref) {
    return Expanded(
      child: Consumer(
        builder: (context, ref, child) {
          final filteredTasksAsync = ref.watch(filteredTasksProvider);
          final searchQuery = ref.watch(searchQueryProvider);

          return filteredTasksAsync.when(
            data:
                (filteredTasks) =>
                    buildTaskListContent( context , searchController , filteredTasks, searchQuery ,ref),
            loading: () => const Center(child: CircularProgressIndicator()),
            error:
                (e, _) => Center(
                  child: Text(
                    "Error: $e",
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
          );
        },
      ),
    );
  }

  Widget buildTaskListContent(
    BuildContext context ,
    TextEditingController searchController,
    List<TaskModel> filteredTasks,
    String searchQuery,
    WidgetRef ref

  ) {
    if (filteredTasks.isEmpty && searchQuery.isNotEmpty) {
      return buildNoSearchResults(searchQuery , context , searchController);
    } else if (filteredTasks.isEmpty && searchQuery.isEmpty) {
      return buildNoTasks(context);
    } else {
      return ListView.builder(
        itemCount: filteredTasks.length,
        itemBuilder:
            (context, index) =>
                buildTaskItem(filteredTasks[index], searchQuery , context , ref),
      );
    }
  }