import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DetailScreen extends StatefulWidget {
  final String email;
  final String docId;

  const DetailScreen({super.key, required this.email, required this.docId});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  TextEditingController sendController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.email!),
      ),
      body: Align(
        alignment: Alignment.bottomCenter,
        child: Stack(
          children: [
            Container(
              height: 450,
              child: StreamBuilder(
                  stream: getMessage(),
                  builder: (context,
                      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                          snapshot) {
                    return (snapshot.data==null)?Center(child: CircularProgressIndicator()):ListView.builder(
                      reverse: true,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                                width: double.infinity,
                                child: Align(
                                    alignment: (FirebaseAuth
                                                .instance.currentUser!.email ==
                                            snapshot.data!.docs[index]['send'])
                                        ? Alignment.topRight
                                        : Alignment.topLeft,
                                    child: Text( snapshot.data!.docs[index]['msg']))),
                          );
                        });
                  }),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(20)),
                child: TextFormField(
                  controller: sendController,
                  decoration: InputDecoration(
                    hintText: "Message",
                    prefixIcon: Icon(Icons.emoji_emotions_outlined),
                    border: InputBorder.none,
                    suffixIcon: IconButton(
                        onPressed: () async {
                          await FirebaseFirestore.instance
                              .collection('chat')
                              .doc(widget.docId)
                              .collection('chats')
                              .doc()
                              .set({
                            'msg': sendController.text,
                            'send': FirebaseAuth.instance.currentUser!.email,
                            'recived': widget.email,
                            'createdAt': DateTime.now().toIso8601String()
                          });
                        },
                        icon: Icon(Icons.send)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  getMessage() {
    return FirebaseFirestore.instance
        .collection('chat')
        .doc(widget.docId)
        .collection('chats')
    .orderBy('createdAt',descending: true)
        .snapshots();
  }
}
