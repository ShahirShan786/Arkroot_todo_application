import 'package:Arkroot/core/presentation/utils/message_generator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget buildNoTasks(BuildContext context) {
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
      child: Column(
        children: [
          SizedBox(height: 80.h),
          Icon(Icons.difference_outlined, size: 40.w, color: Colors.grey[700]),
          SizedBox(height: 10.h),
          Text(
            MessageGenerator.getMessage("no_task"),
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          Text(
            maxLines: 2,
            textAlign: TextAlign.center,
            MessageGenerator.getMessage("no_task_dec"),
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontSize: 17,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }