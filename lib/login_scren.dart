import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_demo/Home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Loginscrn extends StatefulWidget {
  const Loginscrn({super.key});

  @override
  State<Loginscrn> createState() => _LoginscrnState();
}

class _LoginscrnState extends State<Loginscrn> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  loginFunction() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text).then((value) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => Home(email: value.user!.email!,)), (route) => false);
      });

    } catch (e) {
      if (e.toString().contains('firebase_auth/invalid-credential')) {
        Fluttertoast.showToast(msg: 'please enter vailde E-mail');
      } else if (e.toString().contains('firebase_auth/invalid-email')) {
        Fluttertoast.showToast(msg: 'The email address is badly formatted.');
      }
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('log in'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(hintText: "E-mail"),
              ),
              TextFormField(
                controller: passwordController,
                decoration: InputDecoration(hintText: "Password"),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        loginFunction();
                      },
                      child: Text('Log in')),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
