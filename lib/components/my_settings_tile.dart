import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitter_clone/themes/theme_provider.dart';

class MySettings extends StatelessWidget {
  const MySettings({super.key, required this.title, required this.action});
  final String title;
  final Widget action;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.secondary),
      margin: EdgeInsets.symmetric(horizontal: 15),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        trailing: action,
      ),
    );
  }
}
