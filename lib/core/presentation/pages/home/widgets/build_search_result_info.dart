import 'package:Arkroot/core/presentation/reverpode_providers/task_service_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Widget buildSearchResultsInfo() {
  return Consumer(
    builder: (context, ref, child) {
      final stats = ref.watch(searchStatsProvider);
      if (stats == null || !stats['isSearching']) {
        return const SizedBox.shrink();
      }

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.blueAccent.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.blueAccent.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.info_outline,
                size: 16,
                color: Colors.blueAccent,
              ),
              const SizedBox(width: 8),
              Text(
                "Found ${stats['filteredTasks']} result${stats['filteredTasks'] != 1 ? 's' : ''} for '${stats['searchQuery']}'",
                style: const TextStyle(
                  color: Colors.blueAccent,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
