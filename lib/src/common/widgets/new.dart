import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../features/todo/domain/models/todo.dart';
import '../../features/todo/presentation/providers/todo_provider.dart';
import '../../features/todo/presentation/screens/taskDetail.dart';
import '../../features/todo/presentation/widgets/add_todo_button.dart';
import 'groq.dart';


enum SortOption { importance, startTime, endTime }

class TaskHomeScreen extends ConsumerStatefulWidget {
  const TaskHomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<TaskHomeScreen> createState() => _TaskHomeScreenState();
}

class _TaskHomeScreenState extends ConsumerState<TaskHomeScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  SortOption _sortOption = SortOption.importance;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
  }

  void toggleCalendarFormat(bool expand) {
    setState(() {
      _calendarFormat = expand ? CalendarFormat.month : CalendarFormat.week;
    });
  }

  List<Todo> sortedTodos(List<Todo> todos) {
    switch (_sortOption) {
      case SortOption.importance:
        return [...todos]..sort((a, b) => b.isImportant ? 1 : -1);
      case SortOption.startTime:
        return [...todos]..sort((a, b) => (a.startTime ?? '').compareTo(b.startTime ?? ''));
      case SortOption.endTime:
        return [...todos]..sort((a, b) => (a.endTime ?? '').compareTo(b.endTime ?? ''));
      default:
        return todos;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final todos = ref.watch(todoProvider);

    final selectedTodos = sortedTodos(
      todos.where((todo) => _isSameDate(todo.date, _selectedDay ?? DateTime.now())).toList(),
    );

    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${_focusedDay.monthName} ${_focusedDay.year}",
                    style: GoogleFonts.montserrat(
                      color: theme.colorScheme.onSurface,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TableCalendar(
                    rowHeight: 48,
                    firstDay: DateTime.utc(2020),
                    lastDay: DateTime.utc(2030),
                    focusedDay: _focusedDay,
                    selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                      });
                    },
                    onPageChanged: (focusedDay) {
                      setState(() => _focusedDay = focusedDay);
                    },
                    calendarFormat: _calendarFormat,
                    availableGestures: AvailableGestures.horizontalSwipe,
                    headerVisible: false,
                    daysOfWeekVisible: true,
                    calendarStyle: CalendarStyle(
                      todayDecoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                      selectedDecoration: BoxDecoration(
                        color: theme.colorScheme.secondary,
                        shape: BoxShape.circle,
                      ),
                      defaultTextStyle: TextStyle(color: theme.colorScheme.onSurface),
                      weekendTextStyle: TextStyle(
                        color: theme.colorScheme.onSurface.withAlpha(178),
                      ),
                      todayTextStyle: TextStyle(color: theme.colorScheme.onPrimary),
                    ),
                    daysOfWeekStyle: DaysOfWeekStyle(
                      weekendStyle: TextStyle(color: theme.colorScheme.onSurface.withAlpha(178)),
                      weekdayStyle: TextStyle(color: theme.colorScheme.onSurface),
                    ),
                  ),
                ],
              ),
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
              top: _calendarFormat == CalendarFormat.month ? screenHeight * 0.45 : screenHeight * 0.14,
              left: 0,
              right: 0,
              bottom: 0,
              child: GestureDetector(
                onVerticalDragUpdate: (details) {
                  if (details.delta.dy > 5) {
                    toggleCalendarFormat(true);
                  } else if (details.delta.dy < -5) {
                    toggleCalendarFormat(false);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          height: 5,
                          width: 40,
                          decoration: BoxDecoration(
                            color: theme.dividerColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Tasks on ${_selectedDay?.day} ${_selectedDay?.monthName}",
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          DropdownButton<SortOption>(
                            value: _sortOption,
                            underline: const SizedBox(),
                            icon: Icon(Icons.sort, color: theme.colorScheme.onSurface.withAlpha(178)),
                            dropdownColor: theme.colorScheme.surface,
                            items: [
                              DropdownMenuItem(
                                value: SortOption.importance,
                                child: Text('Sort: Importance'),
                              ),
                              DropdownMenuItem(
                                value: SortOption.startTime,
                                child: Text('Sort: Start Time'),
                              ),
                              DropdownMenuItem(
                                value: SortOption.endTime,
                                child: Text('Sort: End Time'),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() => _sortOption = value!);
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: selectedTodos.isEmpty
                            ? Center(
                          child: Text(
                            "No Tasks Available",
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: theme.colorScheme.onSurface.withOpacity(0.4),
                            ),
                          ),
                        )
                            : ListView.separated(
                          padding: const EdgeInsets.only(bottom: 40),
                          itemCount: selectedTodos.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 16),
                          itemBuilder: (context, index) {
                            final todo = selectedTodos[index];
                            return Dismissible(
                              key: Key(todo.title + todo.date.toString()),
                              direction: DismissDirection.endToStart,
                              background: Container(
                                padding: const EdgeInsets.only(right: 20),
                                alignment: Alignment.centerRight,
                                color: Colors.redAccent,
                                child: const Icon(Icons.delete, color: Colors.white),
                              ),
                              onDismissed: (_) async {
                                await ref.read(todoProvider.notifier).removeTodo(todo);
                              },
                              child: InkWell(
                                onTap:(){
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => TaskDetailScreen(todo: todo),
                                    ),
                                  );

                                } ,
                                child: _buildTaskCard(
                                  theme: theme,
                                  todo: todo,
                                ),
                              ),
                            );
                          },

                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: theme.colorScheme.primary,
        onPressed: () async {
          // final tasks = [
          //   "Fix the UI bug in TaskHomeScreen",
          //   "Prepare meeting slides for the demo",
          //   "Write test cases for Todo provider"
          // ];
          //
          // final groqService = GroqService();
          // final summary = await groqService.summarizeTasks(tasks);
          //
          // print(summary);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddTodoScreen()),
          );

          print("FAB Pressed for ${_selectedDay ?? DateTime.now()}");
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTaskCard({
    required ThemeData theme,
    required Todo todo,
  }) {
    final cardShape = theme.cardTheme.shape as RoundedRectangleBorder?;
    final borderRadius = cardShape?.borderRadius ?? BorderRadius.circular(16);
    final ValueNotifier<bool> isExpanded = ValueNotifier(false);

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool hasOverflow = _isTextOverflow(
          todo.description ?? '',
          theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.6),
          ),
          constraints.maxWidth,
          2,
        );

        return ValueListenableBuilder<bool>(
          valueListenable: isExpanded,
          builder: (context, expanded, _) {
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.cardTheme.color,
                borderRadius: borderRadius,
                boxShadow: [
                  BoxShadow(
                    color: theme.shadowColor.withOpacity(0.05),
                    blurRadius: 6,
                    spreadRadius: 2,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 8,
                    children: todo.tags.map((tag) {
                      final color = tag == 'Design' ? Colors.orangeAccent : Colors.blueGrey;
                      return Chip(
                        backgroundColor: color.withOpacity(0.15),
                        label: Text(tag, style: TextStyle(color: color)),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        todo.isImportant ? Icons.star : Icons.circle_outlined,
                        size: 16,
                        color: todo.statusColor,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          todo.title,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (todo.description != null && todo.description!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AnimatedCrossFade(
                            firstChild: Text(
                              todo.description!,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurface.withOpacity(0.6),
                              ),
                            ),
                            secondChild: Text(
                              todo.description!,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurface.withOpacity(0.6),
                              ),
                            ),
                            crossFadeState: expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                            duration: const Duration(milliseconds: 200),
                          ),
                          if (hasOverflow)
                            Align(
                              alignment: Alignment.centerRight,
                              child: IconButton(
                                icon: Icon(
                                  expanded ? Icons.expand_less : Icons.expand_more,
                                  size: 18,
                                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                                ),
                                onPressed: () => isExpanded.value = !expanded,
                              ),
                            ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _formatTimeRange(todo.startTime, todo.endTime),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.red,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        todo.status!,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.red,
                        ),
                      )

                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  bool _isTextOverflow(String text, TextStyle? style, double maxWidth, int maxLines) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: maxLines,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: maxWidth);
    return textPainter.didExceedMaxLines;
  }


  String _formatTimeRange(String? start, String? end) {
    if ((start == null || start.isEmpty) && (end == null || end.isEmpty)) return '';
    final startStr = start ?? '';
    final endStr = end ?? '';
    return '$startStr - $endStr';
  }

  bool _isSameDate(DateTime? a, DateTime? b) {
    if (a == null || b == null) return false;
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}

extension DateTimeExtensions on DateTime {
  String get monthName {
    return [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December"
    ][month - 1];
  }
}
