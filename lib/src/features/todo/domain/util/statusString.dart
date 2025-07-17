import 'package:flutter/material.dart';

import '../models/todo.dart';

String calculateStatus(DateTime date, String? endTime, bool isDone) {
  if (isDone) return 'completed';
  print(endTime);
  print("sssssssssss");

  final now = DateTime.now();
  final endDateTime = DateTime(
    date.year,
    date.month,
    date.day,
    int.parse(endTime!.split(':')[0]),
    int.parse(endTime.split(':')[1].split(' ')[0]),
  );

  return now.isAfter(endDateTime) ? 'You missed 😔' : 'I am Pending 🥺';
}

