import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:ethic_app/reusable_widgets/reusable_widget.dart';
import 'package:translator/translator.dart';
import '../Utils/color_utils.dart';
import 'package:ethic_app/screen/newcomment_screen.dart';

const List<String> list = <String>['English', 'Sinhala', 'Tamil'];

class CommentData {
  String id;
  String postId;
  String user;
  String Description;
  String ImageUrl;

  CommentData(this.id, this.postId, this.user, this.Description, this.ImageUrl);
}

class ListItemScreen extends StatefulWidget {
  final String itemTitle;
  final String itemId;
  final String itemUser;
  final String itemDescription;
  final String itemImageUrl;

  const ListItemScreen(
      this.itemTitle,
      this.itemId,
      this.itemUser,
      this.itemDescription,
      this.itemImageUrl, {
        Key? key,
      }) : super(key: key);

  @override
  State<ListItemScreen> createState() => _ListItemScreenState(
    itemTitle,
    itemId,
    itemUser,
    itemDescription,
    itemImageUrl,
  );
}

class _ListItemScreenState extends State<ListItemScreen> {
  late String itemTitle;
  final String itemId;
  final String itemUser;
  late String itemDescription;
  final String itemImageUrl;

  _ListItemScreenState(
      this.itemTitle,
      this.itemId,
      this.itemUser,
      this.itemDescription,
      this.itemImageUrl,
      );

  GoogleTranslator translator = GoogleTranslator();
  String selectedTargetLanguage = "en";
  final inputText = TextEditingController();
  List<CommentData> commentsList = [];
  FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference ref = FirebaseDatabase.instance.ref("comments/");

  @override
  void initState() {
    super.initState();

    // Set up Firebase listener
    ref.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value;
      if (data != null && data is Map) {
        data.forEach((key, value) {
          if (value is Map && value.containsKey('postId')) {
            String postId = value['postId'];
            String id = value['id'];
            String user = value['user'];
            String Description = value['Description'];
            String ImageUrl = value['ImageUrl'];
            if (postId == itemId) {
              // Add to the commentsList only when postId matches itemId
              if (!commentsList.any((element) => element.id == id)) {
                commentsList.add(CommentData(id, postId, user, Description, ImageUrl));
              }
            }
          }
        });
        // Call setState here to update the UI
        setState(() {
          // commentsList;
        });
      }
    });
  }

  void translateText() {
    translator.translate(itemTitle, to: selectedTargetLanguage).then((output) {
      setState(() {
        itemTitle = output.text;
      });
    });
    translator
        .translate(itemDescription, to: selectedTargetLanguage)
        .then((output) {
      setState(() {
        itemDescription = output.text;
      });
    });
  }

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
          gradient: LinearGradient(
            colors: [
              hexStringToColor("301c01"),
              hexStringToColor("422b0e"),
              hexStringToColor("9c7035"),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    DropdownMenu<String>(
                      leadingIcon: const Icon(
                        Icons.language,
                        color: Colors.blue,
                      ),
                      textStyle: const TextStyle(color: Colors.white),
                      initialSelection: list.first,
                      onSelected: (String? value) {
                        setState(() {
                          if (value == "English") {
                            selectedTargetLanguage = "en";
                          } else if (value == "Sinhala") {
                            selectedTargetLanguage = "si";
                          } else if (value == "Tamil") {
                            selectedTargetLanguage = "ta";
                          }
                        });
                        translateText();
                      },
                      dropdownMenuEntries: list
                          .map<DropdownMenuEntry<String>>((String value) {
                        return DropdownMenuEntry<String>(
                          value: value,
                          leadingIcon: const Icon(
                            Icons.language,
                            color: Colors.blue,
                          ),
                          label: value,
                        );
                      }).toList(),
                    )
                  ],
                ),
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Topic: $itemTitle',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: <Widget>[
                            const Icon(
                              Icons.person_3,
                            ),
                            Text(
                              itemUser,
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          itemDescription,
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        itemImageUrl.isNotEmpty
                            ? Image.network(
                          itemImageUrl,
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width * 0.4,
                        )
                            : Container(),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    key: const Key('commentsList'),
                    padding: const EdgeInsets.all(8),
                    itemCount: commentsList.length ?? 0,
                    itemBuilder: (BuildContext context, int index) {
                      String itemPostId1 =
                          commentsList[index].postId ?? '';
                      String itemId1 = commentsList[index].id ?? '';
                      String itemUser1 = commentsList[index].user ?? '';
                      String itemDescription1 =
                          commentsList[index].Description ?? '';
                      String itemImageUrl1 =
                          commentsList[index].ImageUrl ?? '';

                      return Column(
                        children: <Widget>[
                          commentCard(
                            itemUser1,
                            itemDescription1,
                            itemImageUrl1,
                            context,
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
              builder: (context) => NewCommentScreen(itemId),
            ),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.black,
      ),
    );
  }
}
