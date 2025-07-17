import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/model/user-model.dart';
import 'package:http/http.dart' as http;
final userProvider = FutureProvider<List<UserModel>>((ref) async {
  try {
    final response = await http.get(
      Uri.parse('https://jsonplaceholder.typicode.com/users'),
      headers: {'Accept': 'application/json'},
    );

    print('Status Code: ${response.statusCode}');

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((e) => UserModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load users. Status code: ${response.statusCode}');
    }
  } catch (e, stackTrace) {
    print('UserProvider Error: $e');
    print(stackTrace);
    throw Exception('Something went wrong while fetching users: $e');
  }
});
