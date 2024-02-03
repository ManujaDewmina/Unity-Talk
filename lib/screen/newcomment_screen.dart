import 'dart:developer';
import 'dart:io';
import 'package:ethic_app/screen/home_screen_test.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:ethic_app/reusable_widgets/reusable_widget.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../Utils/color_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NewCommentScreen extends StatefulWidget {
  final String itemId;
  const NewCommentScreen(this.itemId,
      {Key? key})
      : super(key: key);

  @override
  State<NewCommentScreen> createState() => _NewCommentScreenState(itemId);
}

class _NewCommentScreenState extends State<NewCommentScreen> {
  final String itemId;

  _NewCommentScreenState( this.itemId);

  var currentUser = FirebaseAuth.instance.currentUser;
  TextEditingController _longTextController = TextEditingController();
  String imageUrl = '';
  var uuid = Uuid();
  File? image;
  final ImagePicker _picker = ImagePicker();
  FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference ref = FirebaseDatabase.instance.ref("comments/");
  final storage = FirebaseStorage.instance;
  final storageRef = FirebaseStorage.instance.ref("images/");
  var db = FirebaseFirestore.instance;
  String name = "";

  Future pickImageGallery() async {
    try {
      final image1 = await _picker.pickImage(source: ImageSource.gallery);
      if (image1 == null) return;

      final imageTemp = File(image1.path);
      setState(() {
        this.image = imageTemp;
      });
    } on PlatformException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(errorMessage("Error occurred"));
    }
  }

  Future pickImageCamera() async {
    try {
      final image = await _picker.pickImage(source: ImageSource.camera);
      if (image == null) return;

      final imageTemp = File(image.path);
      setState(() {
        this.image = imageTemp;
      });
    } on PlatformException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(errorMessage("Error occurred"));
    }
  }

  Future<void> _handleSubmit() async {
    String? uid = currentUser?.uid;
    String longText = _longTextController.text;
    if (image != null) {
      final imageRef = storageRef.child(image!.path);
      try {
        await imageRef.putFile(image!);
        imageUrl = await imageRef.getDownloadURL();
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(errorMessage("Error creating post"));
      }
    }
    if(_longTextController.text == ""){
      ScaffoldMessenger.of(context).showSnackBar(
          errorMessage("Enter a description")
      );
      return;
    } else {
      String id =uuid.v4();
      await ref.update({
        id: {
          "id": id,
          "postId": itemId,
          "user": name,
          "Description": longText,
          "ImageUrl": imageUrl
        }
      });
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    String? uid = currentUser?.uid;
    final docRef = db.collection("Users").doc(uid!);
    docRef.get().then(
          (DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;
        name = data["username"];
      },
      onError: (e) => log("Error getting document: $e"),
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: hexStringToColor("301c01"),
        centerTitle: true,
        foregroundColor: Colors.brown,
        title: const Text(
          "COMMENT",
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
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Comment",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: TextField(
                    controller: _longTextController,
                    maxLines: null,
                    decoration: const InputDecoration(
                      labelText: 'Comment',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Images",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  MaterialButton(
                      color: Colors.brown,
                      child: const Text("From Gallery",
                          style: TextStyle(
                              color: Colors.white70,
                              fontWeight: FontWeight.bold)),
                      onPressed: () {
                        pickImageGallery();
                      }),
                  const SizedBox(
                    width: 30,
                  ),
                  MaterialButton(
                      color: Colors.brown,
                      child: const Text("From Camera",
                          style: TextStyle(
                              color: Colors.white70,
                              fontWeight: FontWeight.bold)),
                      onPressed: () {
                        pickImageCamera();
                      }),
                ]),
                const SizedBox(
                  height: 20,
                ),
                image != null
                    ? Image.file(image!)
                    : const Image(
                  image: AssetImage('assets/images/noimage.png'),
                  width: 210,
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: _handleSubmit,
                  style: ButtonStyle(
                    backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.brown),
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                      const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 50), // Adjust vertical padding
                    ),
                    fixedSize: MaterialStateProperty.all<Size>(
                      Size(double.infinity, 60), // Set the button height
                    ),
                  ),
                  child: const Text(
                    'Post',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
      drawer: mainDrawer(context),
    );
  }
}
