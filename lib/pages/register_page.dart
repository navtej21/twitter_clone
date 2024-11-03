import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:twitter_clone/components/my_button.dart';
import 'package:twitter_clone/components/my_textfield.dart';
import 'package:twitter_clone/services/auth/firebase_auth.dart';
import 'package:twitter_clone/services/databases/database_service.dart';

class RegisterPage extends StatefulWidget {
  final VoidCallback ontap;
  const RegisterPage({super.key, required this.ontap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final DatabaseService dbservice = DatabaseService();
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();
  final TextEditingController _namecontroller = TextEditingController();
  final TextEditingController _confirmpasswordcontroller =
      TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    _emailcontroller.dispose();
    _namecontroller.dispose();
    _confirmpasswordcontroller.dispose();
    _passwordcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 30),
                  Icon(
                    Icons.lock_open,
                    color: Theme.of(context).colorScheme.primary,
                    size: 72,
                  ),
                  SizedBox(height: 40),
                  Text(
                    "Welcome back, you've been missed!",
                    style: TextStyle(fontSize: 19),
                  ),
                  SizedBox(height: 49),
                  MyTextField(
                      controller: _namecontroller, hintText: "Enter name"),
                  SizedBox(height: 15),
                  MyTextField(
                      controller: _emailcontroller, hintText: "Enter Email"),
                  SizedBox(height: 10),
                  MyTextField(
                    isObscure: true,
                    controller: _passwordcontroller,
                    hintText: "Enter Password",
                  ),
                  SizedBox(height: 15),
                  MyTextField(
                    isObscure: true,
                    controller: _confirmpasswordcontroller,
                    hintText: "Confirm Password",
                  ),
                  SizedBox(height: 15),
                  MyButton(
                    name: "Register",
                    oncallback: () async {
                      // Validate email and password
                      if (_emailcontroller.text.isEmpty) {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Email cannot be empty")),
                          );
                        }
                        return;
                      }
                      if (_passwordcontroller.text.length < 6) {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(
                                    "Password must be at least 6 characters")),
                          );
                        }
                        return;
                      }
                      if (_confirmpasswordcontroller.text !=
                          _passwordcontroller.text) {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Passwords do not match")),
                          );
                        }
                        return;
                      }

                      // Proceed with registration
                      try {
                        UserCredential userCredential =
                            await _auth.createUserWithEmailAndPassword(
                          email: _emailcontroller.text,
                          password: _passwordcontroller.text,
                        );

                        User? user = userCredential.user;
                        if (user != null) {
                          final String uid = user.uid;
                          await dbservice.saveUserInfoinFirebase(
                            uid: uid,
                            name: _namecontroller.text,
                            email: _emailcontroller.text,
                          );

                          // Navigate or show success message
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text("Registration Successful")),
                            );
                          }

                          // Optionally navigate to login or home page
                          // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomePage()));
                        }
                      } catch (e) {
                        if (e is FirebaseAuthException) {
                          String errorMessage;
                          switch (e.code) {
                            case "email-already-in-use":
                              errorMessage = "Email already in use.";
                              break;
                            case "invalid-email":
                              errorMessage = "Invalid email format.";
                              break;

                            case "weak-password":
                              errorMessage =
                                  "Password must be at least 6 characters.";
                              break;

                            default:
                              errorMessage =
                                  "Registration failed. Please try again.";
                          }

                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(errorMessage)),
                            );
                          }
                        } else {
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(
                                    "Registration failed. Please try again")));
                          }
                        }
                      }
                    },
                  ),
                  SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already a member?"),
                      SizedBox(width: 10),
                      GestureDetector(
                        onTap: () {
                          widget.ontap();
                        },
                        child: Text(
                          "Login Now",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
