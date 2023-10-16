import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ethic_app/reusable_widgets/reusable_widget.dart';
import '../Utils/color_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ListItemScreen extends StatefulWidget {
  const ListItemScreen(String itemTitle, {Key? key}) : super(key: key);

  @override
  State<ListItemScreen> createState() => _ListItemScreenState();
}

class _ListItemScreenState extends State<ListItemScreen> {
  @override
  Widget build(BuildContext context) {
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
          child: Column(
            children: <Widget>[

            ],
          ),
        ),
      ),
      drawer: mainDrawer(context),
    );
  }
}
