import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitter_clone/services/databases/database_provider.dart';

class MyCommentTile extends StatelessWidget {
  final String comment;
  final String name;
  final String username;
  MyCommentTile({
    super.key,
    required this.comment,
    required this.username,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<DatabaseProvider>(
      builder: (context, listenprovider, child) {
        return Padding(
          padding: const EdgeInsets.all(10),
          child: GestureDetector(
            onTap: () {
              // Add functionality to view comment details or author
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.person),
                        const SizedBox(width: 10),
                        Text(
                          name,
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          username,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            // Show options for comment (like delete or report)
                          },
                          child: const Icon(Icons.more_horiz),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Text(
                        comment,
                        style: TextStyle(
                          color: Colors.black54,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            // Add functionality for reacting to the comment
                          },
                          child: const Icon(
                            Icons.favorite_border,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(width: 20),
                        GestureDetector(
                          onTap: () {
                            // Add functionality to comment on this comment
                          },
                          child: Icon(
                            Icons.comment,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
