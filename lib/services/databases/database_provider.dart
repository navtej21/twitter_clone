import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:twitter_clone/models/comment.dart';
import 'package:twitter_clone/models/posts.dart';
import 'package:twitter_clone/models/user.dart';
import 'package:twitter_clone/services/auth/firebase_auth.dart';
import 'package:twitter_clone/services/databases/database_service.dart';

class DatabaseProvider with ChangeNotifier {
  final DatabaseService _db = DatabaseService();
  final AuthService _auth = AuthService();

  // Store posts
  List<Post> posts = [];
  List<Post> indivualpost = [];

  // Get user information
  Future<UserProfile?> getuserinfo(String uid) {
    return _db.getuserfromfirebase(uid);
  }

  // Save user bio
  Future<void> saveuserbio(String bio, String uid) async {
    _db.saveuserbio(bio, uid);
  }

  // Save a post
  Future<void> savepost(String post) async {
    await _db.postamessageinfirebase(post);

    await getallposts();
  }

  // Fetch all posts from Firestore
  Future<void> getallposts() async {
    try {
      final responseposts = await _db.getAllPosts();
      final blockeduserids = await _db.getBlockedUidsFromFirebase();
      print(blockeduserids);
      if (responseposts != null) {
        posts = responseposts
            .where((post) => !blockeduserids.contains(post.uid))
            .toList();
        initializelikeMap();
        print(posts);
      } else {
        posts = [];
      }
      notifyListeners();
    } catch (e) {
      print("Error fetching posts: $e");
      posts = [];
      notifyListeners();
    }
  }

  // Fetch all the indivual posts from the firebase

  Future<void> getIndivualPosts(String uid) async {
    try {
      final response = await _db.getIndivualPosts(uid);
      if (response != null) {
        indivualpost = response;
        print(indivualpost.length);
        notifyListeners();
      } else {
        indivualpost = [];
        notifyListeners();
      }
    } catch (e) {
      print("Error fetching posts: $e");
      indivualpost = [];
      notifyListeners();
    }
  }

  // delete a post

  Future<void> deletepost(String postid) async {
    await _db.deletePostFromFirebase(postid);
    await getallposts();
    notifyListeners();
  }

  /* likes*/
  Map<String, dynamic> likes = {};
  List<String> likedposts = [];

  bool isPosttLikedbyCurentUser(String postid) {
    return likedposts.contains(postid);
  }

  int getLikeCount(String postid) {
    return likes[postid] ?? 0;
  }

  //* what posts had got likes if so how much
  // * who have liked the posts
  Future<void> initializelikeMap() async {
    final currentUserid = _auth.auth.currentUser!.uid;
    getallposts();

    likedposts.clear();
    likes.clear();
    for (var post in posts) {
      likes[post.id] = post.likecount ?? 0;
      if (post.likedby.contains(currentUserid)) {
        likedposts.add(post.id);
      }
    }
  }

  Future<bool> iscurrentpostlikedbyuser(String postid) async {
    final currentUserid = await _auth.auth.currentUser!.uid;
    Post post = posts.firstWhere((post) => post.id == postid);
    if (post != null) {
      return post.likedby.contains(postid);
    }
    return false;
  }

  Future<void> toggleLike(String postid) async {
    final currentUserid = await _auth.auth.currentUser!.uid;
    Post particularpost = posts.firstWhere((post) => post.id == postid);
    // unlike and like
    if (likedposts.contains(postid)) {
      likedposts.remove(postid);
      likes[postid] = likes[postid] ?? 0 - 1;
      particularpost.likecount = particularpost.likecount ?? 0 + 1;
      particularpost.likedby.add(currentUserid);
      notifyListeners();
    } else {
      likedposts.add(postid);
      likes[postid] = likes[postid] ?? 0 + 1;
      particularpost.likecount = particularpost.likecount ?? 0 - 1;
      particularpost.likedby.remove(currentUserid);
      notifyListeners();
    }

    await _db.toggleLikeInFirebase(postid);
  }

  // local list of comments

  final Map<String, List<Comment>> _comments = {};

//get comments locally
  List<Comment> getComments(String postid) {
    print(_comments[postid]);
    return _comments[postid] ?? [];
  }
  //fetch comments from firebase for a post

  Future<void> loadcomments(String postid) async {
    final allcomments = await _db.getallcommentfrompost(postid);
    _comments[postid] = allcomments;

    notifyListeners();
  }

  //add a comment

  Future<void> addComment(String postid, message) async {
    await _db.addCommentToPost(postid, message);

    await loadcomments(postid);
  }

  //delete a comment

  Future<void> deleteCommentFromPost(String commentid, String postid) async {
    await _db.deleteCommentFromPost(commentid);

    await loadcomments(postid);
  }

  // get count for all comments from a post

  Future<int> getCommentCount(String postid) async {
    int commentcount = await getCommentCount(postid);
    print(commentcount);
    return commentcount;
  }

  List<UserProfile> blockedusers = [];
  List<UserProfile> allusers = [];

  // get list of blocked users

  List<UserProfile> get Blockedusers => blockedusers;

  Future<void> loadblockedusers() async {
    final blockUserIds = await _db.getBlockedUidsFromFirebase();

    final blockedUsersData = await Future.wait(blockUserIds.map(
      (e) {
        return _db.getuserfromfirebase(e);
      },
    ));

    blockedusers = blockedUsersData.whereType<UserProfile>().toList();

    notifyListeners();
  }

  // block user

  Future<void> blockUser(String uid) async {
    await _db.blockUserInFirebase(uid);

    await loadblockedusers();
    await getallposts();

    notifyListeners();
  }

  // unblock user

  Future<void> unblockUser(String uid) async {
    await _db.unblockUserInFirebase(uid);

    await loadblockedusers();

    await getallposts();

    notifyListeners();
  }

  // report user and report

  Future<void> reportUser(String uid, String postid) async {
    await _db.reportUserInFirebase(postid, uid);
  }

  Map<String, List<String>> followers = {};
  Map<String, List<String>> following = {};
  Map<String, int> countfollowers = {};
  Map<String, int> countfollowing = {};

  int getFollowerCount(String uid) {
    return countfollowers[uid] ?? 0;
  }

  int getFollowingCount(String uid) {
    return countfollowing[uid] ?? 0;
  }

  //load followers

  Future<void> loaduserFollowers(String uid) async {
    final followerids = await _db.getfollowersuseruid(uid);
    followers[uid] = followerids;
    countfollowers[uid] = followerids.length;
    notifyListeners();
  }

  Future<void> loaduserFollowing(String uid) async {
    final followingids = await _db.getfollowinguseruid(uid);
    following[uid] = followingids;
    countfollowing[uid] = followingids.length;
    notifyListeners();
  }

  Future<void> followuser(String targetuid) async {
    final currentuserid = await FirebaseAuth.instance.currentUser!.uid;

    following.putIfAbsent(currentuserid, () => []);
    followers.putIfAbsent(targetuid, () => []);
    countfollowers.putIfAbsent(targetuid, () => 0);
    countfollowing.putIfAbsent(currentuserid, () => 0);

    if (!followers[targetuid]!.contains(currentuserid)) {
      followers[targetuid]!.add(currentuserid);
      following[currentuserid]!.add(targetuid);
      countfollowers[targetuid] = countfollowers[targetuid]! + 1;
      countfollowing[currentuserid] = countfollowing[currentuserid]! + 1;
      notifyListeners();
    }

    try {
      await _db.followUserInFirebase(targetuid);
      await loaduserFollowers(currentuserid);
      await loaduserFollowing(currentuserid);
    } catch (e) {
      followers[targetuid]!.remove(currentuserid);
      followers[currentuserid]!.remove(targetuid);
      countfollowers[targetuid] = countfollowers[targetuid]! - 1;
      notifyListeners();
    }
  }

  Future<void> unfollowertargetuser(String targetuid) async {
    final currentuserid = await FirebaseAuth.instance.currentUser!.uid;

    following.putIfAbsent(currentuserid, () => []);
    followers.putIfAbsent(currentuserid, () => []);

    if (followers[targetuid]!.contains(currentuserid)) {
      followers[targetuid]!.remove(currentuserid);
      following[currentuserid]!.remove(targetuid);
      countfollowers[targetuid] = (countfollowers[targetuid]! ?? 0) - 1;
      countfollowing[currentuserid] = (countfollowing[currentuserid] ?? 0) - 1;
      notifyListeners();
    }

    try {
      await _db.unfollowUserInFirebase(targetuid);
      await loaduserFollowers(currentuserid);
      await loaduserFollowing(currentuserid);
    } catch (e) {
      followers[targetuid]!.add(currentuserid);
      followers[currentuserid]!.add(targetuid);
      countfollowers[targetuid] = countfollowers[targetuid]! + 1;
      countfollowing[currentuserid] = countfollowing[currentuserid]! + 1;
      notifyListeners();
    }
  }

  bool isfollowing(String uid) {
    final currentuserid = FirebaseAuth.instance.currentUser!.uid;
    return followers[uid]?.contains(currentuserid) ?? false;
  }

  final Map<String, List<UserProfile>> _followerprofile = {};
  final Map<String, List<UserProfile>> _followingprofile = {};

  List<UserProfile> getListoffFollowersProfile(String uid) {
    return _followerprofile[uid] ?? [];
  }

  List<UserProfile> getListOffFollowingProfile(String uid) {
    return _followingprofile[uid] ?? [];
  }

  Future<void> loaduserFollowerProfiles(String uid) async {
    try {
      final users = await _db.getfollowersuseruid(uid);
      List<UserProfile> followerprofile = [];
      for (var user in users) {
        UserProfile? profile = await _db.getuserfromfirebase(user);
        if (profile != null) {
          followerprofile.add(profile);
        }
      }

      _followerprofile[uid] = followerprofile;
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> loaduserFollowingProfiles(String uid) async {
    try {
      final users = await _db.getfollowinguseruid(uid);
      List<UserProfile> followingprofile = [];
      for (var user in users) {
        UserProfile? profile = await _db.getuserfromfirebase(user);
        if (profile != null) {
          followingprofile.add(profile);
        }
      }

      _followingprofile[uid] = followingprofile;
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> getallusers() async {
    allusers.clear();
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection("users").get();
    for (var user in snapshot.docs) {
      if (user != null) {
        allusers.add(UserProfile.fromDocument(
            user)); // Assuming a `fromFirestore` method in `UserProfile`
      }
    }
    notifyListeners();
  }

  // load following

  // follow user

  // unfollow user

  // is cure
}
