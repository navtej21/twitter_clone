import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitter_clone/components/follower_comments_count.dart';
import 'package:twitter_clone/components/my_follow_button.dart';
import 'package:twitter_clone/components/my_post_tile.dart';
import 'package:twitter_clone/helper/navigaton_help.dart';
import 'package:twitter_clone/models/user.dart';
import 'package:twitter_clone/pages/followers_following_page.dart';
import 'package:twitter_clone/services/databases/database_provider.dart';

class OtherUserPage extends StatefulWidget {
  final String uid;
  const OtherUserPage({super.key, required this.uid});

  @override
  State<OtherUserPage> createState() => _OtherUserPageState();
}

class _OtherUserPageState extends State<OtherUserPage> {
  UserProfile? user;
  late String otherUserBio = '';
  bool _isLoading = true;
  bool _isfollowing = false;
  late final DatabaseProvider databaseProvider =
      Provider.of<DatabaseProvider>(context, listen: false);

  @override
  void initState() {
    super.initState();
    loadUser();
    loadUserBio();
    databaseProvider.getIndivualPosts(widget.uid);
    databaseProvider.loaduserFollowers(widget.uid);
    databaseProvider.loaduserFollowing(widget.uid);
  }

  Future<void> loadUser() async {
    try {
      user = await databaseProvider.getuserinfo(widget.uid);
      _isfollowing = await databaseProvider.isfollowing(widget.uid);
      print(_isfollowing);
      print(user?.name);
    } catch (e) {
      print('Error loading user: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> loadUserBio() async {
    try {
      DocumentSnapshot document = await FirebaseFirestore.instance
          .collection("users")
          .doc(widget.uid)
          .get();
      UserProfile? userProfile = UserProfile.fromDocument(document);
      setState(() {
        otherUserBio = userProfile?.bio ?? '';
      });
      print(otherUserBio);
    } catch (e) {
      print(e);
    }
  }

  void togglefollow() {
    if (_isfollowing) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Unfollow"),
            content: Text("Are you sure you want to unfollow?"),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Cancel")),
              TextButton(
                onPressed: () {
                  databaseProvider.unfollowertargetuser(widget.uid);
                  Navigator.of(context).pop();
                },
                child: Text("Unfollow"),
              )
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Follow"),
            content: Text("Are you sure you want to Follow?"),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Cancel")),
              TextButton(
                onPressed: () {
                  databaseProvider.followuser(widget.uid);
                  Navigator.of(context).pop();
                },
                child: Text("Follow"),
              )
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final databaseProvider =
        Provider.of<DatabaseProvider>(context, listen: true);
    _isfollowing = databaseProvider.isfollowing(widget.uid);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(user?.name.toUpperCase() ?? "Loading...",
            style: TextStyle(fontSize: 18)),
        centerTitle: true,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  Center(
                    child: Text(
                      '@${user?.username ?? "Unknown"}',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white,
                      ),
                      child: Center(
                        child: Icon(
                          Icons.person,
                          size: 40,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  GestureDetector(
                    onTap: () {
                      print("tapped");
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              FollowersFollowingPage(uid: widget.uid)));
                    },
                    child: MyProfileStats(
                        following: databaseProvider
                            .getFollowingCount(widget.uid)
                            .toString(),
                        follwers: databaseProvider
                            .getFollowerCount(widget.uid)
                            .toString(),
                        postcount:
                            databaseProvider.indivualpost.length.toString()),
                  ),
                  MyFollowButton(
                      onpressed: () {
                        togglefollow();
                      },
                      isfollowing: databaseProvider.isfollowing(widget.uid)),
                  SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Bio",
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                        SizedBox(height: 15),
                        TextField(
                          readOnly:
                              true, // Other user's bio should not be editable
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            hintText: otherUserBio,
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                          ),
                        ),
                        SizedBox(height: 15),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Posts",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  // Posts Section
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: databaseProvider.indivualpost.length,
                    itemBuilder: (context, index) {
                      final post = databaseProvider.indivualpost[index];
                      return MyPostTile(
                        postid: post.id,
                        uid: post.uid,
                        onPostTap: () {
                          getToPostPage(context, post);
                        },
                        onUserTap: () {},
                        name: post.name,
                        username: post.username,
                        message: post.message,
                      );
                    },
                  ),
                ],
              ),
            ),
    );
  }
}
