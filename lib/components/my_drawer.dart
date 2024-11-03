import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:twitter_clone/components/my_list_tile.dart";
import "package:twitter_clone/pages/profile_page.dart";
import "package:twitter_clone/pages/search_page.dart";
import "package:twitter_clone/services/auth/functions.dart";
import "package:twitter_clone/pages/settings_page.dart";

/*
Drawer 

This is a menu drawer which is usually access on the left side of the app bar

----------------------------------------------------------------------------

Contains 5 menu options 
- Home
- Profile
- Search
- Logout
- Settings
*/

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 50.0),
              child: Icon(
                Icons.person,
                size: 72,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            Divider(indent: 5, color: Theme.of(context).colorScheme.secondary),
            // Main Column containing all the ListTiles and the Spacer
            Expanded(
              child: Column(
                children: [
                  MyDrawerListTile(
                    title: "H O M E",
                    icon: Icons.home,
                    ontap: () {
                      Navigator.pop(context);
                    },
                  ),
                  MyDrawerListTile(
                      title: "P R O F I L E",
                      icon: Icons.person,
                      ontap: () async {
                        String uid = _auth.currentUser!.uid;
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ProfilePage(uid: uid)));
                      }),
                  MyDrawerListTile(
                      title: "S E A R C H",
                      icon: Icons.search,
                      ontap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => SearchPage()));
                      }),
                  MyDrawerListTile(
                    title: "S E T T I N G S".toUpperCase(),
                    icon: Icons.settings,
                    ontap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => SettingsPage()));
                    },
                  ),
                  Spacer(
                    flex: 1,
                  ),
                  // ThiSpacs will take up the remaining space between the settings and logout
                  MyDrawerListTile(
                    title: "L O G O U T",
                    icon: Icons.logout,
                    ontap: () async {
                      try {
                        await logout();
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Logout Failed:$e")));
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
