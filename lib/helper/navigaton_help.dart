import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitter_clone/models/posts.dart';
import 'package:twitter_clone/pages/blocked_users_page.dart';
import 'package:twitter_clone/pages/other_user_page.dart';
import 'package:twitter_clone/pages/post_page.dart';
import 'package:twitter_clone/pages/profile_page.dart';
import 'package:twitter_clone/services/databases/database_provider.dart';
import 'package:twitter_clone/helper/navigaton_help.dart';
import 'package:twitter_clone/services/databases/database_service.dart';

void getToProfilePage(BuildContext context, String uid) {
  final currentUser = FirebaseAuth.instance.currentUser!.uid;

  if (currentUser == uid) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => ProfilePage(uid: uid)));
  } else {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => OtherUserPage(uid: uid)));
  }
}

void getToPostPage(BuildContext context, Post post) {
  Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) => PostPage(post: post)));
}

void getToBlockedUsers(BuildContext context) {
  Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) => BlockedUsersPage()));
}
