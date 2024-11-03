import 'package:firebase_cloud_firestore/firebase_cloud_firestore.dart';

class Comment {
  final String id;
  final String postid;
  final String uid;
  final String name;
  final String username;
  final String message;
  final Timestamp timestamp;

  Comment(
      {required this.id,
      required this.postid,
      required this.uid,
      required this.name,
      required this.username,
      required this.message,
      required this.timestamp});

  //convert firestore data into a comment

  factory Comment.fromDocument(DocumentSnapshot snapshot) {
    return Comment(
      id: snapshot.id,
      postid: snapshot['postid'] as String,
      uid: snapshot['uid'] as String,
      name: snapshot['name'] as String,
      username: snapshot['username'] as String,
      message: snapshot['message'] as String,
      timestamp: snapshot['timestamp'] as Timestamp,
    );
  }

  //convert comment into a firestore data
  Map<String, dynamic> toMap() {
    return {
      'id': "",
      'postid': postid,
      'uid': uid,
      'name': name,
      'username': username,
      'message': message,
      'timestamp': timestamp.toDate(),
    };
  }
}
