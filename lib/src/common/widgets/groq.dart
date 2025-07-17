import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../features/todo/domain/models/todo.dart'; // Adjust your import path.

class GroqService {
  final String apiKey = '';
  final String endpoint = 'https://api.groq.com/openai/v1/chat/completions';

  Future<String?> summarizeTodos(List<Todo> todos) async {
    final formattedTasks = todos.map((todo) {
      return "- Title: ${todo.title}\n"
          "  Importance: ${todo.isImportant ? 'Important' : 'Not Important'}\n"
          "  Time: ${todo.startTime} - ${todo.endTime}\n";
    }).join('\n');

    final prompt = '''
You are a helpful AI assistant. 
Please read today's to-dos and summarize them into a **friendly, short list**. 
Make sure to capture:
- What is important
- What needs to be done
- Time ranges

also add some emojis and analyze the task to give some tips

Make the tone clear and simple.

Tasks:
$formattedTasks
''';

    try {
      final response = await http.post(
        Uri.parse(endpoint),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "model": "llama3-70b-8192",
          "messages": [
            {"role": "user", "content": prompt}
          ],
          "temperature": 0.3,
          "max_tokens": 200,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final content = data['choices'][0]['message']['content'];
        return content?.trim();
      } else {
        print('Groq API Error: ${response.statusCode} -> ${response.body}');
        return null;
      }
    } catch (e) {
      print('Groq Exception: $e');
      return null;
    }
  }
}
