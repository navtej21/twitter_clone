import 'package:flutter/material.dart';
import 'package:twitter_clone/components/my_button.dart';
import 'package:twitter_clone/components/my_circular_progress_bar.dart';
import 'package:twitter_clone/components/my_textfield.dart';
import 'package:twitter_clone/services/auth/functions.dart';
import 'package:twitter_clone/pages/register_page.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback onTap;
  const LoginPage({super.key, required this.onTap});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();

  @override
  void dispoe() {
    super.dispose();
    _emailcontroller.dispose();
    _passwordcontroller.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Icon(
                    Icons.lock_open,
                    color: Theme.of(context).colorScheme.primary,
                    size: 72,
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Text(
                    "Welcome back,you've been missed!",
                    style: TextStyle(fontSize: 19),
                  ),
                  SizedBox(
                    height: 49,
                  ),
                  MyTextField(
                      controller: _emailcontroller, hintText: "Enter Email..."),
                  SizedBox(
                    height: 10,
                  ),
                  MyTextField(
                      controller: _passwordcontroller,
                      hintText: "Enter Password..."),
                  SizedBox(
                    height: 15,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text("Forgot Password?"),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  MyButton(
                      name: "Login",
                      oncallback: () async {
                        showprogressindicator(context);
                        await loginwithemailandpassword(
                            _emailcontroller.text, _passwordcontroller.text);
                        if (mounted) hideprogressindicator(context);
                      }),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Not a Member?"),
                      SizedBox(
                        width: 5,
                      ),
                      GestureDetector(
                        onTap: () {
                          widget.onTap();
                        },
                        child: Text(
                          "Register Now",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
    );
  }
}
