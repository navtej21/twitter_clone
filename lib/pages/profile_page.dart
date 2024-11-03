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

class ProfilePage extends StatefulWidget {
  final String uid;
  const ProfilePage({super.key, required this.uid});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserProfile? user;
  late String currentUserId;
  late String currentUserBio = '';
  bool _isLoading = true;
  final TextEditingController _controller = TextEditingController();
  late DatabaseProvider databaseProvider;

  @override
  void initState() {
    super.initState();
    currentUserId = FirebaseAuth.instance.currentUser!.uid;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    databaseProvider = Provider.of<DatabaseProvider>(context, listen: true);

    // Load user-related data
    loadUser();
    loadCurrentUserBio();
    databaseProvider.loaduserFollowers(widget.uid);
    databaseProvider.loaduserFollowing(widget.uid);
    databaseProvider.getIndivualPosts(widget.uid);
  }

  Future<void> loadUser() async {
    try {
      final fetchedUser = await databaseProvider.getuserinfo(widget.uid);
      if (mounted) {
        setState(() {
          user = fetchedUser;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading user: $e');
    }
  }

  Future<void> loadCurrentUserBio() async {
    try {
      final document = await FirebaseFirestore.instance
          .collection("users")
          .doc(currentUserId)
          .get();
      UserProfile userProfile = UserProfile.fromDocument(document);
      if (mounted) {
        setState(() {
          currentUserBio = userProfile.bio;
          _controller.text = currentUserBio; // Sync with text controller
        });
      }
    } catch (e) {
      print("Error loading bio: $e");
    }
  }

  Future<void> updateBio() async {
    try {
      await databaseProvider.saveuserbio(_controller.text, currentUserId);
      await loadCurrentUserBio();
    } catch (e) {
      print('Error updating bio: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(user?.name.toUpperCase() ?? "Loading...",
            style: const TextStyle(fontSize: 18)),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
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
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.person,
                          size: 40,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              FollowersFollowingPage(uid: currentUserId)));
                    },
                    child: MyProfileStats(
                        postcount:
                            databaseProvider.indivualpost.length.toString(),
                        follwers: databaseProvider
                            .getFollowerCount(widget.uid)
                            .toString(),
                        following: databaseProvider
                            .getFollowingCount(widget.uid)
                            .toString()),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Bio", style: TextStyle(fontSize: 16)),
                            IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text("Edit Bio"),
                                      content: TextField(
                                        controller: _controller,
                                        decoration: const InputDecoration(
                                            border: OutlineInputBorder()),
                                        maxLength: 100,
                                        maxLines: 3,
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text("Cancel"),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            await updateBio();
                                            Navigator.pop(context);
                                          },
                                          child: const Text("Submit"),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              icon: const Icon(Icons.settings),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        TextField(
                          controller: _controller,
                          readOnly: true,
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            hintText: currentUserBio,
                            border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Posts",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  databaseProvider.indivualpost.isEmpty
                      ? const Center(child: Text("No Posts"))
                      : ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
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
