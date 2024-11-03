import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:twitter_clone/services/auth/firebase_auth.dart';
import 'package:twitter_clone/components/my_circular_progress_bar.dart';
import 'package:twitter_clone/pages/login_page.dart';

final service = AuthService();

Future<void> loginwithemailandpassword(String email, String password) async {
  try {
    service.login(email, password);
  } catch (e) {
    print("error in this ${e.toString()}");
  }
}

Future<void> logout() async {
  try {
    await service.logout();
  } catch (e) {
    print("error in this ${e}");
  }
}
