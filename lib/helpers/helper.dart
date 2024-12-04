import 'package:flutter/material.dart';

class Helper {

  static  void showSnackBar(BuildContext context, String message) {
    var snackbar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  static Future<String?> showAlertDialog(BuildContext context) {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmation'),
          content: const Text('Are you sure want to delete this item?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context, 'cancel'); // Return 'Option 1'
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, 'delete'); // Return 'Option 2'
              },
              child: const Text('Delete'),
            )
          ],
        );
      },
    );

  }
}
