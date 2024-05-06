import 'dart:convert';

import 'package:api_practicing/views/home_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../services/todo_service.dart';
import '../widgets/snackbar_widget.dart';

class AddNoteView extends StatefulWidget {
  final Map? todo;
  const AddNoteView({super.key, this.todo});

  @override
  State<AddNoteView> createState() => _AddNoteViewState();
}

class _AddNoteViewState extends State<AddNoteView> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool isEdit = false;

  @override
  void initState() {
    // TODO: implement initState
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
          title: Text(isEdit ? 'Edit Note' : 'Add Note'),
        ),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                hintText: 'Title',
              ),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                hintText: 'Description',
              ),
              keyboardType: TextInputType.multiline,
              minLines: 5,
              maxLines: 8,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: ElevatedButton(
                onPressed: isEdit ? updateData : submitData,
                child: Text(isEdit ? 'Edit' : 'Add'),
              ),
            )
          ],
        ));
  }

  Future<void> updateData() async {
    final todo = widget.todo;
    if (todo == null) {
      return showErrorMessage(context, message: 'Todo not found');
    }
    final id = todo['_id'];

    final isSuccess = await TodoService.updateTodo(id, body);

    if (isSuccess) {
      titleController.text = '';
      descriptionController.text = '';
      showSuccessMessage(context, message: 'Updated Successfully');
      Get.back();
    } else {
      showErrorMessage(context, message: 'Failed To Update');
    }
  }

  Future<void> submitData() async {
    //get data from form
    //submit data to server
    final isSuccess = await TodoService.addTodo(body);
    //show error message
    if (isSuccess) {
      titleController.text = '';
      descriptionController.text = '';
      showSuccessMessage(context, message: 'creation Success');
      Get.back();
    } else {
      showErrorMessage(context, message: 'creation Failed');
    }
    //show success or error message to user
  }
  Map get body {
    final title = titleController.text;
    final description = descriptionController.text;
    return {'title': title,
      'description': description, 'is_completed': false};
  }
}
