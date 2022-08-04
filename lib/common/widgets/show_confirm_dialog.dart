import 'package:flutter/material.dart';

void showConfirmDialog(
  BuildContext context,
  String content,
  Function confirmCallback,
) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          // title: Text("info"),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                confirmCallback();
                Navigator.of(context).pop();
              },
              child: Text("Ok"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
          ],
        );
      });
}
