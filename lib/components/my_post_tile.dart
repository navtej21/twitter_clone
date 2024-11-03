import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitter_clone/components/my_comment_box.dart';
import 'package:twitter_clone/pages/home_page.dart';
import 'package:twitter_clone/services/databases/database_provider.dart';

class MyPostTile extends StatefulWidget {
  final String name;
  final String username;
  final String message;
  final VoidCallback onUserTap;
  final VoidCallback onPostTap;
  final String uid;
  final String postid;

  MyPostTile({
    super.key,
    this.postid = "",
    required this.uid,
    required this.name,
    required this.username,
    required this.message,
    required this.onUserTap,
    required this.onPostTap,
  });

  @override
  State<MyPostTile> createState() => _MyPostTileState();
}

class _MyPostTileState extends State<MyPostTile> {
  late final String currentuserid;
  late final listenprovider;

  final TextEditingController _commentcontroller = TextEditingController();

  @override
  void initState() {
    super.initState();
    currentuserid = FirebaseAuth.instance.currentUser!.uid;
  }

  void _showOptions(DatabaseProvider provider) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              if (currentuserid == widget.uid)
                ListTile(
                  leading: Icon(Icons.delete),
                  title: Text("Delete Post"),
                  onTap: () {
                    Navigator.pop(context); // Close the bottom sheet
                    _showDeleteConfirmation(
                        provider); // Show the confirmation dialog
                  },
                )
              else ...[
                ListTile(
                  leading: Icon(Icons.flag),
                  title: Text("Report"),
                  onTap: () {
                    Navigator.pop(context);
                    reportUserConfirmation(provider);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.block),
                  title: Text("Block User"),
                  onTap: () {
                    Navigator.pop(context);
                    blockUserConfirmation(provider);
                  },
                ),
              ],
              ListTile(
                leading: Icon(Icons.cancel),
                title: Text("Cancel"),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void reportUserConfirmation(DatabaseProvider provider) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Report Message"),
          content: Text("Are you sure you want to report this message?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
            TextButton(
                onPressed: () async {
                  provider.reportUser(widget.uid, widget.postid);
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Message Reported")));
                },
                child: Text("Report"))
          ],
        );
      },
    );
  }

  void blockUserConfirmation(DatabaseProvider provider) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Block User"),
          content: Text("Are you sure you want to block this user?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
            TextButton(
                onPressed: () async {
                  provider.blockUser(widget.uid);
                  print(widget.uid);
                  Navigator.of(context).pop();
                  provider.getallposts();
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text("User Blocked")));
                },
                child: Text("Block"))
          ],
        );
      },
    );
  }

  Future<void> _showDeleteConfirmation(DatabaseProvider provider) async {
    return showDialog<void>(
      context: context,
      barrierDismissible:
          false, // Prevent dismissing the dialog by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Post'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'Are you sure you want to delete this post?',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  'This action cannot be undone, and your post will be permanently removed.',
                  style: TextStyle(color: Colors.redAccent),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel', style: TextStyle(color: Colors.grey)),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text('Delete', style: TextStyle(color: Colors.red)),
              onPressed: () async {
                Navigator.pop(context);
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => HomePage()));
                await provider.deletepost(widget.postid); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DatabaseProvider>(
        builder: (context, listenprovider, child) {
      // Check if the post is liked by the current user

      return Padding(
        padding: EdgeInsets.all(10),
        child: GestureDetector(
          onTap: widget.onPostTap, // Triggering the onPostTap callback
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: widget
                            .onUserTap, // Triggering the onUserTap callback
                        child: Icon(Icons.person),
                      ),
                      SizedBox(width: 10),
                      Text(
                        widget.name,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        '@${widget.username}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: () => _showOptions(listenprovider),
                        child: Icon(Icons.more_horiz),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(widget.message),
                    ),
                  ),
                  SizedBox(height: 15),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          listenprovider.toggleLike(widget.postid);
                        },
                        child: Icon(
                          listenprovider.likedposts.contains(widget.postid)
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color:
                              listenprovider.likedposts.contains(widget.postid)
                                  ? Colors.red
                                  : Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      Text(
                        listenprovider.getLikeCount(widget.postid).toString() ==
                                "0"
                            ? ""
                            : listenprovider
                                .getLikeCount(widget.postid)
                                .toString(),
                      ),
                      SizedBox(width: 20),
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return MyCommentBox(
                                title: "Add Your Comment!",
                                controller: _commentcontroller,
                                postid: widget.postid,
                              );
                            },
                          );
                        },
                        child: Icon(
                          Icons.comment,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      //comment count
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
