import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitter_clone/models/user.dart';
import 'package:twitter_clone/pages/other_user_page.dart';
import 'package:twitter_clone/pages/profile_page.dart';
import 'package:twitter_clone/services/databases/database_provider.dart';

class FollowersFollowingPage extends StatefulWidget {
  const FollowersFollowingPage({super.key, required this.uid});
  final String uid;

  _FollowersFollowingPage createState() => _FollowersFollowingPage();
}

class _FollowersFollowingPage extends State<FollowersFollowingPage> {
  late DatabaseProvider listeningprovider;
  late DatabaseProvider databaseprovider;
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    listeningprovider = Provider.of<DatabaseProvider>(context, listen: true);
    databaseprovider = Provider.of<DatabaseProvider>(context, listen: false);
    listeningprovider.loaduserFollowerProfiles(widget.uid);
    listeningprovider.loaduserFollowingProfiles(widget.uid);
  }

  @override
  Widget build(BuildContext context) {
    final followers = listeningprovider.getListoffFollowersProfile(widget.uid);
    final following = listeningprovider.getListOffFollowingProfile(widget.uid);
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: TabBarView(children: [
            display(followers, "No Followers"),
            display(following, "No Following")
          ]),
          appBar: AppBar(
            bottom: TabBar(
              tabs: [Text("Followers"), Text("Following")],
            ),
          ),
        ));
  }
}

Widget display(List<UserProfile> userlist, String emptymessage) {
  return userlist.isEmpty
      ? Center(
          child: Text(emptymessage),
        )
      : ListView.builder(
          itemCount: userlist.length,
          itemBuilder: (context, index) {
            final users = userlist[index];
            return ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Padding(
                padding: EdgeInsets.all(10),
                child: ListTile(
                  leading: Icon(Icons.person),
                  tileColor: Theme.of(context).colorScheme.primary,
                  title: Text(users.name),
                  trailing: IconButton(
                      onPressed: () {
                        users.id == FirebaseAuth.instance.currentUser!.uid
                            ? Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    ProfilePage(uid: users.id)))
                            : Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    OtherUserPage(uid: users.id)));
                      },
                      icon: Icon(Icons.arrow_forward)),
                ),
              ),
            );
          });
}
