import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitter_clone/models/posts.dart';
import 'package:twitter_clone/services/databases/database_provider.dart';

class MyAlertBox extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  MyAlertBox({super.key, required this.title, required this.controller});
  Widget build(BuildContext context) {
    late final provider = Provider.of<DatabaseProvider>(context, listen: false);
    return AlertDialog(
      title: Text(this.title),
      content: TextField(
        controller: controller,
        decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
        maxLength: 140,
        maxLines: 5,
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context, null),
            child: Text('Cancel')),
        TextButton(
            onPressed: () async {
              await provider.savepost(controller.text);
              controller.clear();
            },
            child: Text('Save')),
      ],
    );
  }
}
