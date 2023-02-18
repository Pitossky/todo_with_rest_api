import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todo_app_with_rest_api/services/todo_service.dart';

import '../utils/snackbar_helpers.dart';

class AddTodo extends StatefulWidget {
  final Map? todo;
  const AddTodo({
    Key? key,
    this.todo,
  }) : super(key: key);

  @override
  State<AddTodo> createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  bool edited = false;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController();
    descriptionController = TextEditingController();
    final todo = widget.todo;
    if (widget.todo != null) {
      edited = true;
      final title = todo!['title'];
      final description = todo['description'];
      titleController.text = title;
      descriptionController.text = description;
    }
  }

  Future<void> submitTodo() async {
    final response = await TodoService.addTodo(body);
    if (response) {
      titleController.text = '';
      descriptionController.text = '';
      showDataMsg(
        context,
        message: 'Successful!',
        color: Colors.white,
        textColor: Colors.black,
      );
    } else {
      //print(response.body);
      showDataMsg(
        context,
        message: 'Failed!',
        color: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  Future<void> updateTodo() async {
    final todo = widget.todo;
    if (todo == null) return;
    final id = todo['_id'];
    final response = await TodoService.updateTodoList(id, body);
    if (response) {
      // titleController.text = '';
      // descriptionController.text = '';
      //print(response.body);
      showDataMsg(
        context,
        message: 'Successful!',
        color: Colors.white,
        textColor: Colors.black,
      );
    } else {
      //print(response.body);
      showDataMsg(
        context,
        message: 'Failed!',
        color: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  Map get body {
    final title = titleController.text;
    final description = descriptionController.text;
    return {
      "title": title,
      "description": description,
      "is_completed": false
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          edited ? 'Edit Todo' : 'Add Todo',
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(hintText: 'Title'),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: descriptionController,
            decoration: const InputDecoration(hintText: 'Description'),
            minLines: 5,
            maxLines: 8,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: edited ? updateTodo : submitTodo,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                edited ? 'Update' : 'Submit',
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
