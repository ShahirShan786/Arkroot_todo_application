import 'package:Arkroot/core/presentation/pages/home/widgets/build_bottom_sheet_buttons.dart';
import 'package:Arkroot/core/presentation/pages/home/widgets/build_task_input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void showAddBottomSheet(BuildContext context , WidgetRef ref,) {
    // final TextEditingController taskController = TextEditingController();
    final TextEditingController titleController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF262626),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Add Task",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              buildTaskInputField(titleController, descriptionController),
              const SizedBox(height: 20),
              buildBottomSheetButtons(
               ref,
                context,
                titleController,
                descriptionController,
              ),
            ],
          ),
        );
      },
    );
  }