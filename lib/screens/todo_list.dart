import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_list/controllers/todo_controller.dart';
import 'package:todo_list/helpers/helper.dart';
import 'package:todo_list/models/todo.dart';
import 'package:todo_list/views/todo_list_view.dart';

class TodoListing extends StatefulWidget{
  const TodoListing({super.key});

  @override
  State<TodoListing> createState() => TodoListState();
}

 class TodoListState extends State<TodoListing> {

  final fieldText = TextEditingController();
  final searchController =  TextEditingController();
  final todoController = TodoController();
  String buttonName = 'Add';
  String searchTerm = "";
  int selectedIndex = -1;

  @override
  void initState() {
    super.initState();
    getValues();
  }

  void _addEditTodo(BuildContext context,String action) async {
    if (fieldText.text.isNotEmpty) {
      FocusManager.instance.primaryFocus?.unfocus();
      setState(() {
        if(buttonName == 'Add') {
         todoController.addTodo(fieldText.text);
        } else {
          todoController.updateTodo(selectedIndex, fieldText.text);
          buttonName = 'Add';
          selectedIndex =-1;
        }
      });
      fieldText.clear();
      updatePreferenceItems();
    } else {
      Helper.showSnackBar(context, "Please enter the name");
    }
  }

  void _updateTodo(int index) {
    fieldText.text = todoController.toDos[index].item;
    setState(() {
      buttonName = 'Edit';
      selectedIndex = index;
    });
  }

  void _deleteTodo(int index) {
    setState(() {
      todoController.deleteTodo(index);
    });
    updatePreferenceItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Todo List"),
      ),
      body: Container(
        margin: const EdgeInsets.all(20.0),
        child: (
          Column(
            children: <Widget>[
              // SearchBar(controller: searchController,
              //  hintText: 'Search',
              //   onChanged: (value) {
              //    searchItems(value);
              //   },
              //   trailing: [searchController.text.isNotEmpty? IconButton(onPressed: () {
              //     searchController.clear();
              //     setState(() {
              //       searchTerm = "";
              //     });
              //   }, icon: const Icon(Icons.clear)):IconButton(onPressed: () {

              //   }, icon: const Icon(Icons.search))]
              // ),
              // const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: fieldText,
                      decoration: const InputDecoration(
                        hintText: 'Enter the item name'
                      ),
                    )
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black
                    ),
                    onPressed: () {
                      _addEditTodo(context,buttonName);
                    },
                    child:
                      Text(buttonName, style: const TextStyle(color: Colors.white))
                  )
                ]
              ),
              (todoController.toDos.isNotEmpty)?
                Expanded(child:
                  TodoListView(
                    todos: todoController.toDos, updateListItem: _updateTodo, deleteListItem: _deleteTodo, searchResult: todoController.searchResult,searchTerm:searchTerm
                  )
                ):
                const Padding(padding: EdgeInsets.only(top:30.0) ,
                  child: Text('No data found')
                )
            ]
          )
        )
      )
    );
  }

  Future<List<Todo>> getPreferenceItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? jsonStringList = prefs.getStringList('items');

    if (jsonStringList != null) {
      return jsonStringList.map((jsonString) => Todo.fromJson(jsonDecode(jsonString))).toList();
    }

    return [];
  }

  void updatePreferenceItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> jsonStringList = todoController.toDos.map((item) => jsonEncode(item.toJson())).toList();
    await prefs.setStringList('items', jsonStringList);
  }

  void getValues () async {
    List<Todo> list = await getPreferenceItems();
    setState(() {
      todoController.toDos = list;
    });
  }

  void searchItems(String value) {
    setState(() {
      searchTerm = value;
      if(searchTerm == "") {
        getValues();
      } else {
        todoController.search(value);
      }
    });
  }
}
