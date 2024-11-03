/*
Database service

this class handles all the data from and to the firebase


- userprofile
- post message
- likes
- comments
- account stuff(report/block/delete account)
- follow /unfollow
- search users
*/

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_cloud_firestore/firebase_cloud_firestore.dart';
import 'package:twitter_clone/models/comment.dart';
import 'package:twitter_clone/models/posts.dart';
import 'package:twitter_clone/models/user.dart';

class DatabaseService {
  final db = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;

  /* User Profile*/

  Future<void> saveUserInfoinFirebase(
      {required String uid,
      required String name,
      required String email,
      String bio = ""}) async {
    try {
      await db.collection('users').doc(uid).set({
        "uid": uid,
        'name': name,
        'email': email,
        'username': email.split("@")[0],
        "bio": bio
      });
    } catch (e) {
      print('Error saving user info: $e');
      throw e;
    }
  }

  Future<UserProfile?> getuserfromfirebase(String uid) async {
    try {
      DocumentSnapshot snapshot = await db.collection("users").doc(uid).get();
      return UserProfile.fromDocument(snapshot);
    } catch (e) {
      print("no value");
      return null;
    }
  }
  /* SAVE BIO*/

  Future<void> saveuserbio(String bio, String uid) async {
    try {
      DocumentSnapshot snapshot = await db.collection("users").doc(uid).get();
      UserProfile? userprofile = UserProfile.fromDocument(snapshot);

      await saveUserInfoinFirebase(
          uid: userprofile.id,
          name: userprofile.name,
          email: userprofile.email,
          bio: bio);
    } catch (e) {
      print(e);
    }
  } /* Post */
  /*
  post a message
  */

  Future<void> postamessageinfirebase(String message) async {
    try {
      final _db = DatabaseService();

      String uid = FirebaseAuth.instance.currentUser!.uid;

      UserProfile? user = await _db.getuserfromfirebase(uid);

      Post newPost = Post(
          id: "",
          uid: uid,
          name: user!.name,
          username: user.username,
          message: message,
          timestamp: Timestamp.now(),
          likecount: 0,
          likedby: []);
      Map<String, dynamic> newPostMap = newPost.toMap();

      await db.collection("Posts").add(newPostMap);
    } catch (e) {
      print(e);
      print("failed");
    }
  }

  // delete a post
  // get all posts
  Future<List<Post>> getAllPosts() async {
    try {
      QuerySnapshot query = await FirebaseFirestore.instance
          .collection("Posts")
          .orderBy("timestamp", descending: true)
          .get();

      return query.docs.map((doc) => Post.fromDocument(doc)).toList();
    } catch (e) {
      return [];
    }
  }

  // get individual posts

  Future<List<Post>> getIndivualPosts(String uid) async {
    try {
      QuerySnapshot query = await FirebaseFirestore.instance
          .collection("Posts")
          .where("uid", isEqualTo: uid)
          .get();
      return query.docs.map((doc) => Post.fromDocument(doc)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> deletePostFromFirebase(String postid) async {
    try {
      await db.collection("Posts").doc(postid).delete();
    } catch (e) {
      print(e);
    }
  }

  /* Likes */

  Future<void> toggleLikeInFirebase(String postid) async {
    try {
      String uid = auth.currentUser!.uid;

      // go to do for this post
      DocumentReference postDoc = await db.collection("Posts").doc(postid);

      await db.runTransaction((transaction) async {
        // get post data
        DocumentSnapshot postsnapshot = await transaction.get(postDoc);

        // get like of users who like that post
        List<String> likedby = List<String>.from(postsnapshot["likedby"]);

        // get like count
        int currentLikeCcount = postsnapshot["likecount"];

        // if user has not liked this post yet->then store it in like section
        if (!likedby.contains(uid)) {
          //add user to like list
          likedby.add(uid);

          //increment like count
          currentLikeCcount++;
        }

        // if user has not liked this post yet->then store it in like section
        else {
          //remove user from like list
          likedby.remove(uid);

          //decrement like count
          currentLikeCcount--;
        }

        transaction.update(
            postDoc, {'likecount': currentLikeCcount, 'likedby': likedby});
      });
    } catch (e) {
      print(e);
    }
  }

  /* Comments */

  // Add a comment to a post

  Future<void> addCommentToPost(String postid, String message) async {
    try {
      String uid = await auth.currentUser!.uid;
      UserProfile? user = await getuserfromfirebase(uid);
      print(user);
      Comment comment = Comment(
          id: '',
          postid: postid,
          uid: uid,
          name: user!.name,
          username: user!.username,
          message: message,
          timestamp: Timestamp.now());
      Map<String, dynamic> commentmap = comment.toMap();

      await db.collection("Comment").add(commentmap);
    } catch (e) {
      print(e);
    }
  }

  // delete the comment
  Future<void> deleteCommentFromPost(String commentid) async {
    try {
      await db.collection("Comment").doc(commentid).delete();
    } catch (e) {
      print(e);
    }
  }

  //fetch the comments

  Future<List<Comment>> getallcommentfrompost(String postid) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("Comment")
          .where("postid", isEqualTo: postid)
          .get();
      return querySnapshot.docs
          .map((doc) => Comment.fromDocument(doc))
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<int> getcountofallcommentfrompost(String postid) async {
    try {
      QuerySnapshot querysnapshot = await FirebaseFirestore.instance
          .collection("Comment")
          .where("postid", isEqualTo: postid)
          .get();
      return querysnapshot.docs.length;
    } catch (e) {
      return 0;
    }
  }

  /* Account Stuff */

  //* reporting user in firebase

  Future<void> reportUserInFirebase(String postid, String userid) async {
    final currentuser = FirebaseAuth.instance.currentUser!.uid;

    final report = {
      'reportedby': currentuser,
      'messageId': postid,
      'messageownerid': userid,
      'timestamp': FieldValue.serverTimestamp()
    };

    await db.collection("Reports").add(report);
  }

  // block user

  Future<void> blockUserInFirebase(String userid) async {
    final currentUserid = FirebaseAuth.instance.currentUser!.uid;

    await db
        .collection("Users")
        .doc(currentUserid)
        .collection("BlockedUsers")
        .doc(userid)
        .set({});
  }

  Future<void> unblockUserInFirebase(String userid) async {
    final currentUserid = FirebaseAuth.instance.currentUser!.uid;

    await db
        .collection("Users")
        .doc(currentUserid)
        .collection("BlockedUsers")
        .doc(userid)
        .delete();
  }

  Future<List<String>> getBlockedUidsFromFirebase() async {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;

    final snapshot = await db
        .collection("Users")
        .doc(currentUserId)
        .collection("BlockedUsers")
        .get();
    print(snapshot);
    return snapshot.docs.map((doc) => doc.id).toList();
  }

  Future<void> deleteUserInfoFromFirebase(String uid) async {
    WriteBatch batch = db.batch();

    DocumentReference userdoc = db.collection("Users").doc(uid);
    batch.delete(userdoc);
    DocumentReference userdoc2 = db.collection("users").doc(uid);
    batch.delete(userdoc2);
    QuerySnapshot postsnapshpt =
        await db.collection("Posts").where("uid", isEqualTo: uid).get();
    for (var post in postsnapshpt.docs) {
      batch.delete(post.reference);
    }

    QuerySnapshot allposts = await db.collection("Posts").get();
    for (QueryDocumentSnapshot post in allposts.docs) {
      Map<String, dynamic> postdata = post.data() as Map<String, dynamic>;
      if (postdata["likedby"].contains(uid)) {
        batch.update(post.reference, {
          'likedby': FieldValue.arrayRemove([uid]),
          'likecount': FieldValue.increment(-1)
        });
      }
    }

    QuerySnapshot reportsnapshot =
        await db.collection("Reports").where("uid", isEqualTo: uid).get();
    for (var reports in reportsnapshot.docs) {
      batch.delete(reports.reference);
    }
    QuerySnapshot commentsnapshot =
        await db.collection("Comment").where("uid", isEqualTo: uid).get();
    for (var post in commentsnapshot.docs) {
      batch.delete(post.reference);
    }
    await batch.commit();
  }

  /* Follow */

  Future<void> followUserInFirebase(String uid) async {
    final currentuser = FirebaseAuth.instance.currentUser!.uid;
    await db
        .collection("users")
        .doc(currentuser)
        .collection("following")
        .doc(uid)
        .set({});

    await db
        .collection("users")
        .doc(uid)
        .collection("followers")
        .doc(currentuser)
        .set({});
  }

  Future<void> unfollowUserInFirebase(String uid) async {
    final currentuser = FirebaseAuth.instance.currentUser!.uid;
    await db
        .collection("users")
        .doc(currentuser)
        .collection("following")
        .doc(uid)
        .delete();

    await db
        .collection("users")
        .doc(uid)
        .collection("following")
        .doc(uid)
        .delete();
  }

  Future<List<String>> getfollowinguseruid(String uid) async {
    final snapshot =
        await db.collection("users").doc(uid).collection("following").get();

    return snapshot.docs.map((e) => e.id).toList();
  }

  Future<List<String>> getfollowersuseruid(String uid) async {
    final snapshot =
        await db.collection("users").doc(uid).collection("followers").get();

    return snapshot.docs.map((e) => e.id).toList();
  }

  // unfollow user

  // get a users followers: list of uids

  /* Search */
}
