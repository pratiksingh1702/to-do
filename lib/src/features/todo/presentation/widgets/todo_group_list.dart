// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../../domain/models/todo.dart';
// import '../providers/todo_provider.dart';
// import 'todo_item.dart';
//
// class TodoGroupList extends ConsumerWidget {
//   final bool showImportant; // Instead of TaskGroupType
//
//   const TodoGroupList({
//     Key? key,
//     this.showImportant = false,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final todos = ref.watch(todoProvider);
//     final filteredTodos = todos
//         .where((todo) => todo.isImportant == showImportant)
//         .toList()
//       ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
//
//     final String title = showImportant ? 'Important' : 'Other';
//
//     return AnimatedSwitcher(
//       duration: const Duration(milliseconds: 300),
//       child: filteredTodos.isEmpty
//           ? Center(
//         key: ValueKey('empty-$title'),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               showImportant ? Icons.star : Icons.low_priority,
//               size: 64,
//               color: Theme.of(context)
//                   .colorScheme
//                   .primary
//                   .withOpacity(0.3),
//             ),
//             const SizedBox(height: 16),
//             Text(
//               'No $title Tasks',
//               style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                 color: Theme.of(context)
//                     .textTheme
//                     .bodyMedium
//                     ?.color
//                     ?.withOpacity(0.5),
//               ),
//             ),
//           ],
//         ),
//       )
//           : ListView.builder(
//         key: ValueKey('list-$title'),
//         itemCount: filteredTodos.length,
//         padding: const EdgeInsets.all(16),
//         itemBuilder: (context, index) {
//           final todo = filteredTodos[index];
//           return Dismissible(
//             key: ValueKey(todo.key ?? todo.title),
//             background: Container(
//               decoration: BoxDecoration(
//                 color: Colors.red.shade100,
//                 borderRadius: BorderRadius.circular(16),
//               ),
//               alignment: Alignment.centerRight,
//               padding: const EdgeInsets.only(right: 16),
//               child: const Icon(
//                 Icons.delete,
//                 color: Colors.red,
//               ),
//             ),
//             direction: DismissDirection.endToStart,
//             onDismissed: (_) async {
//               final success =
//               await ref.read(todoProvider.notifier).removeTodo(todo);
//               if (!success) {
//                 if (!context.mounted) return;
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(
//                     content: Text('Failed to delete task'),
//                     backgroundColor: Colors.red,
//                   ),
//                 );
//                 return;
//               }
//
//               if (!context.mounted) return;
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(
//                   content: Text('Task "${todo.title}" deleted'),
//                   action: SnackBarAction(
//                     label: 'Undo',
//                     onPressed: () async {
//                       final newTodo =
//                       await ref.read(todoProvider.notifier).addTodo(
//                         title: todo.title,
//                         description: todo.description,
//                         tags: todo.tags,
//                         date: todo.date,
//                         startTime: todo.startTime,
//                         endTime: todo.endTime,
//                         isImportant: todo.isImportant,
//                         statusColor: todo.statusColor,
//                       );
//                       if (newTodo == null && context.mounted) {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           const SnackBar(
//                             content: Text('Failed to restore task'),
//                             backgroundColor: Colors.red,
//                           ),
//                         );
//                       }
//                     },
//                   ),
//                 ),
//               );
//             },
//             child: TodoItem(
//               todo: todo,
//               onToggle: () async {
//                 final success =
//                 await ref.read(todoProvider.notifier).toggleTodo(todo);
//                 if (!success && context.mounted) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(
//                       content: Text('Failed to update task'),
//                       backgroundColor: Colors.red,
//                     ),
//                   );
//                 }
//               },
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
