import 'package:flutter/material.dart';
import 'package:flutter_application/screens/add_page.dart';
import 'package:flutter_application/services/todo_service.dart';
import 'package:flutter_application/utils/snackbar_helper.dart';
import 'package:flutter_application/widget/todo_card.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  bool isLoading = true;
  List items = [];

  @override
  void initState() {
    super.initState();
    fetchTodo();
  }

  @override
  Widget build(BuildContext context) {
    // fetchTodo();
    return Scaffold(
      appBar: AppBar(
        // centerTitle: true,
        title: const Text('Todo List'),
        elevation: 80,
      ),
      body: Visibility(
          visible: isLoading,
          replacement: RefreshIndicator(
            onRefresh: fetchTodo,
            child: Visibility(
              visible: items.isNotEmpty,
              replacement:Center(child:Text(
                'No Todo Items',
                style: Theme.of(context).textTheme.displaySmall,
                )
              ),
              child: ListView.builder(
                itemCount: items.length,
                padding: const EdgeInsets.all(8),
                itemBuilder: (context, index) {
                  final item = items[index] as Map;
                  return TodoCard(index: index, item: item, deleteById: deleteById, navigateEdit: navigatetoEditPage);
                },
              ),
            ),
          ),
          child: const Center(child: CircularProgressIndicator())),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: navigatetoAddPage, label: const Text("Add TODO")),
    );
  }

Future<void> navigatetoAddPage() async {
  final route = MaterialPageRoute(
    builder: (context) => const AddTodoPage(),
  );
  final result = await Navigator.push(context, route);
  if (result == true) {
    fetchTodo();
  }
}

  Future<void> navigatetoEditPage(Map item) async {
    final route = MaterialPageRoute(
      builder: (context) => AddTodoPage(todo: item),
    );
    final result = Navigator.push(context, route);
    if (result == true) {
    fetchTodo();
  }
  }

  Future<void> deleteById(String id) async {
    final isSuccess = await TodoService.deleteById(id);
    if (isSuccess) {
      final filtered = items.where((element) => element['id'] != id).toList();
      setState(() {
        items = filtered;
        isLoading=true;
        fetchTodo();
      });
    } else {
      // ignore: use_build_context_synchronously
      showErrorMessage(context,message:'Deletion failed');
    }
  }

  Future<void> fetchTodo() async {
    final response =await TodoService.fetchTodo();
    if (response != null) {
      setState(() {
        items = response;
      });
    } else {
      // ignore: use_build_context_synchronously
      showErrorMessage(context,message :"Something Went Wrong");
    }
    setState(() {
      isLoading = false;
    });
  }

}
