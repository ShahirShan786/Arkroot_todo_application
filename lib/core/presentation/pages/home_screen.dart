import 'package:arkroot_todo_app/core/presentation/reverpode_providers/auth_provider.dart';
import 'package:arkroot_todo_app/core/presentation/reverpode_providers/task_service_provider.dart';
import 'package:arkroot_todo_app/core/presentation/utils/message_generator.dart';
import 'package:arkroot_todo_app/core/presentation/utils/theme.dart';
import 'package:arkroot_todo_app/core/presentation/widgets/animated_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final currentUser = FirebaseAuth.instance.currentUser;

    ref.listen(authNotifierProvider, (previous, next) {
      // Listen for sign out - when user becomes null, navigate to login
      if (next is AsyncData && next.value == null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          context.go("/login");
        });
      }

      // Show error if sign out fails
      if (next is AsyncError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error: ${next.error}"),
            backgroundColor: Colors.red,
          ),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(
          MessageGenerator.getMessage("Home"),
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: appColors.pleasantButtonBg,
        elevation: 0,
        actions: [
          // Sign Out Icon Button
          IconButton(
            onPressed: () => _showSignOutDialog(context),
            icon: const Icon(Icons.logout, color: Colors.white),
            tooltip: 'Sign Out',
          ),
        ],
      ),
      body: Column(
        children: [
          Container(width: double.infinity, height: 95.h, color: Colors.black),
          Expanded(
            child: Container(
              width: double.infinity,
              color: Color(0xFF262626),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Green container positioned upwards
                  Positioned(
                    top:
                        -30, // adjust this value to control how much it overlaps
                    left: 20,
                    right: 20,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 5,
                      ),
                      decoration: BoxDecoration(color: Colors.transparent),
                      child: Row(
                        children: [
                          // Search Field
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              style: const TextStyle(color: Colors.white),
                              cursorColor: Colors.white,
                              decoration: InputDecoration(
                                hintText: "Search...",
                                hintStyle: TextStyle(
                                  color: Colors.grey[500],
                                  fontSize: 14,
                                ),
                                prefixIcon: const Icon(
                                  Icons.rocket_launch,
                                  color: Colors.white,
                                ),
                                filled: true,
                                fillColor: const Color(
                                  0xFF2E2E2E,
                                ), // dark background
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
                                  borderSide: BorderSide(
                                    color: Colors.blueAccent,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 10),

                          // Add Button
                          ElevatedButton(
                            onPressed: () {
                              return _showAddBottomSheet(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 14,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 3,
                            ),
                            child: Row(
                              spacing: 3.w,
                              children: [
                                const Text(
                                  "Add",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Icon(
                                  Icons.add_circle_outline,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 35,
                    right: 0,
                    left: 0,
                    bottom: 0,
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(color: Color(0xFF262626)),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 5,
                              vertical: 15,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  spacing: 5.w,
                                  children: [
                                    Text(
                                      "Pending",
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge
                                          ?.copyWith(color: Colors.blueAccent),
                                    ),
                                    CircleAvatar(
                                      backgroundColor: Color(0xFF333333),
                                      radius: 10,
                                      child: Center(
                                        child: Text(
                                          "1",
                                          style:
                                              Theme.of(
                                                context,
                                              ).textTheme.bodySmall,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  spacing: 5.w,
                                  children: [
                                    Text(
                                      "Completed",
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge
                                          ?.copyWith(color: Colors.blueAccent),
                                    ),
                                    CircleAvatar(
                                      backgroundColor: Color(0xFF333333),
                                      radius: 10,
                                      child: Center(
                                        child: Text(
                                          "1",
                                          style:
                                              Theme.of(
                                                context,
                                              ).textTheme.bodySmall,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: ref
                                .watch(taskProvider)
                                .when(
                                  data:
                                      (tasks) => ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: tasks.length,
                                        itemBuilder: (context, index) {
                                          final task = tasks[index];
                                          return Card(
                                            color: Color(0xFF333333),
                                            child: ListTile(
                                              title: Text(task.content),
                                              leading: Checkbox(
                                                value: task.isCompleted,
                                                onChanged:
                                                    (_) => ref
                                                        .read(
                                                          taskServiceProvider,
                                                        )
                                                        .toggleTask(
                                                          task.id,
                                                          task.isCompleted,
                                                        ),
                                              ),
                                              trailing: IconButton(
                                                icon: Icon(Icons.delete),
                                                onPressed:
                                                    () => ref
                                                        .read(
                                                          taskServiceProvider,
                                                        )
                                                        .deleteTask(task.id),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                  loading:
                                      () => const Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                  error: (e, _) => Text("Error: $e"),
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120.w,
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[400],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.white),
          ),
        ),
      ],
    );
  }

  void _showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: appColors.inputBgFill,
          title: Text(
            MessageGenerator.getLabel("Sign Out"),
            style: TextStyle(color: Colors.white),
          ),
          content: Text(
            MessageGenerator.getLabel("Are you sure you want to sign out?"),
            style: TextStyle(color: Colors.grey[300]),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                MessageGenerator.getLabel("Cancel"),
                style: TextStyle(color: Colors.grey[400]),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _handleSignOut();
              },
              child: Text(
                MessageGenerator.getLabel("Sign Out"),
                style: TextStyle(color: Colors.red[400]),
              ),
            ),
          ],
        );
      },
    );
  }

  void _handleSignOut() {
    ref.read(authNotifierProvider.notifier).signOut();
  }

  void _showAddBottomSheet(BuildContext context) {
    final TextEditingController taskController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // lets the sheet expand fully if needed
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
            bottom:
                MediaQuery.of(context).viewInsets.bottom +
                16, // moves up when keyboard opens
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              const Text(
                "Add Task",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // Input Field
              TextField(
                controller: taskController,
                style: const TextStyle(color: Colors.white),
                cursorColor: Colors.white,
                decoration: InputDecoration(
                  hintText: "Enter your task...",
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
              const SizedBox(height: 20),

              // Buttons Row
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      "Cancel",
                      style: TextStyle(color: Colors.grey[400]),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      String newTask = taskController.text.trim();
                      if (newTask.isNotEmpty) {
                        ref.read(taskServiceProvider).addTask(newTask);
                      }
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Add",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
