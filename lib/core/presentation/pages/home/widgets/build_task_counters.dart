// import 'package:Arkroot/core/presentation/reverpode_providers/task_service_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// Widget buildTaskCounters() {
//     return Consumer(
//       builder: (context, ref, child) {
//         final tasksAsync = ref.watch(taskProvider);

//         return tasksAsync.when(
//           data: (tasks) {
//             final pendingCount = tasks.where((task) => !task.isCompleted).length;
//             final completedCount = tasks.where((task) => task.isCompleted).length;

//             return Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
//               child: Row(
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
//                             pendingCount.toString(),
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
//                             completedCount.toString(),
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
//             );
//           },
//           loading:
//               () => Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Row(
//                       children: [
//                         Text(
//                           "Pending",
//                           style: Theme.of(context).textTheme.labelLarge?.copyWith(
//                             color: Colors.blueAccent,
//                           ),
//                         ),
//                         SizedBox(width: 5.w),
//                         const CircleAvatar(
//                           backgroundColor: Color(0xFF333333),
//                           radius: 10,
//                           child: SizedBox(
//                             width: 12,
//                             height: 12,
//                             child: CircularProgressIndicator(
//                               strokeWidth: 2,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     Row(
//                       children: [
//                         Text(
//                           "Completed",
//                           style: Theme.of(context).textTheme.labelLarge?.copyWith(
//                             color: Colors.blueAccent,
//                           ),
//                         ),
//                         SizedBox(width: 5.w),
//                         const CircleAvatar(
//                           backgroundColor: Color(0xFF333333),
//                           radius: 10,
//                           child: SizedBox(
//                             width: 12,
//                             height: 12,
//                             child: CircularProgressIndicator(
//                               strokeWidth: 2,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//           error:
//               (e, _) => Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Row(
//                       children: [
//                         Text(
//                           "Pending",
//                           style: Theme.of(context).textTheme.labelLarge?.copyWith(
//                             color: Colors.blueAccent,
//                           ),
//                         ),
//                         SizedBox(width: 5.w),
//                         const CircleAvatar(
//                           backgroundColor: Color(0xFF333333),
//                           radius: 10,
//                           child: Icon(Icons.error, size: 12, color: Colors.red),
//                         ),
//                       ],
//                     ),
//                     Row(
//                       children: [
//                         Text(
//                           "Completed",
//                           style: Theme.of(
//                             context,
//                           ).textTheme.labelLarge?.copyWith(color: Colors.green),
//                         ),
//                         SizedBox(width: 5.w),
//                         const CircleAvatar(
//                           backgroundColor: Color(0xFF333333),
//                           radius: 10,
//                           child: Icon(Icons.error, size: 12, color: Colors.red),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//         );
//       },
//     );
//   }
