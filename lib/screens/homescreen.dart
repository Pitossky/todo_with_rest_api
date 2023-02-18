import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:todo_app_with_rest_api/screens/add_todo.dart';
import 'package:http/http.dart' as http;
import 'package:todo_app_with_rest_api/services/todo_service.dart';
import 'package:todo_app_with_rest_api/widget/todo_card.dart';

import '../utils/snackbar_helpers.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = true;
  List todoItems = [];

  @override
  void initState() {
    super.initState();
    fetchAllTodos();
  }

  Future<void> _navigateToAddTodo() async {
    final route = MaterialPageRoute(
      builder: (_) => const AddTodo(),
    );
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchAllTodos();
  }

  Future<void> _navigateToEdit(Map item) async {
    final route = MaterialPageRoute(
      builder: (_) => AddTodo(todo: item),
    );
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchAllTodos();
  }

  Future<void> fetchAllTodos() async {
    final response = TodoService.getTodoList();
    if (response != null) {
      final listed = await response;
      setState(() {
        todoItems = listed as List;
      });
    } else {
      showDataMsg(
        context,
        message: 'Failed!',
        color: Colors.red,
        textColor: Colors.white,
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> deleteById(String id) async {
    final response = await TodoService.deleteWithId(id);
    if (response) {
      final filtered =
          todoItems.where((element) => element['_id'] != id).toList();
      print('original list: ${todoItems.length}');
      setState(() {
        todoItems = filtered;
        print('filtered list again: ${todoItems.length}');
      });
    } else{
      print(response);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
      ),
      body: Visibility(
        visible: todoItems.isEmpty,
        replacement: RefreshIndicator(
          onRefresh: fetchAllTodos,
          child: ListView.builder(
              itemCount: todoItems.length,
              itemBuilder: (_, index) {
                final item = todoItems[index] as Map;
                return TodoCard(
                    index: index,
                    item: item,
                    navigateEdit: _navigateToEdit,
                    deleteTodo: deleteById,
                );
              }),
        ),
        child: Center(
          child: Text(
            'No Todo Items!',
            style: Theme.of(context).textTheme.headline3,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _navigateToAddTodo,
        label: const Text('Add Todo'),
      ),
    );
  }
}
