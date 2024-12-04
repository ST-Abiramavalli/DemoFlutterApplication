import 'dart:math';

import 'package:flutter/material.dart';
import 'package:todo_list/models/todo.dart';

class TodoController {
  List<Todo> toDos = [];
  List<Todo> searchResult = [];

  void addTodo(String value) {
    int randomNumber = Random().nextInt(100);
    toDos.add(Todo(item:value,id:randomNumber));
  }

  void updateTodo(int index, String value) {
    toDos[index].item = value;
  }

  void deleteTodo(int index) {
    toDos.removeAt(index);
  }

  void search(String searchTerm) {
    searchResult = [];
    for(int i = 0 ;i < toDos.length; i++) {
      Todo element = toDos[i];
      if(element.item.toLowerCase().startsWith(searchTerm.toLowerCase())) {
         searchResult.add(element);
      }
    }
  }
}
