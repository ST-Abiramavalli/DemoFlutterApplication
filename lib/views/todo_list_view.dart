import 'package:flutter/material.dart';
import 'package:todo_list/helpers/helper.dart';
import 'package:todo_list/models/todo.dart';

class TodoListView extends StatelessWidget{
  const TodoListView({super.key, required this.todos, required this.updateListItem, required this.deleteListItem, required this.searchResult, required this.searchTerm});

  final List<Todo> todos;
  final List<Todo> searchResult;
  final Function (int) updateListItem;
  final Function (int) deleteListItem;
  final String searchTerm;

  @override
  Widget build(BuildContext context) {
     return Scaffold(
      body: getListView()
    );
  }

  Widget getListView() {
    var listView = ListView.builder(
      itemCount: todos.length ,
      itemBuilder: (context,index) {
        return ListTile(
          leading: const Icon(Icons.arrow_right_sharp),
          title: Text(todos[index].item),
          trailing:  Wrap(
            spacing: 12,
            children: <Widget>[
              IconButton(
                onPressed:() {
                  updateListItem(index);
                }, icon:  const Icon(Icons.edit)
              ),
              IconButton(
                onPressed: () async{
                  FocusManager.instance.primaryFocus?.unfocus();
                  String? isDelete = await Helper.showAlertDialog(context);
                  if (isDelete == 'delete') {
                    deleteListItem(index);
                    FocusManager.instance.primaryFocus?.unfocus();
                    Helper.showSnackBar(context, 'Item deleted successfully');
                  }
                },
                icon:  const Icon(Icons.delete)
              )
            ],
          ),
        );
      }
    );

    return listView;
  }
}
