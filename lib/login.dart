import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp/registration.dart';

import 'Home.dart';
import 'model/User.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerPassword = TextEditingController();
  String _errorMessage = " ";

  _authenticationLogin() {
    //retrieve the fields
    String email = _controllerEmail.text;
    String password = _controllerPassword.text;

    if (email.isNotEmpty && email.contains("@")) {
      if (password.isNotEmpty) {
        setState(() {
          _errorMessage = " ";
        });

        Userdata user = Userdata();
        user.email = email;
        user.password = password;
        _loginUser(user);
      } else {
        setState(() {
          _errorMessage = "Enter a valid password";
        });
      }
    } else {
      setState(() {
        _errorMessage = "Enter a valid email";
      });
    }
  }

  _loginUser(Userdata user) async {
    await Firebase.initializeApp();
    FirebaseAuth _auth = FirebaseAuth.instance;
    _auth
        .signInWithEmailAndPassword(email: user.email, password: user.password)
        .then((firebaseUser) {
      Navigator.push(
          context, MaterialPageRoute(builder: ((context) => const Home())));
    }).catchError((error) {
      setState(() {
        _errorMessage = 'Error authenticating user, check email and password.';
      });
    });
  }

  Future _checkIfTheUserIsLoggedIn() async {
    Firebase.initializeApp();
    FirebaseAuth auth = FirebaseAuth.instance;
    //auth.signOut();
    final User? loggedInUser = await auth.currentUser;
    if (loggedInUser != null) {
      Navigator.push(
          context, MaterialPageRoute(builder: ((context) => const Home())));
    }
  }

  @override
  void initState() {
    _checkIfTheUserIsLoggedIn();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: Color(0xff075E54)),
        padding: const EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 32),
                  child:
                      Image.asset("images/logo.png", width: 200, height: 150),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: TextField(
                    controller: _controllerEmail,
                    autofocus: true,
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        hintText: "E-mail",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32))),
                  ),
                ),
                TextField(
                  controller: _controllerPassword,
                  obscureText: true,
                  keyboardType: TextInputType.text,
                  style: TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      hintText: "Password",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32))),
                ),
                Padding(
                    padding: EdgeInsets.only(top: 16, bottom: 10),
                    child: TextButton(
                      style: TextButton.styleFrom(
                          foregroundColor: Colors.green,
                          padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32))),
                      child: Text(
                        "Login",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      onPressed: (() {
                        _authenticationLogin();
                      }),
                    )),
                Center(
                  child: GestureDetector(
                    child: Text(
                      "Don't have an account? register here.",
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: (() {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => const Registration())));
                    }),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Center(
                    child: Text(
                      _errorMessage,
                      style: const TextStyle(color: Colors.red, fontSize: 20),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
