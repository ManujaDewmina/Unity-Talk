import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ethic_app/reusable_widgets/reusable_widget.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import '../Utils/color_utils.dart';

class OcrScreen extends StatefulWidget {
  const OcrScreen({Key? key}) : super(key: key);

  @override
  State<OcrScreen> createState() => _OcrScreenState();
}

class _OcrScreenState extends State<OcrScreen> {
  File? image;
  final ImagePicker _picker = ImagePicker();
  TextEditingController _textEditingController = TextEditingController();

  Future pickImageGallery() async {
    try {
      final image = await _picker.pickImage(source: ImageSource.gallery);
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

  Future<void> getText() async {
    // learning.TextRecognition textRecognition = learning.TextRecognition();
    // input.InputImage imageTemp = input.InputImage.fromFile(image!);
    // learning.RecognizedText? result = await textRecognition.process(imageTemp);
    // log(result as String);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: hexStringToColor("301c01"),
        centerTitle: true,
        foregroundColor: Colors.brown,
        title: const Text(
          "IMAGE TRANSLATOR",
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
                Center(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
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
                    ])),
                const SizedBox(
                  height: 20,
                ),
                image != null
                    ? Image.file(image!)
                    : const Image(
                        image: AssetImage('assert/images/noimage.png'),
                        width: 210,
                      ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    getText();
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.brown), // Set your desired button color here
                  ),
                  child: const Text('Get Text From Image'),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  width: 350,
                  height: 200,
                  decoration: BoxDecoration(
                    color: hexStringToColor("422b0e"),
                    borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                  ),
                  child:
                  TextField(
                    controller: _textEditingController,
                    maxLines: null,
                    expands: true,
                    style: const TextStyle(
                        color: Colors.white
                    ),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      ),
                    ),
                  ),
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
