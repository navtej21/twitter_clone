import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitter_clone/components/my_alert_box.dart';
import 'package:twitter_clone/components/my_drawer.dart';
import 'package:twitter_clone/components/my_post_tile.dart';
import 'package:twitter_clone/helper/navigaton_help.dart';
import 'package:twitter_clone/models/posts.dart';
import 'package:twitter_clone/services/databases/database_provider.dart';
import 'package:twitter_clone/components/my_post_widget_design.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final provider = Provider.of<DatabaseProvider>(context, listen: false);
  late final listeningprovider = Provider.of<DatabaseProvider>(context);
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _commentcontroller = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  void initState() {
    super.initState();
    loadallposts();
  }

  Future<void> loadallposts() async {
    await provider.getallposts();
  }

  void openDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return MyAlertBox(
          title: "What's on your mind",
          controller: _controller,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<DatabaseProvider>(
        builder: (context, listeningprovider, child) {
          return buildPostList(listeningprovider.posts);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          openDialog();
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        centerTitle: true,
        title: Text("H O M E"),
      ),
      drawer: MyDrawer(),
      backgroundColor: Theme.of(context).colorScheme.surface,
    );
  }
}
