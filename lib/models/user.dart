/*

USER PROFILE

This is what every user should have for their profile
------------------------------------------------------

- uid
- name
- email
- username
- bio
-profile photo('we will do at end required some work')
*/

import 'package:firebase_cloud_firestore/firebase_cloud_firestore.dart';

class UserProfile {
  final String id;
  final String name;
  final String email;
  final String username;
  final String bio;

  UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.username,
    required this.bio,
  });

  factory UserProfile.fromDocument(DocumentSnapshot doc) {
    return UserProfile(
      bio: doc["bio"],
      email: doc["email"] as String,
      name: doc["name"] as String,
      username: doc["username"] as String,
      id: doc.id,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'username': username,
      'bio': bio
    };
  }
}
