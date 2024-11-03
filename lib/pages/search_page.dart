import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitter_clone/pages/other_user_page.dart';
import 'package:twitter_clone/pages/profile_page.dart';
import 'package:twitter_clone/services/databases/database_provider.dart';
import 'package:twitter_clone/models/user.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController controller = TextEditingController();
  late DatabaseProvider listeningprovider;
  List<UserProfile> filteredusers = [];

  @override
  void dispose() {
    controller.removeListener(onsearchchanged);
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    controller.addListener(onsearchchanged);
  }

  void onsearchchanged() {
    setState(() {
      filteredusers = listeningprovider.allusers
          .where((user) =>
              user.name.toLowerCase().contains(controller.text.toLowerCase()))
          .toList();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    listeningprovider = Provider.of<DatabaseProvider>(context);
    if (listeningprovider.allusers.isEmpty) {
      listeningprovider.getallusers().then((_) {
        onsearchchanged(); // Update filter after loading users
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: 'Search...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.black),
          ),
          style: TextStyle(color: Colors.black),
          cursorColor: Colors.black,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Optionally trigger search functionality here
            },
          ),
        ],
      ),
      body: Center(
        child: ListView.builder(
          itemCount: filteredusers.length,
          itemBuilder: (context, index) {
            final user = filteredusers[index];
            return Padding(
              padding: EdgeInsets.all(20),
              child: ListTile(
                leading: Icon(Icons.person),
                title: Text(user.name), // Display user name
                trailing: IconButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) {
                        if (user.id == FirebaseAuth.instance.currentUser!.uid) {
                          return ProfilePage(uid: user.id);
                        } else {
                          return OtherUserPage(uid: user.id);
                        }
                      }, // Navigate to a user profile page
                    ));
                  },
                  icon: Icon(Icons.arrow_forward),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
