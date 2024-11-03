import 'package:flutter/material.dart';

class MyFollowButton extends StatelessWidget {
  final void Function()? onpressed;
  bool isfollowing;
  MyFollowButton(
      {super.key, required this.onpressed, required this.isfollowing});
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 21, right: 21),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          color:
              isfollowing ? Theme.of(context).colorScheme.primary : Colors.blue,
          width: double.infinity,
          height: 80,
          child: MaterialButton(
            onPressed: onpressed,
            child: Text(isfollowing ? "Unfollow" : "Follow"),
          ),
        ),
      ),
    );
  }
}
