import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitter_clone/components/my_drawer.dart';
import 'package:twitter_clone/components/my_settings_tile.dart';
import 'package:twitter_clone/helper/navigaton_help.dart';
import 'package:twitter_clone/pages/blocked_users_page.dart';
import 'package:twitter_clone/pages/register_page.dart';
import 'package:twitter_clone/services/auth/firebase_auth.dart';
import 'package:twitter_clone/services/databases/database_service.dart';
import 'package:twitter_clone/themes/theme_provider.dart';

/*
- Dark Mode 
- Blocked Users
- Account Settings
*/
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          MySettings(
              title: "Dark Mode",
              action: CupertinoSwitch(
                  value: Provider.of<ThemeProvider>(context, listen: false)
                      .isDarkMode,
                  onChanged: (value) {
                    Provider.of<ThemeProvider>(context, listen: false)
                        .toggleTheme();
                  })),
          SizedBox(
            height: 20,
          ),
          MySettings(
              title: "Blocked Users",
              action: IconButton(
                  onPressed: () {
                    getToBlockedUsers(context);
                  },
                  icon: Icon(Icons.arrow_forward))),
          SizedBox(
            height: 20,
          ),
          MySettings(
              title: "Delete Account",
              action: IconButton(
                  onPressed: () {
                    AuthService().deleteAccount();
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => RegisterPage(
                              ontap: () {},
                            )));
                  },
                  icon: Icon(
                    Icons.delete,
                    color: Colors.red,
                  )))
        ],
      ),
      appBar: AppBar(
        foregroundColor: Theme.of(context).colorScheme.primary,
        centerTitle: true,
        title: Text("S E T T I N G S"),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
    );
  }
}
