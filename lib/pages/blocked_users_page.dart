import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitter_clone/services/databases/database_provider.dart';

class BlockedUsersPage extends StatefulWidget {
  BlockedUsersPage({super.key});

  @override
  State<BlockedUsersPage> createState() => _BlockedUsersPageState();
}

class _BlockedUsersPageState extends State<BlockedUsersPage> {
  late final listeningprovider = Provider.of<DatabaseProvider>(context);
  late final databaseprovider =
      Provider.of<DatabaseProvider>(context, listen: false);

  @override
  void initState() {
    super.initState();
    databaseprovider.loadblockedusers();
  }

  void _showUnBlockBox(String userid) {
    showDialog(
      context: context,
      barrierDismissible: false, // User must confirm the action
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Unblock'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to unblock this user?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Unblock'),
              onPressed: () {
                listeningprovider.unblockUser(userid);
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text("Users Unblocked")));
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final blockedusers = listeningprovider.blockedusers;
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Blocked Users",
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Theme.of(context).colorScheme.inversePrimary,
                fontWeight: FontWeight.w400,
                fontSize: 20),
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
        body: blockedusers.isEmpty
            ? Center(
                child: Text("No Users Blocked!!"),
              )
            : ListView.builder(
                itemCount: blockedusers.length,
                itemBuilder: (context, index) {
                  final users = blockedusers[index];
                  return Padding(
                    padding: EdgeInsets.all(10),
                    child: ListTile(
                      title: Text(users.username),
                      subtitle: Text("@" + users.username),
                      trailing: IconButton(
                          onPressed: () {
                            _showUnBlockBox(users.id);
                          },
                          icon: Icon(Icons.block)),
                    ),
                  );
                }));
  }
}
