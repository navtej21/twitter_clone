import "package:flutter/material.dart";

class MyDrawerListTile extends StatelessWidget {
  const MyDrawerListTile(
      {super.key,
      required this.title,
      required this.icon,
      required this.ontap});
  final String title;
  final IconData icon;
  final VoidCallback ontap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
      ),
      leading: Icon(
        icon,
        color: Theme.of(context).colorScheme.primary,
      ),
      onTap: () => ontap(),
    );
  }
}
