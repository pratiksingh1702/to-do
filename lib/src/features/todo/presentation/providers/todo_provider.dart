import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../domain/models/todo.dart';
import '../../domain/util/statusString.dart';

const String _todosBoxName = 'todos';

class TodoNotifier extends StateNotifier<List<Todo>> {
  Timer? _statusCheckTimer;

  TodoNotifier() : super([]) {
    _loadTodos();
    _startStatusCheck();
  }

  Future<void> _loadTodos() async {
    try {
      final box = await Hive.openBox<Todo>(_todosBoxName);
      state = box.values.toList();
    } catch (e) {
      state = [];
    }
  }

  void _startStatusCheck() {
    _statusCheckTimer?.cancel();
    _statusCheckTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      _updateStatuses();
    });
  }

  Future<void> _updateStatuses() async {
    final box = await Hive.openBox<Todo>(_todosBoxName);
    final updatedTodos = <Todo>[];

    for (var todo in box.values) {
      final newStatus = calculateStatus(todo.date, todo.endTime, todo.isDone);
      if (todo.status != newStatus) {
        todo.status = newStatus;
        await todo.save();
      }
      updatedTodos.add(todo);
    }

    state = [...updatedTodos];
  }

  Future<Todo?> addTodo({
    required String title,
    required String description,
    required List<String> tags,
    required DateTime date,
    required String startTime,
    required String endTime,
    required bool isImportant,
    required Color statusColor,
  }) async {
    try {
      final status = calculateStatus(date, endTime, false);

      final box = await Hive.openBox<Todo>(_todosBoxName);
      final todo = Todo(
        title: title,
        description: description,
        tags: tags,
        date: date,
        startTime: startTime,
        endTime: endTime,
        isImportant: isImportant,
        status: status,
        statusColor: statusColor,
      );

      await box.add(todo);
      state = [...state, todo];
      return todo;
    } catch (e) {
      return null;
    }
  }

  Future<void> updateStatus(Todo todo, String newStatus) async {
    final box = await Hive.openBox<Todo>(_todosBoxName);
    todo.status = newStatus;
    print(todo.status);
    print("llllllllllllllllllllllllllllll");
    await todo.save();
    state = [...state];
  }

  Future<bool> removeTodo(Todo todo) async {
    try {
      final box = await Hive.openBox<Todo>(_todosBoxName);
      await todo.delete();
      state = state.where((t) => t.key != todo.key).toList();
      return true;
    } catch (e) {
      return false;
    }
  }

  List<Todo> getTodosByDate(DateTime date) {
    return state
        .where((todo) =>
    todo.date.year == date.year &&
        todo.date.month == date.month &&
        todo.date.day == date.day)
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  Todo? getTodoByIndex(int index) {
    if (index >= 0 && index < state.length) {
      return state[index];
    }
    return null;
  }

  @override
  void dispose() {
    _statusCheckTimer?.cancel();
    super.dispose();
  }
}

final todoProvider = StateNotifierProvider<TodoNotifier, List<Todo>>((ref) {
  return TodoNotifier();
});
