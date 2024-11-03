import 'package:flutter/material.dart';
import 'package:twitter_clone/pages/followers_following_page.dart';

class MyProfileStats extends StatelessWidget {
  MyProfileStats(
      {super.key,
      required this.postcount,
      required this.follwers,
      required this.following});

  final String postcount;
  final String follwers;
  final String following;

  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 100,
          child: Column(children: [Text(postcount), Text("Posts")]),
        ),
        SizedBox(
            width: 100,
            child: Column(children: [Text(follwers), Text("Followers")])),
        SizedBox(
          width: 100,
          child: Column(
            children: [Text(following), Text("Following")],
          ),
        )
      ],
    );
  }
}
