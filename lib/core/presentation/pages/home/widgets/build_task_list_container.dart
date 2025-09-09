import 'package:Arkroot/core/presentation/pages/home/widgets/build_search_result_info.dart';
import 'package:Arkroot/core/presentation/pages/home/widgets/build_task_counter_section.dart';
import 'package:Arkroot/core/presentation/pages/home/widgets/build_task_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Widget buildTaskListContainer( BuildContext context , TextEditingController searchController , WidgetRef ref,) {
    return Positioned(
      top: 35,
      right: 0,
      left: 0,
      bottom: 0,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        color: const Color(0xFF262626),
        child: Column(
          children: [
            buildTaskCountersSection(context),
            buildSearchResultsInfo(),
            buildTaskList(context , searchController , ref),
          ],
        ),
      ),
    );
  }