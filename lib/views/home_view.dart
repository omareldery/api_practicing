import 'package:api_practicing/services/todo_service.dart';
import 'package:flutter/material.dart';
import '../widgets/note_card.dart';
import '../widgets/snackbar_widget.dart';
import 'add_note_view.dart';
class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool isLoading = true;
  List items = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchTodoData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo App',
          style: TextStyle(
              letterSpacing: 2,
              fontWeight: FontWeight.w500
          ),),
        centerTitle: true,
        actions: [
          IconButton(icon: const Icon(Icons.settings), onPressed: () {},),
        ],
      ),
      body: Visibility(
        visible: isLoading,
        replacement: RefreshIndicator(
          onRefresh: fetchTodoData,
          child: Visibility(
            visible: items.isNotEmpty,
            replacement: Center(child: Text('No Items',
            style: Theme.of(context).textTheme.headlineMedium,)),
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index] as Map;
                final id = item['_id'] as String;
                return NoteCard(
                    index: index,
                    item: item,
                    navigateEdit: navigateToEditPage,
                    deleteById: deleteById);
              },
            ),
          ),
        ),
          child: const Center(child: CircularProgressIndicator(),),
      ),
      floatingActionButton: FloatingActionButton.extended(label: const Text('Add Note'),
        onPressed: navigateToAddPage, backgroundColor: Colors.blueGrey,),
    );
  }
  Future <void> navigateToEditPage(Map item) async{
    final route = MaterialPageRoute(
        builder: (context) => AddNoteView(todo: item,));
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchTodoData();
  }
  Future<void> navigateToAddPage() async{
    final route = MaterialPageRoute(
        builder: (context) => AddNoteView());
   await Navigator.push(context, route);
   setState(() {
     isLoading = true;
   });
    fetchTodoData();

  }
Future<void> deleteById(String id) async {
    final url = 'https://api.nstack.in/v1/todos/$id';
    final uri = Uri.parse(url);
    final isSuccess = await TodoService.deleteById(id);
    if (isSuccess){
      final filtered = items.where((element) => element['_id'] != id).toList();
      setState(() {
        items = filtered;
      });
    }
    else{
      showErrorMessage(context, message: 'deletion Failed');
    }
}
  Future<void> fetchTodoData() async {
    final response = await TodoService.fetchTodos();
     if (response != null) {
      setState(() {
        items = response;
      });
    }else{
      showErrorMessage(context, message: 'Something went wrong');
     }
    setState(() {
      isLoading = false;
    });
  }

}