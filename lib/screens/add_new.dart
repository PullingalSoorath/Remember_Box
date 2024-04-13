// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:remember_box/api/api_key.dart';

import '../application/view_snackbar.dart';

class AddNew extends StatefulWidget {
  const AddNew({
    super.key,
    this.todo,
  });

  final Map? todo;

  @override
  State<AddNew> createState() => _AddNewState();
}

class _AddNewState extends State<AddNew> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool isEdithing = false;
  @override
  void initState() {
    super.initState();
    if (widget.todo != null) {
      titleController.text = widget.todo!['title'];
      descriptionController.text = widget.todo!['description'];
      isEdithing = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdithing ? 'Edit Data' : 'Add New Data'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Title',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  maxLines: 10,
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Description',
                    alignLabelWithHint: true,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.height * 0.01,
              vertical: MediaQuery.of(context).size.height * 0.01,
            ),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ButtonStyle(
                  shape: MaterialStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        10,
                      ),
                    ),
                  ),
                ),
                onPressed: () {
                  isEdithing ? editedData() : submitData();
                },
                child: Text(
                  isEdithing ? "Update" : "Submit",
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> editedData() async {
    try {
      final title = titleController.text;
      final description = descriptionController.text;
      final todo = widget.todo;
      final id = todo?['_id'];
      final body = {
        "title": title,
        "description": description,
        "is_completed": false,
      };

      final url = 'https://api.nstack.in/v1/todos/$id';
      final uri = Uri.parse(url);
      final response = await http.put(
        uri,
        body: jsonEncode(body),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        ViewSnackbar().showSuccessMessage(context);
        Navigator.pop(context);
        // Success! Handle successful response (e.g., show a confirmation message)
      } else {
        // Error! Handle error response (e.g., show an error message)
        ViewSnackbar().showErrorMessage(context);
      }
    } catch (e) {
      ViewSnackbar().showErrorMessage(
        context,
      );
    }
  }

  Future<void> submitData() async {
    try {
      final title = titleController.text;
      final description = descriptionController.text;

      final body = {
        "title": title, // Corrected typo
        "description": description,
        "is_completed": false,
      };

      const url = submitApi;
      final uri = Uri.parse(url);

      final response = await http.post(
        uri,
        body: jsonEncode(body),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 201) {
        ViewSnackbar().showSuccessMessage(context);
        titleController.text = '';
        descriptionController.text = '';
        Navigator.pop(context);
        // Success! Handle successful response (e.g., show a confirmation message)
        log(response.body);
        log('Successfully submitted data ${response.statusCode}');
      } else {
        ViewSnackbar().showErrorMessage(context);

        // Handle error! (e.g., show an error message to the user)
        log('Error submitting data: ${response.statusCode}');
      }
    } catch (error) {
      // Handle any other unexpected errors during network request
      log('Error submitting data: $error');
    }
  }
}
