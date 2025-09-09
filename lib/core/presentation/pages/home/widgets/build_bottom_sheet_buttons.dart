 import 'package:Arkroot/core/presentation/reverpode_providers/task_service_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Widget buildBottomSheetButtons(
  WidgetRef ref,
    BuildContext context,
    TextEditingController titleController,
    TextEditingController descriptionController,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text("Cancel", style: TextStyle(color: Colors.grey[400])),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed:
              () => _addTask( ref , context, titleController, descriptionController),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text("Add", style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  Future<void> _addTask(
    WidgetRef ref,
    BuildContext context,
    TextEditingController titleController,
    TextEditingController descriptionController,
  ) async {
    final String title = titleController.text.trim();
    final String description = descriptionController.text.trim();
    if (title.isEmpty && description.isEmpty) {
      Navigator.of(context).pop();
      return;
    }

    final taskService = ref.read(taskServiceProvider);
    if (taskService == null) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please sign in to add tasks"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      await taskService.addTask(title, description);
      Navigator.of(context).pop();
    } catch (e) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error adding task: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }