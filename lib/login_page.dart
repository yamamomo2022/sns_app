import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sns_app/main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _email = '';
  String _password = '';

  @override
  void initState() {
    super.initState();
    try {
      FirebaseAuth.instance.signInAnonymously();
      print("Signed in with temporary account.");
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "operation-not-allowed":
          print("Anonymous auth hasn't been enabled for this project.");
          break;
        default:
          print("Unknown error.");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login Page"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Email',
              ),
              onChanged: (value) {
                _email = value;
              },
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Password',
              ),
              onChanged: (value) {
                _password = value;
              },
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  // // Sign in logic
                  // await FirebaseAuth.instance.signInWithEmailAndPassword(
                  //   email: _email,
                  //   password: _password,
                  // );
                  Navigator.pushAndRemoveUntil(context,
                      MaterialPageRoute(builder: (context) {
                    return const MyHomePage(title: "Home Page");
                  }), (route) => false);
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'user-not-found') {
                    print('No user found for that email.');
                  } else if (e.code == 'wrong-password') {
                    print('Wrong password provided for that user.');
                  } else {
                    print(e);
                  }
                }
              },
              child: Text("Login"),
            ),
          ],
        ),
      ),
    );
  }
}
