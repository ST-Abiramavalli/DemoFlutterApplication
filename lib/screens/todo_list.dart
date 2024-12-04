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
    getValues(searchTerm);
  }

  void _addEditTodo(BuildContext context,String action) async {
    if (fieldText.text.isNotEmpty) {
      FocusManager.instance.primaryFocus?.unfocus();
      setState(() {
        if(buttonName == 'Add') {
          todoController.addTodo(fieldText.text);
          addPreferenceItems();
        } else {
          updatePreferenceItems('edit',fieldText.text);
          buttonName = 'Add';
        }
      });
      fieldText.clear();
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
      selectedIndex = index;
      updatePreferenceItems('delete','');
    });
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
              SearchBar(controller: searchController,
               hintText: 'Search',
                onChanged: (value) {
                setState(() {
                  searchTerm = value;
                });
                 getValues(value);
                },
                trailing: [searchController.text.isNotEmpty? IconButton(onPressed: () {
                  searchController.clear();
                  setState(() {
                    searchTerm = "";
                  });
                  getValues(searchTerm);
                }, icon: const Icon(Icons.clear)):IconButton(onPressed: () {

                }, icon: const Icon(Icons.search))]
              ),
              const SizedBox(height: 16.0),
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

  void updatePreferenceItems(String action,String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Todo> list = await getPreferenceItems();
    int originalIndex = -1;
    debugPrint("selectedIndex:$selectedIndex");
    for(int i=0; i < list.length; i++) {
      if(todoController.toDos[selectedIndex].id == list[i].id)
      {
        originalIndex = i;
      }
    }
    debugPrint("originalIndex:$originalIndex");
    if(originalIndex != -1) {
      if(action == 'edit') {
        list[originalIndex].item = value;
        todoController.updateTodo(selectedIndex, value);
      } else {
        list.removeAt(originalIndex);
        todoController.deleteTodo(selectedIndex);
      }
    }
    List<String> jsonStringList = list.map((item) => jsonEncode(item.toJson())).toList();
    await prefs.setStringList('items', jsonStringList);
    setState(() {
      selectedIndex =-1;
    });
  }

  void addPreferenceItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> jsonStringList = todoController.toDos.map((item) => jsonEncode(item.toJson())).toList();
    await prefs.setStringList('items', jsonStringList);
  }

  void getValues (String searchTerm) async {
    List<Todo> list = await getPreferenceItems();
    setState(() {
      if(searchTerm == "") {
        todoController.toDos = list;
      } else {
        todoController.toDos = list.where((element) => element.item.toLowerCase().startsWith(searchTerm.toLowerCase())).toList();
      }
    });
  }
}
