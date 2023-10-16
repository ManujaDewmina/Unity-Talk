import 'package:flutter/material.dart';
import 'package:ethic_app/reusable_widgets/reusable_widget.dart';
import '../Utils/color_utils.dart';

class ListItemScreen extends StatefulWidget {
  final String itemTitle;
  final String itemId;
  final String itemUser;
  final String itemDescription;
  final String itemImageUrl;

  const ListItemScreen(this.itemTitle, this.itemId, this.itemUser,
      this.itemDescription, this.itemImageUrl,
      {Key? key})
      : super(key: key);

  @override
  State<ListItemScreen> createState() => _ListItemScreenState(
      itemTitle, itemId, itemUser, itemDescription, itemImageUrl);
}

class _ListItemScreenState extends State<ListItemScreen> {
  final String itemTitle;
  final String itemId;
  final String itemUser;
  final String itemDescription;
  final String itemImageUrl;

  _ListItemScreenState(this.itemTitle, this.itemId, this.itemUser,
      this.itemDescription, this.itemImageUrl);

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
              Card(
                elevation: 4,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                      'Topic: $itemTitle',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Author: $itemUser',
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Description: $itemDescription',
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Image.network(
                        itemImageUrl,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      drawer: mainDrawer(context),
    );
  }
}
