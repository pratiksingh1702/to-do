import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'todo.g.dart';

@HiveType(typeId: 0)
class Todo extends HiveObject {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final String? description;

  @HiveField(2)
  final List<String> tags;

  @HiveField(3)
  final DateTime date;

  @HiveField(4)
  final String? startTime;

  @HiveField(5)
  final String? endTime;

  @HiveField(6)
  bool isDone;

  @HiveField(7)
  final bool isImportant;

  @HiveField(8)
  final int statusColorValue;

  @HiveField(9)
  final DateTime createdAt;

  @HiveField(10)
   String? status; // 'pending', 'completed', 'missed'

  Todo({
    required this.title,
    this.description,
    this.tags = const [],
    required this.date,
    this.startTime,
    this.endTime,
    this.isDone = false,
    this.isImportant = false,
    Color statusColor = Colors.red,
    DateTime? createdAt,
    this.status ,
  })  : statusColorValue = statusColor.value,
        createdAt = createdAt ?? DateTime.now();

  Color get statusColor => Color(statusColorValue);

  Todo copyWith({
    String? title,
    String? description,
    List<String>? tags,
    DateTime? date,
    String? startTime,
    String? endTime,
    bool? isDone,
    bool? isImportant,
    Color? statusColor,
    DateTime? createdAt,
    String? status,
  }) {
    return Todo(
      title: title ?? this.title,
      description: description ?? this.description,
      tags: tags ?? this.tags,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      isDone: isDone ?? this.isDone,
      isImportant: isImportant ?? this.isImportant,
      statusColor: statusColor ?? Color(statusColorValue),
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
    );
  }
}
