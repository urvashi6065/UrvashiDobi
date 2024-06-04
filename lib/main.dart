import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_demo/Home.dart';
import 'package:firebase_demo/firebase_options.dart';
import 'package:firebase_demo/login_scren.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: FirebaseAuth.instance.currentUser!=null?
          Home(email: FirebaseAuth.instance.currentUser!.email!)
          :const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;

  registrationFunction() async {
    try {
      setState(() {
        isLoading = true;
      });
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailController.text, password: passwordController.text)
          .then((value) async {
        await FirebaseFirestore.instance.collection('user').doc().set({
          'E-mail': value.user!.email,
          'password': passwordController.text,
          'uId': value.user!.uid
        });
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) => Home(email: value!.user!.email!)),
            (route) => false);
      });
    } catch (e) {
      if (e.toString().contains('firebase_auth/invalid-email')) {
        Fluttertoast.showToast(msg: 'The email address is badly formatted.');
      } else if (e.toString().contains('firebase_auth/email-already-in-use')) {
        Fluttertoast.showToast(
            msg: ' The email address is already in use by another account.');
      } else if (e.toString().contains('firebase_auth/weak-password')) {
        Fluttertoast.showToast(msg: 'Password should be at least 6 characters');
      }
      rethrow;
      // TODO
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Future<dynamic> loginWithGoogle() async {
  //   try {
  //     final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  //
  //     final GoogleSignInAuthentication? googleAuth =
  //         await googleUser?.authentication;
  //
  //     final credential = GoogleAuthProvider.credential(
  //       accessToken: googleAuth?.accessToken,
  //       idToken: googleAuth?.idToken,
  //     );
  //
  //     await FirebaseAuth.instance.signInWithCredential(credential);
  //     Navigator.of(context).pushAndRemoveUntil(
  //         MaterialPageRoute(builder: (context) => Home()), (route) => false);
  //   } catch (e) {
  //     // TODO
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('registration'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Enter your E-mail";
                    }
                  },
                  controller: emailController,
                  decoration: InputDecoration(hintText: "E-mail"),
                ),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Enter your password";
                    }
                  },
                  controller: passwordController,
                  decoration: InputDecoration(hintText: "Password"),
                ),
                SizedBox(
                  height: 20,
                ),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                registrationFunction();
                              }
                            },
                            child: (isLoading == false)
                                ? Text('Registration')
                                : Center(child: CircularProgressIndicator())),
                        ElevatedButton(
                            onPressed: () {
                              // Navigator.of(context).push(MaterialPageRoute(
                              //     builder: (context) => Loginscrn()));
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) => Loginscrn()),
                                  (route) => false);
                            },
                            child: Text('Log in')),
                      ],
                    ),
                    ElevatedButton(
                        onPressed: () {
                          // loginWithGoogle();
                        },
                        child: Text('LogIn with Google'))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
