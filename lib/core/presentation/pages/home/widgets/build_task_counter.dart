  import 'package:arkroot_todo_app/core/presentation/reverpode_providers/task_service_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget buildTaskCounters(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final stats = ref.watch(searchStatsProvider);

        if (stats == null) {
          return _buildLoadingCounters(context);
        }

        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildCounterItem("Pending", stats['pendingCount'] , context),
                _buildCounterItem("Completed", stats['completedCount'] , context),
              ],
            ),
            if (stats['isSearching'] && stats['filteredTasks'] < stats['totalTasks'])
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  "Showing ${stats['filteredTasks']} of ${stats['totalTasks']} tasks",
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildCounterItem(String label, int count , BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.blueAccent),
        ),
        SizedBox(width: 5.w),
        CircleAvatar(
          backgroundColor: const Color(0xFF333333),
          radius: 10,
          child: Center(
            child: Text(
              count.toString(),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingCounters(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildLoadingCounterItem("Pending" , context),
        _buildLoadingCounterItem("Completed" , context),
      ],
    );
  }

  Widget _buildLoadingCounterItem(String label , BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.blueAccent),
        ),
        SizedBox(width: 5.w),
        const CircleAvatar(
          backgroundColor: Color(0xFF333333),
          radius: 10,
          child: SizedBox(
            width: 12,
            height: 12,
            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
          ),
        ),
      ],
    );
  }