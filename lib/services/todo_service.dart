import 'dart:convert';

import 'package:http/http.dart' as http;

class TodoService{
  static Future<bool> deleteWithId(String id) async {
    final url = 'https://api.nstack.in/v1/todos/$id';
    final uri = Uri.parse(url);
    final response = await http.delete(uri);
    return response.statusCode == 200;
  }

  static Future<List?> getTodoList() async {
    const url = 'https://api.nstack.in/v1/todos?page=1';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map;
      print(json);
      final result = json['items'] as List;
      return result;
    } else {
      return null;
    }
  }

  static Future<bool> updateTodoList(String id, Map data) async {
    final url = 'https://api.nstack.in/v1/todos/$id';
    final uri = Uri.parse(url);
    final response = await http.put(
      uri,
      body: jsonEncode(data),
      headers: {'Content-Type': 'application/json'},
    );
    return response.statusCode == 200;
  }

  static Future<bool> addTodo(Map data) async {
    const url = 'https://api.nstack.in/v1/todos';
    final uri = Uri.parse(url);
    final response = await http.put(
      uri,
      body: jsonEncode(data),
      headers: {'Content-Type': 'application/json'},
    );
    return response.statusCode == 201;
  }
}