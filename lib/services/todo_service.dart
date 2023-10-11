import 'dart:convert';
import 'package:http/http.dart' as http;

class TodoService {
  static Future<List?> fetchTodos() async {
    final response = await http.get(
      Uri.parse('https://todo-api.dimasoktafianto.my.id/api/todos'),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map;
      final result = json['data'] as List;

      return result;
    } else {
      return null;
    }
  }

  static Future<bool> addTodo(Map body) async {
    final response = await http.post(
      Uri.parse('https://todo-api.dimasoktafianto.my.id/api/todos/store'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );

    return response.statusCode == 201;
  }

  static Future<bool> updateTodo(String id, Map body) async {
    final response = await http.patch(
      Uri.parse('https://todo-api.dimasoktafianto.my.id/api/todos/$id/update'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );

    return response.statusCode == 200;
  }

  static Future<bool> deleteById(String id) async {
    final response = await http.delete(
      Uri.parse('https://todo-api.dimasoktafianto.my.id/api/todos/$id/delete'),
    );

    return response.statusCode == 200;
  }
}
