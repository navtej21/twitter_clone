import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String name;
  final VoidCallback oncallback;

  const MyButton({super.key, required this.name, required this.oncallback});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: oncallback, // Trigger callback when tapped
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white, // Add background color
          borderRadius: BorderRadius.circular(20.0), // Curved borders
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 130, vertical: 30),
          child: Text(
            name,
            style: const TextStyle(
              fontSize: 20,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
