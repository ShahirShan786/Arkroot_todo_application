  import 'package:Arkroot/core/data/models/task_model.dart';
import 'package:Arkroot/core/presentation/pages/home/widgets/build_hightlighted_title.dart';
import 'package:Arkroot/core/presentation/reverpode_providers/task_service_provider.dart';
import 'package:Arkroot/core/presentation/utils/show_delete_confirmation_dialogues.dart';
import 'package:Arkroot/core/presentation/utils/show_edit_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Widget buildTaskItem(TaskModel task, String searchQuery , BuildContext context , WidgetRef ref) {
    return Card(
      color: const Color(0xFF333333),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 5),
        shape: const RoundedRectangleBorder(
          side: BorderSide(color: Colors.transparent),
        ),
        title: RichText(
          text: buildHighlightedTitle(
            task.title,
            searchQuery,
            task.isCompleted,
          ),
        ),
        leading: Checkbox(
          value: task.isCompleted,
          onChanged: (_) => toggleTask(context , task , ref),
        ),

        trailing: SizedBox(
          width: 96,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [buildEditButton(task , context , ref ), buildDeleteButton(task , context , ref)],
          ),
        ),
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withOpacity(0.05),
                width: 1,
              ),
            ),
            child: 
             Text(
              task.description,
              style: TextStyle(
                  color: task.isCompleted ? Colors.grey[500] : Colors.white,
                   decoration:
              task.isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
          decorationColor: Colors.grey[800],
          decorationThickness: 3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildEditButton(TaskModel task , BuildContext context , WidgetRef ref) {
    return IconButton(
      icon: const Icon(Icons.edit_note_outlined, color: Colors.grey),
      onPressed: () => editTask(context , task , ref),
    );
  }

  Widget buildDeleteButton(TaskModel task , BuildContext context , WidgetRef ref) {
    return IconButton(
      icon: const Icon(Icons.delete_outlined, color: Colors.grey, size: 25),
      onPressed:
          () => showDeleteConfirmationDialog(context, () => deleteTask( context , task , ref)),
    );
  }

  
  void editTask( BuildContext context ,TaskModel task , WidgetRef ref) {
    showEditDialog(context, task.title, task.description, (
      updatedTitle,
      updatedDescription,
    ) async {
      final taskService = ref.read(taskServiceProvider);
      if (taskService == null) return;

      try {
        await taskService.editTask(
          task.id, // ✅ taskId
          updatedTitle,
          updatedDescription,
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error editing task: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    });
  }

    Future<void> deleteTask(BuildContext context , TaskModel task , WidgetRef ref, ) async {
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

  Future<void> toggleTask(BuildContext context , TaskModel task  , WidgetRef ref) async {
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