import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddTodoPage extends StatefulWidget {
  final Map? todo;
  const AddTodoPage({Key? key, this.todo}) : super(key: key);

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  bool isEdit = false;

  @override
  void initState() {
    super.initState();

    final todo = widget.todo;
    if (todo != null) {
      isEdit = true;

      final title = todo['title'];
      final description = todo['description'];
      titleController.text = title;
      descriptionController.text = description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Todo' : 'Add Todo'),
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
            keyboardType: TextInputType.multiline,
            minLines: 5,
            maxLines: 8,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: isEdit ? updateData : submitData,
            child: Text(isEdit ? 'Update' : 'Submit'),
          ),
        ],
      ),
    );
  }

  Future<void> updateData() async {
    // Get the data from form
    final todo = widget.todo;
    if (todo == null) {
      print('You can not call updated without todo data');
      return;
    }

    final id = todo['id'].toString();
    final title = titleController.text;
    final description = descriptionController.text;
    final body = {
      "title": title,
      "description": description,
    };

    // Submit data to the server
    final response = await http.patch(
      Uri.parse('https://todo-api.dimasoktafianto.my.id/api/todos/$id/update'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );

    // Show success or fail message based on status
    if (response.statusCode == 200) {
      showSuccessMessage('successfully updated.');
    } else {
      showErrorMessage('failed to update.');
    }
  }

  Future<void> submitData() async {
    // Get the data from form
    final title = titleController.text;
    final description = descriptionController.text;
    final body = {
      "title": title,
      "description": description,
    };

    // Submit data to the server
    final response = await http.post(
      Uri.parse('https://todo-api.dimasoktafianto.my.id/api/todos/store'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );

    // Show success or fail message based on status
    if (response.statusCode == 201) {
      titleController.text = '';
      descriptionController.text = '';

      showSuccessMessage('successfully created.');
    } else {
      showErrorMessage('failed to create.');
    }
  }

  void showSuccessMessage(String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.green,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void showErrorMessage(String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
