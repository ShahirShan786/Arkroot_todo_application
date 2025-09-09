import 'package:Arkroot/core/presentation/pages/home/widgets/show_add_bottom_sheet.dart';
import 'package:Arkroot/core/presentation/reverpode_providers/task_service_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget buildSearchContainer(BuildContext context , WidgetRef ref , TextEditingController searchController) {
    return Positioned(
      top: -30,
      left: 20,
      right: 20,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        decoration: const BoxDecoration(color: Colors.transparent),
        child: Row(
          children: [
            buildSearchField(ref , searchController ),
            const SizedBox(width: 10),
            buildAddButton( context , ref),
          ],
        ),
      ),
    );
  }

  Widget buildSearchField(WidgetRef ref , TextEditingController searchController ,) {
    final searchQuery = ref.watch(searchQueryProvider);
      void clearSearch( WidgetRef ref, TextEditingController controller) {
    searchController.clear();
    ref.read(searchQueryProvider.notifier).state = '';
  }

    return Expanded(
      child: TextField(
        controller: searchController,
        style: const TextStyle(color: Colors.white),
        cursorColor: Colors.white,
        onChanged: (value) {
          ref.read(searchQueryProvider.notifier).state = value;
        },
        decoration: InputDecoration(
          hintText:
              searchQuery.isEmpty
                  ? "Search tasks..."
                  : "Searching for '$searchQuery'",
          hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
          prefixIcon: const Icon(Icons.search, color: Colors.white),
          suffixIcon:
              searchQuery.isNotEmpty
                  ? IconButton(
                    icon: const Icon(Icons.clear, color: Colors.grey, size: 20),
                    onPressed: ()=> clearSearch(ref, searchController),
                  )
                  : null,
          filled: true,
          fillColor: const Color(0xFF2E2E2E),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 12,
            horizontal: 16,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.blueAccent),
          ),
        ),
      ),
    );
  }

  Widget buildAddButton( BuildContext context , WidgetRef ref) {
    return ElevatedButton(
      onPressed: () => showAddBottomSheet(context , ref),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueAccent,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 3,
      ),
      child: Row(
        spacing: 3.w,
        children: const [
          Text(
            "Add",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
          Icon(Icons.add_circle_outline, color: Colors.white),
        ],
      ),
    );
  }

  