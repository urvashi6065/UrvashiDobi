import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_demo/detailscreen.dart';
import 'package:firebase_demo/modelClass.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  final String email;

  const Home({super.key, required this.email});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<ModelClass> userList = [];
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    isLoading = false;
    getData().then((value) {
      isLoading = true;
    });
    super.initState();
  }

  chatRoomId(String user1, String user2) {
    if (user1[0].toLowerCase().codeUnits[0] >
        user2.toLowerCase().codeUnits[0]) {
      return "$user1$user2";
    } else {
      return "$user2$user1";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Home Screen'),
        ),
        body: (isLoading == true)
            ? ListView.builder(
                itemCount: userList.length,
                itemBuilder: (context, index) {
                  return (userList[index].uID ==
                          FirebaseAuth.instance.currentUser!.uid)
                      ? Container()
                      : Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InkWell(
                                  onTap: () {
                                    String docId = chatRoomId(
                                        FirebaseAuth
                                            .instance.currentUser!.email!,
                                        userList[index].email!);

                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                            builder: (context) => DetailScreen(
                                                  email: userList[index].email!,
                                                  docId: docId,
                                                )));
                                  },
                                  child: Text(
                                    userList[index].email!,
                                    style: TextStyle(fontSize: 20),
                                  )),
                            ],
                          ),
                        );
                })
            : Center(child: CircularProgressIndicator()));
  }

  Future getData() async {
    var data = await FirebaseFirestore.instance.collection('user').get();
    print(data.docs.length);
    for (var e in data.docs) {
      setState(() {
        userList.add(ModelClass.fromFireBase(e.data()));
      });
    }
  }
}
