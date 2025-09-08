import 'package:Arkroot/core/data/models/task_model.dart';
import 'package:Arkroot/core/presentation/pages/home/widgets/build_search_result_info.dart';
import 'package:Arkroot/core/presentation/pages/home/widgets/build_task_counter_section.dart';
import 'package:Arkroot/core/presentation/reverpode_providers/auth_provider.dart';
import 'package:Arkroot/core/presentation/reverpode_providers/task_service_provider.dart';
import 'package:Arkroot/core/presentation/utils/message_generator.dart';
import 'package:Arkroot/core/presentation/utils/show_delete_confirmation_dialogues.dart';
import 'package:Arkroot/core/presentation/utils/show_edit_dialog.dart';
import 'package:Arkroot/core/presentation/utils/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(searchQueryProvider.notifier).state = _searchController.text;
    });
  }

  void _clearSearch() {
    _searchController.clear();
    ref.read(searchQueryProvider.notifier).state = '';
  }

  @override
  Widget build(BuildContext context) {
    // final searchQuery = ref.watch(searchQueryProvider);

    ref.listen(authNotifierProvider, _handleAuthStateChange);

    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Container(width: double.infinity, height: 95.h, color: Colors.black),
          Expanded(
            child: Container(
              width: double.infinity,
              color: const Color(0xFF262626),
              child: Stack(
                clipBehavior: Clip.none,
                children: [_buildSearchContainer(), _buildTaskListContainer()],
              ),
            ),
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text(
        MessageGenerator.getMessage("arkroot"),
        style: GoogleFonts.poppins(
          color: appColors.textColor,
          fontWeight: FontWeight.w700,
          fontSize: 24,
        ),
      ),
      backgroundColor: appColors.appBarcolor,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.transparent,
      actions: [
        IconButton(
          onPressed: () => _showSignOutDialog(context),
          icon: const Icon(Icons.logout, color: Colors.white),
          tooltip: 'Sign Out',
        ),
      ],
    );
  }

  Widget _buildSearchContainer() {
    return Positioned(
      top: -30,
      left: 20,
      right: 20,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        decoration: const BoxDecoration(color: Colors.transparent),
        child: Row(
          children: [
            _buildSearchField(),
            const SizedBox(width: 10),
            _buildAddButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    final searchQuery = ref.watch(searchQueryProvider);

    return Expanded(
      child: TextField(
        controller: _searchController,
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
                    onPressed: _clearSearch,
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

  Widget _buildAddButton() {
    return ElevatedButton(
      onPressed: () => _showAddBottomSheet(context),
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

  Widget _buildTaskListContainer() {
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
            _buildTaskList(),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskList() {
    return Expanded(
      child: Consumer(
        builder: (context, ref, child) {
          final filteredTasksAsync = ref.watch(filteredTasksProvider);
          final searchQuery = ref.watch(searchQueryProvider);

          return filteredTasksAsync.when(
            data:
                (filteredTasks) =>
                    _buildTaskListContent(filteredTasks, searchQuery),
            loading: () => const Center(child: CircularProgressIndicator()),
            error:
                (e, _) => Center(
                  child: Text(
                    "Error: $e",
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
          );
        },
      ),
    );
  }

  Widget _buildTaskListContent(
    List<TaskModel> filteredTasks,
    String searchQuery,
  ) {
    if (filteredTasks.isEmpty && searchQuery.isNotEmpty) {
      return _buildNoSearchResults(searchQuery);
    } else if (filteredTasks.isEmpty && searchQuery.isEmpty) {
      return _buildNoTasks();
    } else {
      return ListView.builder(
        itemCount: filteredTasks.length,
        itemBuilder:
            (context, index) =>
                _buildTaskItem(filteredTasks[index], searchQuery),
      );
    }
  }

  Widget _buildTaskItem(TaskModel task, String searchQuery) {
    return Card(
      color: const Color(0xFF333333),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 5),
        shape: const RoundedRectangleBorder(
          side: BorderSide(color: Colors.transparent),
        ),
        title: RichText(
          text: _buildHighlightedTitle(
            task.title,
            searchQuery,
            task.isCompleted,
          ),
        ),
        leading: Checkbox(
          value: task.isCompleted,
          onChanged: (_) => _toggleTask(task),
        ),

        trailing: SizedBox(
          width: 96,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [_buildEditButton(task), _buildDeleteButton(task)],
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

  Widget _buildEditButton(TaskModel task) {
    return IconButton(
      icon: const Icon(Icons.edit_note_outlined, color: Colors.grey),
      onPressed: () => _editTask(task),
    );
  }

  Widget _buildDeleteButton(TaskModel task) {
    return IconButton(
      icon: const Icon(Icons.delete_outlined, color: Colors.grey, size: 25),
      onPressed:
          () => showDeleteConfirmationDialog(context, () => _deleteTask(task)),
    );
  }

  Widget _buildNoSearchResults(String searchQuery) {
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
              onPressed: _clearSearch,
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

  Widget _buildNoTasks() {
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

  TextSpan _buildHighlightedTitle(
    String title,
    String searchQuery,
    bool isCompleted,
  ) {
    if (searchQuery.isEmpty) {
      return TextSpan(
        text: title,
        style: TextStyle(
          color: isCompleted ? Colors.grey[500] : Colors.white,
          decoration:
              isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
          decorationColor: Colors.grey[800],
          decorationThickness: 3,
        ),
      );
    }

    TextSpan buildHighlightedDescription(
      String description,
      bool isCompleted,
    ){
      return TextSpan(
        text: description,
        style: TextStyle(
          color: isCompleted ? Colors.grey[500] : Colors.white,
          decoration:
              isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
          decorationColor: Colors.grey[800],
          decorationThickness: 3,
        ),
      );
    }

    final List<TextSpan> spans = [];
    final String lowerText = title.toLowerCase();
    final String lowerQuery = searchQuery.toLowerCase();
    int start = 0;

    while (true) {
      final int index = lowerText.indexOf(lowerQuery, start);
      if (index == -1) {
        if (start < title.length) {
          spans.add(_createTextSpan(title.substring(start), isCompleted, false));
        }
        break;
      }

      if (index > start) {
        spans.add(
          _createTextSpan(title.substring(start, index), isCompleted, false),
        );
      }

      spans.add(
        _createTextSpan(
          title.substring(index, index + searchQuery.length),
          isCompleted,
          true,
        ),
      );

      start = index + searchQuery.length;
    }

    return TextSpan(children: spans);
  }

  TextSpan _createTextSpan(String text, bool isCompleted, bool isHighlighted) {
    return TextSpan(
      text: text,
      style: TextStyle(
        color:
            isHighlighted
                ? (isCompleted ? Colors.orange[300] : Colors.yellow[300])
                : (isCompleted ? Colors.grey[500] : Colors.white),
        backgroundColor:
            isHighlighted ? Colors.yellow[700]?.withOpacity(0.3) : null,
        fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
        decoration:
            isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
        decorationColor: Colors.grey[800],
        decorationThickness: 3,
      ),
    );
  }

  void _handleAuthStateChange(
    AsyncValue<User?>? previous,
    AsyncValue<User?> next,
  ) {
    if (next is AsyncData && next.value == null) {
      ref.read(searchQueryProvider.notifier).state = '';
      _searchController.clear();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go("/login");
      });
    }

    if (next is AsyncError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: ${next.error}"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: appColors.inputBgFill,
          title: const Text("Sign Out", style: TextStyle(color: Colors.white)),
          content: Text(
            "Are you sure you want to sign out?",
            style: TextStyle(color: Colors.grey[300]),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Cancel", style: TextStyle(color: Colors.grey[400])),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _handleSignOut();
              },
              child: Text("Sign Out", style: TextStyle(color: Colors.red[400])),
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
              _buildTaskInputField(titleController, descriptionController),
              const SizedBox(height: 20),
              _buildBottomSheetButtons(
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

  Widget _buildTaskInputField(
    TextEditingController titleController,
    TextEditingController descriptionController,
  ) {
    return Column(
      spacing: 10.h,
      children: [
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
        TextField(
          controller: descriptionController,
          style: const TextStyle(color: Colors.white),
          cursorColor: Colors.white,
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
      ],
    );
  }

  Widget _buildBottomSheetButtons(
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
              () => _addTask(context, titleController, descriptionController),
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

  Future<void> _toggleTask(TaskModel task) async {
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

  void _editTask(TaskModel task) {
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

  Future<void> _deleteTask(TaskModel task) async {
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
}













//   import 'package:Arkroot/core/presentation/reverpode_providers/auth_provider.dart';
//   import 'package:Arkroot/core/presentation/reverpode_providers/task_service_provider.dart';
//   import 'package:Arkroot/core/presentation/utils/message_generator.dart';
// import 'package:Arkroot/core/presentation/utils/show_delete_confirmation_dialogues.dart';
// import 'package:Arkroot/core/presentation/utils/show_edit_dialog.dart';
//   import 'package:Arkroot/core/presentation/utils/theme.dart';
//   import 'package:flutter/material.dart';
//   import 'package:flutter_riverpod/flutter_riverpod.dart';
//   import 'package:flutter_screenutil/flutter_screenutil.dart';
//   import 'package:go_router/go_router.dart';
//   import 'package:google_fonts/google_fonts.dart';

//   class HomeScreen extends ConsumerStatefulWidget {
//     const HomeScreen({super.key});

//     @override
//     ConsumerState<HomeScreen> createState() => _HomeScreenState();
//   }

//   class _HomeScreenState extends ConsumerState<HomeScreen> {
//     final TextEditingController _searchController = TextEditingController();

//     @override
//     void initState() {
//       super.initState();
//       // Listen to search input changes and update the provider
//       _searchController.addListener(() {
//         // Use WidgetsBinding to avoid calling setState during build
//         WidgetsBinding.instance.addPostFrameCallback((_) {
//           ref.read(searchQueryProvider.notifier).state = _searchController.text;
//         });
//       });
//     }

//     @override
//     void dispose() {
//       _searchController.removeListener(() {});
//       _searchController.dispose();
//       super.dispose();
//     }

//     // Method to clear search using provider
//     void _clearSearch() {
//       _searchController.clear();
//       ref.read(searchQueryProvider.notifier).state = '';
//     }

//     @override
//     Widget build(BuildContext context) {
//       final searchQuery = ref.watch(searchQueryProvider);

//       ref.listen(authNotifierProvider, (previous, next) {
//         if (next is AsyncData && next.value == null) {
//           ref.read(searchQueryProvider.notifier).state = '';
//           _searchController.clear();
//           WidgetsBinding.instance.addPostFrameCallback((_) {
//             context.go("/login");
//           });
//         }

//         if (next is AsyncError) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text("Error: ${next.error}"),
//               backgroundColor: Colors.red,
//             ),
//           );
//         }
//       });

//       return Scaffold(
//         appBar: AppBar(
//           title: Text(
//             MessageGenerator.getMessage("arkroot"),
//             style: GoogleFonts.poppins(
//               color: appColors.textColor,
//               fontWeight: FontWeight.w700,
//               fontSize: 24,
//             ),
//           ),
//           backgroundColor: appColors.pleasantButtonBg,
//           elevation: 0,
//           scrolledUnderElevation: 0,
//           surfaceTintColor: Colors.transparent,
//           shadowColor: Colors.transparent,
//           actions: [
//             IconButton(
//               onPressed: () => _showSignOutDialog(context),
//               icon: const Icon(Icons.logout, color: Colors.white),
//               tooltip: 'Sign Out',
//             ),
//           ],
//         ),
//         body: Column(
//           children: [
//             Container(width: double.infinity, height: 95.h, color: Colors.black),
//             Expanded(
//               child: Container(
//                 width: double.infinity,
//                 color: Color(0xFF262626),
//                 child: Stack(
//                   clipBehavior: Clip.none,
//                   children: [
//                     // Enhanced search container
//                     Positioned(
//                       top: -30,
//                       left: 20,
//                       right: 20,
//                       child: Container(
//                         padding: EdgeInsets.symmetric(
//                           vertical: 10,
//                           horizontal: 5,
//                         ),
//                         decoration: BoxDecoration(color: Colors.transparent),
//                         child: Row(
//                           children: [
//                             // Enhanced Search Field
//                             Expanded(
//                               child: TextField(
//                                 controller: _searchController,
//                                 style: const TextStyle(color: Colors.white),
//                                 cursorColor: Colors.white,
//                                 onChanged: (value) {
//                                   // Direct update for immediate response
//                                   ref.read(searchQueryProvider.notifier).state =
//                                       value;
//                                 },
//                                 decoration: InputDecoration(
//                                   hintText:
//                                       searchQuery.isEmpty
//                                           ? "Search tasks..."
//                                           : "Searching for '$searchQuery'",
//                                   hintStyle: TextStyle(
//                                     color: Colors.grey[500],
//                                     fontSize: 14,
//                                   ),
//                                   prefixIcon: const Icon(
//                                     Icons.search,
//                                     color: Colors.white,
//                                   ),
//                                   suffixIcon:
//                                       searchQuery.isNotEmpty
//                                           ? IconButton(
//                                             icon: const Icon(
//                                               Icons.clear,
//                                               color: Colors.grey,
//                                               size: 20,
//                                             ),
//                                             onPressed: _clearSearch,
//                                           )
//                                           : null,
//                                   filled: true,
//                                   fillColor: const Color(0xFF2E2E2E),
//                                   contentPadding: const EdgeInsets.symmetric(
//                                     vertical: 12,
//                                     horizontal: 16,
//                                   ),
//                                   enabledBorder: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(12),
//                                     borderSide: BorderSide.none,
//                                   ),
//                                   focusedBorder: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(12),
//                                     borderSide: BorderSide(
//                                       color: Colors.blueAccent,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),

//                             const SizedBox(width: 10),

//                             // Add Button
//                             ElevatedButton(
//                               onPressed: () {
//                                 return _showAddBottomSheet(context);
//                               },
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: Colors.blueAccent,
//                                 padding: const EdgeInsets.symmetric(
//                                   horizontal: 20,
//                                   vertical: 14,
//                                 ),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(12),
//                                 ),
//                                 elevation: 3,
//                               ),
//                               child: Row(
//                                 spacing: 3.w,
//                                 children: [
//                                   const Text(
//                                     "Add",
//                                     style: TextStyle(
//                                       color: Colors.white,
//                                       fontWeight: FontWeight.w600,
//                                     ),
//                                   ),
//                                   Icon(
//                                     Icons.add_circle_outline,
//                                     color: Colors.white,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     Positioned(
//                       top: 35,
//                       right: 0,
//                       left: 0,
//                       bottom: 0,
//                       child: Container(
//                         width: double.infinity,
//                         height: double.infinity,
//                         padding: EdgeInsets.symmetric(
//                           horizontal: 15,
//                           vertical: 10,
//                         ),
//                         decoration: BoxDecoration(color: Color(0xFF262626)),
//                         child: Column(
//                           children: [
//                             // Task counters
//                             Padding(
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 5,
//                                 vertical: 15,
//                               ),
//                               child: buildTaskCounters(),
//                             ),

//                             // Search results info
//                             Consumer(
//                               builder: (context, ref, child) {
//                                 final stats = ref.watch(searchStatsProvider);
//                                 if (stats == null || !stats['isSearching']) {
//                                   return SizedBox.shrink();
//                                 }

//                                 return Padding(
//                                   padding: const EdgeInsets.symmetric(
//                                     horizontal: 5,
//                                   ),
//                                   child: Container(
//                                     padding: EdgeInsets.symmetric(
//                                       horizontal: 12,
//                                       vertical: 8,
//                                     ),
//                                     decoration: BoxDecoration(
//                                       color: Colors.blueAccent.withOpacity(0.1),
//                                       borderRadius: BorderRadius.circular(8),
//                                       border: Border.all(
//                                         color: Colors.blueAccent.withOpacity(0.3),
//                                       ),
//                                     ),
//                                     child: Row(
//                                       children: [
//                                         Icon(
//                                           Icons.info_outline,
//                                           size: 16,
//                                           color: Colors.blueAccent,
//                                         ),
//                                         SizedBox(width: 8),
//                                         Text(
//                                           "Found ${stats['filteredTasks']} result${stats['filteredTasks'] != 1 ? 's' : ''} for '${stats['searchQuery']}'",
//                                           style: TextStyle(
//                                             color: Colors.blueAccent,
//                                             fontSize: 13,
//                                             fontWeight: FontWeight.w500,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 );
//                               },
//                             ),

//                             Consumer(
//                               builder: (context, ref, child) {
//                                 final searchQuery = ref.watch(
//                                   searchQueryProvider,
//                                 );
//                                 return searchQuery.isNotEmpty
//                                     ? SizedBox(height: 10)
//                                     : SizedBox.shrink();
//                               },
//                             ),

//                             // Task list with silver scrollbar
//                             Expanded(
//                               child: Consumer(
//                                 builder: (context, ref, child) {
//                                   final filteredTasksAsync = ref.watch(
//                                     filteredTasksProvider,
//                                   );
//                                   final searchQuery = ref.watch(
//                                     searchQueryProvider,
//                                   );

//                                   return filteredTasksAsync.when(
//                                     data: (filteredTasks) {
//                                       if (filteredTasks.isEmpty &&
//                                           searchQuery.isNotEmpty) {
//                                         // No search results
//                                         return _buildNoSearchResults(searchQuery);
//                                       } else if (filteredTasks.isEmpty &&
//                                           searchQuery.isEmpty) {
//                                         // No tasks at all
//                                         return _buildNoTasks();
//                                       } else {
//                                         // Show filtered tasks
//                                         return ListView.builder(
//                                           itemCount: filteredTasks.length,
//                                           itemBuilder: (context, index) {
//                                             final task = filteredTasks[index];
//                                             return Card(
//                                               color: const Color(0xFF333333),
//                                               child: ListTile(
//                                                 contentPadding:
//                                                     EdgeInsets.symmetric(
//                                                       horizontal: 4,
//                                                       vertical: 5,
//                                                     ),
//                                                 title: RichText(
//                                                   text: _buildHighlightedText(
//                                                     task.content,
//                                                     searchQuery,
//                                                     task.isCompleted,
//                                                   ),
//                                                 ),
//                                                 leading: Checkbox(
//                                                   value: task.isCompleted,
//                                                   onChanged: (_) async {
//                                                     final taskService = ref.read(
//                                                       taskServiceProvider,
//                                                     );
//                                                     if (taskService != null) {
//                                                       try {
//                                                         await taskService
//                                                             .toggleTask(
//                                                               task.id,
//                                                               task.isCompleted,
//                                                             );
//                                                       } catch (e) {
//                                                         ScaffoldMessenger.of(
//                                                           context,
//                                                         ).showSnackBar(
//                                                           SnackBar(
//                                                             content: Text(
//                                                               "Error toggling task: $e",
//                                                             ),
//                                                             backgroundColor:
//                                                                 Colors.red,
//                                                           ),
//                                                         );
//                                                       }
//                                                     }
//                                                   },
//                                                 ),
//                                                 trailing: SizedBox(
//                                                   width: 96,
//                                                   child: Row(
//                                                     mainAxisAlignment:
//                                                         MainAxisAlignment.end,
//                                                     children: [
//                                                       IconButton(
//                                                         icon: const Icon(
//                                                           Icons
//                                                               .edit_note_outlined,
//                                                           color: Colors.grey,
//                                                         ),
//                                                         onPressed: () {
//                                                           showEditDialog(
//                                                             context,
//                                                             task.content,
//                                                             (updatedTask) async {
//                                                               final taskService =
//                                                                   ref.read(
//                                                                     taskServiceProvider,
//                                                                   );
//                                                               if (taskService !=
//                                                                   null) {
//                                                                 try {
//                                                                   await taskService
//                                                                       .editTask(
//                                                                         task.id,
//                                                                         updatedTask,
//                                                                       );
//                                                                 } catch (e) {
//                                                                   ScaffoldMessenger.of(
//                                                                     context,
//                                                                   ).showSnackBar(
//                                                                     SnackBar(
//                                                                       content: Text(
//                                                                         "Error editing task: $e",
//                                                                       ),
//                                                                       backgroundColor:
//                                                                           Colors
//                                                                               .red,
//                                                                     ),
//                                                                   );
//                                                                 }
//                                                               }
//                                                             },
//                                                           );
//                                                         },
//                                                       ),
//                                                       IconButton(
//                                                         icon: const Icon(
//                                                           Icons.delete_outlined,
//                                                           color: Colors.grey,
//                                                           size: 25,
//                                                         ),
//                                                         onPressed:
//                                                             () => showDeleteConfirmationDialog(
//                                                               context,
//                                                               () async {
//                                                                 final taskService =
//                                                                     ref.read(
//                                                                       taskServiceProvider,
//                                                                     );
//                                                                 if (taskService !=
//                                                                     null) {
//                                                                   try {
//                                                                     await taskService
//                                                                         .deleteTask(
//                                                                           task.id,
//                                                                         );
//                                                                   } catch (e) {
//                                                                     ScaffoldMessenger.of(
//                                                                       context,
//                                                                     ).showSnackBar(
//                                                                       SnackBar(
//                                                                         content: Text(
//                                                                           "Error deleting task: $e",
//                                                                         ),
//                                                                         backgroundColor:
//                                                                             Colors
//                                                                                 .red,
//                                                                       ),
//                                                                     );
//                                                                   }
//                                                                 }
//                                                               },
//                                                             ),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ),
//                                               ),
//                                             );
//                                           },
//                                         );
//                                       }
//                                     },
//                                     loading:
//                                         () => const Center(
//                                           child: CircularProgressIndicator(),
//                                         ),
//                                     error:
//                                         (e, _) => Center(
//                                           child: Text(
//                                             "Error: $e",
//                                             style: TextStyle(color: Colors.red),
//                                           ),
//                                         ),
//                                   );
//                                 },
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       );
//     }

//     Widget _buildNoSearchResults(String searchQuery) {
//       return Container(
//         width: 350,
//         decoration: BoxDecoration(
//           color: Colors.transparent,
//           border: Border(top: BorderSide(color: Colors.grey[800]!)),
//           borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(10),
//             topRight: Radius.circular(10),
//           ),
//         ),
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               SizedBox(height: 80.h),
//               Icon(Icons.search_off, size: 40.w, color: Colors.grey[700]),
//               SizedBox(height: 10.h),
//               Text(
//                 "No tasks found",
//                 style: Theme.of(context).textTheme.bodyLarge?.copyWith(
//                   fontSize: 17,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.grey[700],
//                 ),
//               ),
//               Text(
//                 "No tasks match '$searchQuery'",
//                 maxLines: 2,
//                 textAlign: TextAlign.center,
//                 style: Theme.of(context).textTheme.bodyLarge?.copyWith(
//                   fontSize: 15,
//                   color: Colors.grey[700],
//                 ),
//               ),
//               SizedBox(height: 10),
//               TextButton(
//                 onPressed: _clearSearch,
//                 child: Text(
//                   "Clear search",
//                   style: TextStyle(
//                     color: Colors.blueAccent,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     }

//     Widget _buildNoTasks() {
//       return Container(
//         width: 350,
//         decoration: BoxDecoration(
//           color: Colors.transparent,
//           border: Border(top: BorderSide(color: Colors.grey[800]!)),
//           borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(10),
//             topRight: Radius.circular(10),
//           ),
//         ),
//         child: Column(
//           children: [
//             SizedBox(height: 80.h),
//             Icon(Icons.difference_outlined, size: 40.w, color: Colors.grey[700]),
//             SizedBox(height: 10.h),
//             Text(
//               MessageGenerator.getMessage("no_task"),
//               style: Theme.of(context).textTheme.bodyLarge?.copyWith(
//                 fontSize: 17,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.grey[700],
//               ),
//             ),
//             Text(
//               maxLines: 2,
//               textAlign: TextAlign.center,
//               MessageGenerator.getMessage("no_task_dec"),
//               style: Theme.of(context).textTheme.bodyLarge?.copyWith(
//                 fontSize: 17,
//                 color: Colors.grey[700],
//               ),
//             ),
//           ],
//         ),
//       );
//     }

//     // Method to highlight search terms in task content
//     TextSpan _buildHighlightedText(
//       String text,
//       String searchQuery,
//       bool isCompleted,
//     ) {
//       if (searchQuery.isEmpty) {
//         return TextSpan(
//           text: text,
//           style: TextStyle(
//             color: isCompleted ? Colors.grey[500] : Colors.white,
//             decoration:
//                 isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
//             decorationColor: Colors.grey[800],
//             decorationThickness: 3,
//           ),
//         );
//       }

//       final List<TextSpan> spans = [];
//       final String lowerText = text.toLowerCase();
//       final String lowerQuery = searchQuery.toLowerCase();
//       int start = 0;

//       while (true) {
//         final int index = lowerText.indexOf(lowerQuery, start);
//         if (index == -1) {
//           if (start < text.length) {
//             spans.add(
//               TextSpan(
//                 text: text.substring(start),
//                 style: TextStyle(
//                   color: isCompleted ? Colors.grey[500] : Colors.white,
//                   decoration:
//                       isCompleted
//                           ? TextDecoration.lineThrough
//                           : TextDecoration.none,
//                   decorationColor: Colors.grey[800],
//                   decorationThickness: 3,
//                 ),
//               ),
//             );
//           }
//           break;
//         }

//         if (index > start) {
//           spans.add(
//             TextSpan(
//               text: text.substring(start, index),
//               style: TextStyle(
//                 color: isCompleted ? Colors.grey[500] : Colors.white,
//                 decoration:
//                     isCompleted
//                         ? TextDecoration.lineThrough
//                         : TextDecoration.none,
//                 decorationColor: Colors.grey[800],
//                 decorationThickness: 3,
//               ),
//             ),
//           );
//         }

//         spans.add(
//           TextSpan(
//             text: text.substring(index, index + searchQuery.length),
//             style: TextStyle(
//               color: isCompleted ? Colors.orange[300] : Colors.yellow[300],
//               backgroundColor: Colors.yellow[700]?.withOpacity(0.3),
//               fontWeight: FontWeight.bold,
//               decoration:
//                   isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
//               decorationColor: Colors.grey[800],
//               decorationThickness: 3,
//             ),
//           ),
//         );

//         start = index + searchQuery.length;
//       }

//       return TextSpan(children: spans);
//     }

//     Widget buildTaskCounters() {
//       return Consumer(
//         builder: (context, ref, child) {
//           final stats = ref.watch(searchStatsProvider);

//           if (stats == null) {
//             return _buildLoadingCounters();
//           }

//           return Column(
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   // Pending Tasks Count
//                   Row(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       Text(
//                         "Pending",
//                         style: Theme.of(context).textTheme.labelLarge?.copyWith(
//                           color: Colors.blueAccent,
//                         ),
//                       ),
//                       SizedBox(width: 5.w),
//                       CircleAvatar(
//                         backgroundColor: const Color(0xFF333333),
//                         radius: 10,
//                         child: Center(
//                           child: Text(
//                             stats['pendingCount'].toString(),
//                             style: Theme.of(
//                               context,
//                             ).textTheme.bodySmall?.copyWith(
//                               color: Colors.white,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   // Completed Tasks Count
//                   Row(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       Text(
//                         "Completed",
//                         style: Theme.of(context).textTheme.labelLarge?.copyWith(
//                           color: Colors.blueAccent,
//                         ),
//                       ),
//                       SizedBox(width: 5.w),
//                       CircleAvatar(
//                         backgroundColor: const Color(0xFF333333),
//                         radius: 10,
//                         child: Center(
//                           child: Text(
//                             stats['completedCount'].toString(),
//                             style: Theme.of(
//                               context,
//                             ).textTheme.bodySmall?.copyWith(
//                               color: Colors.white,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//               // Show filter info if searching
//               if (stats['isSearching'] &&
//                   stats['filteredTasks'] < stats['totalTasks'])
//                 Padding(
//                   padding: const EdgeInsets.only(top: 8),
//                   child: Text(
//                     "Showing ${stats['filteredTasks']} of ${stats['totalTasks']} tasks",
//                     style: TextStyle(
//                       color: Colors.grey[500],
//                       fontSize: 12,
//                       fontStyle: FontStyle.italic,
//                     ),
//                   ),
//                 ),
//             ],
//           );
//         },
//       );
//     }

//     Widget _buildLoadingCounters() {
//       return Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Row(
//             children: [
//               Text(
//                 "Pending",
//                 style: Theme.of(
//                   context,
//                 ).textTheme.labelLarge?.copyWith(color: Colors.blueAccent),
//               ),
//               SizedBox(width: 5.w),
//               const CircleAvatar(
//                 backgroundColor: Color(0xFF333333),
//                 radius: 10,
//                 child: SizedBox(
//                   width: 12,
//                   height: 12,
//                   child: CircularProgressIndicator(
//                     strokeWidth: 2,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           Row(
//             children: [
//               Text(
//                 "Completed",
//                 style: Theme.of(
//                   context,
//                 ).textTheme.labelLarge?.copyWith(color: Colors.blueAccent),
//               ),
//               SizedBox(width: 5.w),
//               const CircleAvatar(
//                 backgroundColor: Color(0xFF333333),
//                 radius: 10,
//                 child: SizedBox(
//                   width: 12,
//                   height: 12,
//                   child: CircularProgressIndicator(
//                     strokeWidth: 2,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       );
//     }

//     Widget buildInfoRow(String label, String value) {
//       return Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(
//             width: 120.w,
//             child: Text(
//               label,
//               style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                 color: Colors.grey[400],
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ),
//           Expanded(
//             child: Text(
//               value,
//               style: Theme.of(
//                 context,
//               ).textTheme.bodyMedium?.copyWith(color: Colors.white),
//             ),
//           ),
//         ],
//       );
//     }

//     void _showSignOutDialog(BuildContext context) {
//       showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             backgroundColor: appColors.inputBgFill,
//             title: Text(
//               MessageGenerator.getLabel("Sign Out"),
//               style: TextStyle(color: Colors.white),
//             ),
//             content: Text(
//               MessageGenerator.getLabel("Are you sure you want to sign out?"),
//               style: TextStyle(color: Colors.grey[300]),
//             ),
//             actions: [
//               TextButton(
//                 onPressed: () => Navigator.of(context).pop(),
//                 child: Text(
//                   MessageGenerator.getLabel("Cancel"),
//                   style: TextStyle(color: Colors.grey[400]),
//                 ),
//               ),
//               TextButton(
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                   _handleSignOut();
//                 },
//                 child: Text(
//                   MessageGenerator.getLabel("Sign Out"),
//                   style: TextStyle(color: Colors.red[400]),
//                 ),
//               ),
//             ],
//           );
//         },
//       );
//     }

 

//     void _handleSignOut() {
//       ref.read(authNotifierProvider.notifier).signOut();
//     }

//     void _showAddBottomSheet(BuildContext context) {
//       final TextEditingController taskController = TextEditingController();

//       showModalBottomSheet(
//         context: context,
//         isScrollControlled: true, // lets the sheet expand fully if needed
//         backgroundColor: const Color(0xFF262626),
//         shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//         ),
//         builder: (BuildContext context) {
//           return Padding(
//             padding: EdgeInsets.only(
//               left: 16,
//               right: 16,
//               top: 20,
//               bottom:
//                   MediaQuery.of(context).viewInsets.bottom +
//                   16, // moves up when keyboard opens
//             ),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Title
//                 const Text(
//                   "Add Task",
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 16),

//                 // Input Field
//                 TextField(
//                   controller: taskController,
//                   style: const TextStyle(color: Colors.white),
//                   cursorColor: Colors.white,
//                   decoration: InputDecoration(
//                     hintText: "Enter your task...",
//                     hintStyle: TextStyle(color: Colors.grey[500]),
//                     filled: true,
//                     fillColor: const Color(0xFF2E2E2E),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                       borderSide: BorderSide.none,
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                       borderSide: const BorderSide(color: Colors.white),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 20),

//                 // Buttons Row
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     TextButton(
//                       onPressed: () => Navigator.of(context).pop(),
//                       child: Text(
//                         "Cancel",
//                         style: TextStyle(color: Colors.grey[400]),
//                       ),
//                     ),
//                     const SizedBox(width: 8),
//                     ElevatedButton(
//                       onPressed: () async {
//                         String newTask = taskController.text.trim();
//                         if (newTask.isNotEmpty) {
//                           final taskService = ref.read(taskServiceProvider);
//                           if (taskService != null) {
//                             try {
//                               await taskService.addTask(newTask);
//                               Navigator.of(context).pop();
//                             } catch (e) {
//                               Navigator.of(context).pop();
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 SnackBar(
//                                   content: Text("Error adding task: $e"),
//                                   backgroundColor: Colors.red,
//                                 ),
//                               );
//                             }
//                           } else {
//                             Navigator.of(context).pop();
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               const SnackBar(
//                                 content: Text("Please sign in to add tasks"),
//                                 backgroundColor: Colors.red,
//                               ),
//                             );
//                           }
//                         } else {
//                           Navigator.of(context).pop();
//                         }
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.blueAccent,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                       ),
//                       child: const Text(
//                         "Add",
//                         style: TextStyle(color: Colors.white),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           );
//         },
//       );
//     }
//   }

  

 
  
