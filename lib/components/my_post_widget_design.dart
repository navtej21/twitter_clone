import 'package:flutter/material.dart';
import 'package:twitter_clone/components/my_post_tile.dart';
import 'package:twitter_clone/helper/navigaton_help.dart';
import 'package:twitter_clone/models/posts.dart';

Widget buildPostList(List<Post> posts) {
  return posts.isEmpty
      ? Center(child: Text("Nothing Here"))
      : ListView.builder(
          itemCount: posts.length,
          itemBuilder: (context, index) {
            return MyPostTile(
                postid: posts[index].id,
                uid: posts[index].uid,
                onPostTap: () {
                  getToPostPage(context, posts[index]);
                },
                onUserTap: () {
                  getToProfilePage(context, posts[index].uid);
                },
                name: posts[index].name,
                username: posts[index].username,
                message: posts[index].message);
          });
}
