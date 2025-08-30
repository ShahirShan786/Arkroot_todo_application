 import 'package:arkroot_todo_app/core/presentation/pages/home/widgets/build_task_counter.dart';
import 'package:flutter/material.dart';

Widget buildTaskCountersSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
      child: buildTaskCounters(context),
    );
  }