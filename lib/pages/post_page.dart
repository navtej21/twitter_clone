import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitter_clone/components/my_comment_tile.dart';
import 'package:twitter_clone/components/my_post_tile.dart';
import 'package:twitter_clone/helper/navigaton_help.dart';
import 'package:twitter_clone/models/comment.dart';
import 'package:twitter_clone/models/posts.dart';
import 'package:twitter_clone/pages/home_page.dart';
import 'package:twitter_clone/services/databases/database_provider.dart';

class PostPage extends StatefulWidget {
  final Post post;
  const PostPage({super.key, required this.post});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  late final DatabaseProvider listeningProvider =
      Provider.of<DatabaseProvider>(context, listen: true);
  late final DatabaseProvider databaseProvider =
      Provider.of<DatabaseProvider>(context, listen: false);

  @override
  void initState() {
    super.initState();
    databaseProvider.loadcomments(widget.post.id);
  }

  /// Function to listen for real-time updates on post deletion

  /// Function to show confirmation dialog before deletion
  Future<void> ShowDeleteConfirmationDialog() async {
    return showDialog(
      context: context,
      barrierDismissible: false, // User must confirm the action
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to delete this post?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () async {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => HomePage()));
                await listeningProvider
                    .deletepost(widget.post.id); // Proceed with deletion
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Comment> allcomments = listeningProvider.getComments(widget.post.id);

    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            MyPostTile(
              postid: widget.post.id,
              uid: widget.post.uid,
              name: widget.post.name,
              username: widget.post.username,
              message: widget.post.message,
              onUserTap: () {
                getToProfilePage(context, widget.post.uid);
              },
              onPostTap: () {},
            ),
            Expanded(
              child: allcomments.isEmpty
                  ? Center(
                      child: Text("No Comments yet"),
                    )
                  : ListView.builder(
                      itemCount: allcomments.length,
                      itemBuilder: (context, index) {
                        try {
                          return MyCommentTile(
                            comment: allcomments[index].message,
                            name: allcomments[index].name,
                            username: allcomments[index].username,
                          );
                        } catch (e) {
                          print(e);
                          return ListTile(
                            title: Text('Error loading comment'),
                          );
                        }
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
