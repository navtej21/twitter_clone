import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_cloud_firestore/firebase_cloud_firestore.dart';
import 'package:twitter_clone/models/user.dart';
import 'package:twitter_clone/services/auth/auth_gate.dart';
import 'package:twitter_clone/services/databases/database_service.dart';

class Post {
  final String id; //id of the poster
  final String uid; //
  final String name;
  final String username;
  final String message;
  final Timestamp timestamp;
  int likecount;

  final List<String> likedby; //ids liked who liked the post

  Post(
      {required this.id,
      required this.uid,
      required this.name,
      required this.username,
      required this.message,
      required this.timestamp,
      required this.likecount,
      required this.likedby});

  // convert to firebase document to user app

  // convert to app to firebase document

  factory Post.fromDocument(DocumentSnapshot snapshot) {
    return Post(
      id: snapshot.id,
      uid: snapshot['uid'],
      name: snapshot['name'],
      username: snapshot['username'],
      message: snapshot['message'],
      timestamp: snapshot['timestamp'],
      likecount: snapshot['likecount'],
      likedby: List<String>.from(snapshot['likedby'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'uid': uid,
      'name': name,
      'username': username,
      'timestamp': timestamp,
      'message': message,
      'likecount': likecount,
      'likedby': likedby,
    };
  }
}
