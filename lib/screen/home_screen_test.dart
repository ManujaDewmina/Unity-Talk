import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:ethic_app/reusable_widgets/reusable_widget.dart';
import 'package:ethic_app/screen/listitem_screen.dart';
import 'package:ethic_app/screen/newpost_screen.dart';
import '../Utils/color_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference ref = FirebaseDatabase.instance.ref();
  List<String> topicsList = [];
  // var currentUser = FirebaseAuth.instance.currentUser;
  // var db = FirebaseFirestore.instance;
  // String name = "1";

  @override
  Widget build(BuildContext context) {
    ref.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value;
      if (data != null && data is Map) {
        if (data != null && data is Map) {
          data.forEach((key, value) {
            if (value is Map && value.containsKey('topic')) {
              String topic = value['topic'];
              String id = value['id'];
              if (!topicsList.contains(topic+"- id : "+id)) {
                topicsList.add(topic+"- id : "+id);
              }
            }
          });
        }
      }
      setState(() {
        topicsList;
      });
    });

    // String? email = currentUser?.email;
    // String? uid = currentUser?.uid;
    // final docRef = db.collection("Users").doc(uid!);
    // docRef.get().then(
    //       (DocumentSnapshot doc) {
    //     final data = doc.data() as Map<String, dynamic>;
    //     name = data["username"];
    //   },
    //   onError: (e) => log("Error getting document: $e"),
    // );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: hexStringToColor("301c01"),
        centerTitle: true,
        foregroundColor: Colors.brown,
        title: const Text(
          "DISCUSSION FORUM",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.brown,
          ),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          hexStringToColor("301c01"),
          hexStringToColor("422b0e"),
          hexStringToColor("9c7035"),
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: ListView.builder(
                    key: const Key('itemList'),
                    padding: const EdgeInsets.all(8),
                    itemCount: topicsList?.length ?? 0,
                    itemBuilder: (BuildContext context, int index) {
                      String itemTitle =  RegExp(r'(\w+)\s*-\s*id\s*:\s*id').firstMatch(topicsList[index])?.group(2) ?? '';

                      return Column(
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.black, // Border color
                                width: 1.0, // Border width
                              ),
                              borderRadius:
                                  BorderRadius.circular(8.0), // Border radius
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 8.0),
                              title: Text(
                                itemTitle,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0),
                              ),
                              leading: const CircleAvatar(
                                backgroundColor: Colors.grey,
                                child: Icon(Icons.list, color: Colors.white),
                              ),
                              trailing: const Icon(
                                  Icons.label_important_outline_sharp),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ListItemScreen(itemTitle),
                                  ),
                                );
                              },
                            ),
                          ),
                          const Divider(),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      drawer: mainDrawer(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NewPostScreen(),
            ),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.black,
      ),
    );
  }
}
