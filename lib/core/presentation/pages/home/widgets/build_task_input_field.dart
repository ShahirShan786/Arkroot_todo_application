// Updated buildTaskInputField function with date picker
import 'package:Arkroot/core/presentation/pages/home/widgets/show_add_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart'; // Add this dependency to pubspec.yaml

Widget buildTaskInputField(
  TextEditingController titleController,
  TextEditingController descriptionController,
  WidgetRef ref,
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
      // Date Picker Field
      Consumer(
        builder: (context, ref, child) {
          final selectedDate = ref.watch(selectedDateProvider);
          
          return GestureDetector(
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
              
              if (picked != null && picked != selectedDate) {
                ref.read(selectedDateProvider.notifier).state = picked;
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
                        ? DateFormat('dd-MMM-yyyy').format(selectedDate)
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
                        ref.read(selectedDateProvider.notifier).state = null;
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
          );
        },
      ),
    ],
  );
}

// Helper function to get the selected date from anywhere in your app
DateTime? getSelectedDate(WidgetRef ref) {
  return ref.read(selectedDateProvider);
}











// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// Widget buildTaskInputField(
//     TextEditingController titleController,
//     TextEditingController descriptionController,
//   ) {
//     return Column(
//       spacing: 10.h,
//       children: [
//         TextField(
//           controller: titleController,
//           style: const TextStyle(color: Colors.white),
//           cursorColor: Colors.white,
//           decoration: InputDecoration(
//             hintText: "Title",
//             hintStyle: TextStyle(color: Colors.grey[500]),
//             filled: true,
//             fillColor: const Color(0xFF2E2E2E),
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide: BorderSide.none,
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide: const BorderSide(color: Colors.white),
//             ),
//           ),
//         ),
//         TextField(
//           controller: descriptionController,
//           style: const TextStyle(color: Colors.white),
//           cursorColor: Colors.white,
//           decoration: InputDecoration(
//             hintText: "Description",
//             hintStyle: TextStyle(color: Colors.grey[500]),
//             filled: true,
//             fillColor: const Color(0xFF2E2E2E),
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide: BorderSide.none,
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide: const BorderSide(color: Colors.white),
//             ),
//           ),
//         ),
//       ],
//     );
//   }