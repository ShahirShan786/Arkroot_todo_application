import 'package:Arkroot/core/presentation/reverpode_providers/task_service_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget buildNoSearchResults(String searchQuery , BuildContext context , TextEditingController searchController ) {
   void clearSearch( WidgetRef ref, TextEditingController controller) {
    searchController.clear();
    ref.read(searchQueryProvider.notifier).state = '';
  }
    return Container(
      width: 350,
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border(top: BorderSide(color: Colors.grey[800]!)),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 80.h),
            Icon(Icons.search_off, size: 40.w, color: Colors.grey[700]),
            SizedBox(height: 10.h),
            Text(
              "No tasks found",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            Text(
              "No tasks match '$searchQuery'",
              maxLines: 2,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontSize: 15,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () => clearSearch,
              child: const Text(
                "Clear search",
                style: TextStyle(
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }