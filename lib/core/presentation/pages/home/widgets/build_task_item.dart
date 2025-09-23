// Updated task item widget
import 'package:Arkroot/core/data/models/task_model.dart';
import 'package:Arkroot/core/presentation/pages/home/widgets/build_hightlighted_title.dart';
import 'package:Arkroot/core/presentation/reverpode_providers/task_service_provider.dart';
import 'package:Arkroot/core/presentation/utils/show_delete_confirmation_dialogues.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

Widget buildTaskItem(
  TaskModel task,
  String searchQuery,
  BuildContext context,
  WidgetRef ref,
) {
  String? formattedDate;
  DateTime? parsedDate;

  if (task.dueDate.isNotEmpty) {
    parsedDate = DateTime.tryParse(task.dueDate);
    if (parsedDate != null) {
      formattedDate = DateFormat('dd-MMM-yyyy').format(parsedDate);
    }
  }

  return Card(
    color: const Color(0xFF333333),
    child: ExpansionTile(
      tilePadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 5),
      shape: const RoundedRectangleBorder(
        side: BorderSide(color: Colors.transparent),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Show due date with color coding if it exists
          if (formattedDate != null && parsedDate != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: _getDueDateColor(parsedDate),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                formattedDate,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          if (formattedDate != null) const SizedBox(height: 4),
          // Task title with highlighting
          RichText(
            text: buildHighlightedTitle(
              task.title,
              searchQuery,
              task.isCompleted,
            ),
          ),
        ],
      ),
      leading: Checkbox(
        value: task.isCompleted,
        onChanged: (_) => toggleTask(context, task, ref),
      ),
      trailing: SizedBox(
        width: 96,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            buildEditButton(task, context, ref),
            buildDeleteButton(task, context, ref),
          ],
        ),
      ),
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withOpacity(0.05), width: 1),
          ),
          child: Text(
            task.description,
            style: TextStyle(
              color: task.isCompleted ? Colors.grey[500] : Colors.white,
              decoration: task.isCompleted
                  ? TextDecoration.lineThrough
                  : TextDecoration.none,
              decorationColor: Colors.grey[800],
              decorationThickness: 3,
            ),
          ),
        ),
      ],
    ),
  );
}


Color _getDueDateColor(DateTime dueDate) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final taskDate = DateTime(dueDate.year, dueDate.month, dueDate.day);
  final difference = taskDate.difference(today).inDays;

  if (difference < 0) {
    // Overdue - Red
    return Colors.red.shade600;
  } else if (difference == 0) {
    // Due today - Orange
    return Colors.orange.shade600;
  } else if (difference <= 3) {
    // Due within 3 days - Yellow
    return Colors.amber.shade600;
  } else {
    // Future date - Blue
    return Colors.blue.shade600;
  }
}

Widget buildEditButton(TaskModel task, BuildContext context, WidgetRef ref) {
  return IconButton(
    icon: const Icon(Icons.edit_note_outlined, color: Colors.grey),
    onPressed: () => editTask(context, task, ref),
  );
}

Widget buildDeleteButton(TaskModel task, BuildContext context, WidgetRef ref) {
  return IconButton(
    icon: const Icon(Icons.delete_outlined, color: Colors.grey, size: 25),
    onPressed: () => showDeleteConfirmationDialog(
      context,
      () => deleteTask(context, task, ref),
    ),
  );
}

void editTask(BuildContext context, TaskModel task, WidgetRef ref) {

  DateTime? existingDueDate;
  if (task.dueDate.isNotEmpty) {
    existingDueDate = DateTime.tryParse(task.dueDate);
  }

  showEditDialog(
    context,
    task.title,
    task.description,
    existingDueDate, 
    (updatedTitle, updatedDescription, updatedDueDate) async {
      final taskService = ref.read(taskServiceProvider);
      if (taskService == null) return;

      try {
        
        String dueDateString = '';
        if (updatedDueDate != null) {
          dueDateString = updatedDueDate.toIso8601String();
        }

        await taskService.editTask(
          task.id,
          updatedTitle,
          updatedDescription,
          dueDateString, 
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error editing task: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    },
  );
}

Future<void> deleteTask(
  BuildContext context,
  TaskModel task,
  WidgetRef ref,
) async {
  final taskService = ref.read(taskServiceProvider);
  if (taskService == null) return;

  try {
    await taskService.deleteTask(task.id);
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Error deleting task: $e"),
        backgroundColor: Colors.red,
      ),
    );
  }
}

Future<void> toggleTask(
  BuildContext context,
  TaskModel task,
  WidgetRef ref,
) async {
  final taskService = ref.read(taskServiceProvider);
  if (taskService == null) return;

  try {
    await taskService.toggleTask(task.id, task.isCompleted);
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Error toggling task: $e"),
        backgroundColor: Colors.red,
      ),
    );
  }
}



void showEditDialog(
  BuildContext context,
  String currentTitle,
  String currentDescription,
  DateTime? currentDueDate,
  Function(String, String, DateTime?) onSave,
) {
  final TextEditingController titleController = TextEditingController(text: currentTitle);
  final TextEditingController descriptionController = TextEditingController(text: currentDescription);
  DateTime? selectedDate = currentDueDate;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            backgroundColor: const Color(0xFF262626),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: const Text(
              "Edit Task",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Title field
                  TextField(
                    controller: titleController,
                    style: const TextStyle(color: Colors.white),
                    cursorColor: Colors.white,
                    decoration: InputDecoration(
                      hintText: "Title",
                      hintStyle: TextStyle(color: Colors.grey[500]),
                      filled: true,
                      fillColor: const Color(0xFF2E2E2E),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Description field
                  TextField(
                    controller: descriptionController,
                    style: const TextStyle(color: Colors.white),
                    cursorColor: Colors.white,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: "Description",
                      hintStyle: TextStyle(color: Colors.grey[500]),
                      filled: true,
                      fillColor: const Color(0xFF2E2E2E),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Date picker field
                  GestureDetector(
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: selectedDate ?? DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: const ColorScheme.dark(
                                primary: Colors.white,
                                onPrimary: Colors.black,
                                surface: Color(0xFF2E2E2E),
                                onSurface: Colors.white,
                              ), dialogTheme: DialogThemeData(backgroundColor: const Color(0xFF262626)),
                            ),
                            child: child!,
                          );
                        },
                      );

                      if (picked != null) {
                        setState(() {
                          selectedDate = picked;
                        });
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2E2E2E),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: selectedDate != null ? Colors.white : Colors.transparent,
                          width: selectedDate != null ? 1 : 0,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            color: selectedDate != null ? Colors.white : Colors.grey[500],
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            selectedDate != null
                                ? DateFormat('dd-MMM-yyyy').format(selectedDate!)
                                : "Due Date (Optional)",
                            style: TextStyle(
                              color: selectedDate != null ? Colors.white : Colors.grey[500],
                              fontSize: 16,
                            ),
                          ),
                          const Spacer(),
                          if (selectedDate != null)
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedDate = null;
                                });
                              },
                              child: Icon(
                                Icons.clear,
                                color: Colors.grey[500],
                                size: 20,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text("Cancel", style: TextStyle(color: Colors.grey[400])),
              ),
              ElevatedButton(
                onPressed: () {
                  onSave(
                    titleController.text.trim(),
                    descriptionController.text.trim(),
                    selectedDate,
                  );
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("Save", style: TextStyle(color: Colors.white)),
              ),
            ],
          );
        },
      );
    },
  );
}













