import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/todo.dart';
import '../providers/todo_provider.dart';

class TaskDetailScreen extends ConsumerWidget {
  final Todo todo;

  const TaskDetailScreen({
    Key? key,
    required this.todo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    final todos = ref.watch(todoProvider);
    final updatedTodo = todos.firstWhere((t) => t.title == todo.title, orElse: () => todo);

    Color statusColor;
    if (updatedTodo.status == 'completed') {
      statusColor = Colors.green;
    } else if (updatedTodo.status == 'missed') {
      statusColor = Colors.red;
    } else {
      statusColor = Colors.orange;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      updatedTodo.title,
                      style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () async {
                      final notifier = ref.read(todoProvider.notifier);
                      await notifier.updateStatus(updatedTodo, updatedTodo.isDone ? 'pending' : 'completed');
                      updatedTodo.isDone = !updatedTodo.isDone;
                      await updatedTodo.save();
                      ref.invalidate(todoProvider);
                    },
                    child: Chip(
                      backgroundColor: statusColor.withOpacity(0.2),
                      label: Text(
                        updatedTodo.status!.toUpperCase(),
                        style: TextStyle(
                          color: statusColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              if (updatedTodo.description != null && updatedTodo.description!.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Description',
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      updatedTodo.description!,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.8),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              Text(
                'Tags',
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: updatedTodo.tags.map((tag) {
                  return Chip(
                    label: Text(tag),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              Text(
                'Schedule',
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.calendar_today_outlined, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    "${updatedTodo.date.day}/${updatedTodo.date.month}/${updatedTodo.date.year}",
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.access_time_outlined, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    "${updatedTodo.startTime ?? '-'} - ${updatedTodo.endTime ?? '-'}",
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
