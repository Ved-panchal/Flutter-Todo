
import 'package:flutter/material.dart';
import 'package:flutter_application/services/todo_service.dart';
import 'package:flutter_application/utils/snackbar_helper.dart';


class AddTodoPage extends StatefulWidget {
  final Map? todo;
  const AddTodoPage({
    super.key,
    this.todo,
  });

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
        title: Text(
          isEdit ? "Edit Todo" : "Add Todo",
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(hintText: "Title"),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: descriptionController,
            decoration: const InputDecoration(hintText: "Description"),
            keyboardType: TextInputType.multiline,
            minLines: 5,
            maxLines: 8,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
              onPressed: isEdit ? updateData : submitData,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  isEdit ? "Update" : "Submit",
                ),
              ))
        ],
      ),
    );
  }

  Future<void> updateData() async {
    final todo = widget.todo;
    if (todo == null) {
      return ;
    }
    final id = todo["_id"];

    //Submit Updated data to server
    final isSuccess = await TodoService.updateTodo(id, body);

    // Show success or failure message based on status
    if (isSuccess) {
      // ignore: use_build_context_synchronously
      showSuccessMessage(context,message:'Updation Success');
      Navigator.pop(context,true);
    } else {
      // ignore: use_build_context_synchronously
      showErrorMessage(context,message:'Updaion Failed');
      Navigator.pop(context,false);
    }
  }

Future<void> submitData() async {
  //Submit the data to server
  final isSuccess = await TodoService.createTodo(body);
  // Show success or failure message based on status
  if (isSuccess) {
    titleController.text = "";
    descriptionController.text = "";
    // ignore: use_build_context_synchronously
    showSuccessMessage(context, message: 'Creation Success');
    // Return true if data submission is successful
    Navigator.pop(context,true);
  } else {
    // ignore: use_build_context_synchronously
    showErrorMessage(context, message: 'Creation Failed');
     // Return false if data submission fails
    Navigator.pop(context,false);
  }
}

  Map get body {
    final title = titleController.text;
    final description = descriptionController.text;
    return {
      "title": title,
      "description": description,
      "is_completed": false,
    };
  }
}
