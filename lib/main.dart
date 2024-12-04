// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_list/screens/todo_list.dart';

void main() {
  runApp(const TodoList());
}

class TodoList extends StatelessWidget {
  const TodoList({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TodoList Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
//      home: const MyHomePage(title: 'Todo List'),
      home: const TodoListing(),
    );
  }
}

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});
//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   final fieldText = TextEditingController();
//   List<String> todoItems = [];
//   String buttonName = "Add";
//   int selectedIndex = -1;

//   @override
//   void initState() {
//     super.initState();
//     getValues();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         title: Text(widget.title),
//       ),
//       body: Container(
//         margin: const EdgeInsets.all(20.0),
//         child: (
//           Column(
//             children: <Widget>[
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: <Widget>[
//                   Expanded(
//                     child: TextField(
//                       controller: fieldText,
//                       decoration: const InputDecoration(
//                         hintText: 'Enter the item name'
//                       ),
//                     )
//                   ),
//                   ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.black
//                     ),
//                     onPressed: () {
//                       if (fieldText.text.isEmpty) {
//                         FocusManager.instance.primaryFocus?.unfocus();
//                         showSnackBar(context,'Please enter item name');
//                       } else {
//                         addEditItem(fieldText.text,buttonName == 'Add'? 'Add':'Edit');
//                         fieldText.clear();
//                       }
//                     },
//                     child:
//                       Text(buttonName, style: const TextStyle(color: Colors.white))
//                   )
//                 ]
//               ),
//               todoItems.isNotEmpty ?
//               Expanded(child: getListView()):
//                 const Padding(padding: EdgeInsets.only(top:20.0) ,
//                   child: Text('No data found')
//                 )
//             ]
//           )
//         )
//       )
//     );
//   }

//   void addEditItem(String item, String action) async {
//     final prefs = await SharedPreferences.getInstance();
//     setState(() {
//       if(action == 'Add') {
//         todoItems.add(item);
//       } else {
//         todoItems[selectedIndex] = item;
//       }
//       selectedIndex = -1;
//       buttonName = 'Add';
//     });
//     await prefs.setStringList('items', todoItems);
//   }

//   void deleteItem(BuildContext context) async{
//     final prefs = await SharedPreferences.getInstance();
//     setState(() {
//       todoItems.remove(todoItems[selectedIndex]);
//       selectedIndex = -1;
//     });
//     await prefs.setStringList('items', todoItems);
//     Navigator.pop(context);
//     FocusManager.instance.primaryFocus?.unfocus();
//     showSnackBar(context, 'Item deleted successfully');
//   }

//   void showSnackBar(BuildContext context, String message) {
//     var snackbar = SnackBar(content: Text(message));
//     ScaffoldMessenger.of(context).showSnackBar(snackbar);
//   }

//   Widget getListView() {
//     var listView = ListView.builder(
//       itemCount: todoItems.length,
//       itemBuilder: (context,index) {
//         return ListTile(
//           leading: const Icon(Icons.arrow_right_sharp),
//           title: Text(todoItems[index]),
//           trailing:  Wrap(
//             spacing: 12,
//             children: <Widget>[
//               IconButton(
//                 onPressed:() {
//                   setState(() {
//                     buttonName = "Edit";
//                     selectedIndex = index;
//                   });
//                   fieldText.text = todoItems[index];
//                 }, icon:  const Icon(Icons.edit)
//               ),
//               IconButton(
//                 onPressed: () {
//                   setState(() {
//                     selectedIndex = index;
//                   });
//                   showAlertDialog(context);
//                 },
//                 icon:  const Icon(Icons.delete)
//               )
//             ],
//           ),
//         );
//       }
//     );
//     return listView;
//   }

//   void showAlertDialog(BuildContext context) {
//     FocusManager.instance.primaryFocus?.unfocus();

//     showDialog(context: context, builder: (BuildContext alertContext) {
//       AlertDialog  alertDialog = AlertDialog(
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.of(alertContext).pop();
//             }, child: const Text('Cancel')
//           ),
//           TextButton(
//             onPressed: () {
//               deleteItem(alertContext);
//             }, child: const Text('Delete')
//           )
//         ],
//         title: const Text('Confirmation'),
//         content: const Text('Are you sure want to delete this item?')
//       );

//       return alertDialog;
//     });
//   }

//   Future<List<String>> getPreferenceItems() async {
//     final prefs = await SharedPreferences.getInstance();
//     final list =  prefs.getStringList("items");
//     if (list == null) {
//       return [];
//     } else {
//       return list;
//     }
//   }

//   void getValues () async {
//     List<String> list = await getPreferenceItems();
//     setState(() {
//       todoItems = list;
//     });
//   }

// }
