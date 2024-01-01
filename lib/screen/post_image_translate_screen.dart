import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ethic_app/reusable_widgets/reusable_widget.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:http/http.dart' as http;
import 'package:translator/translator.dart';
import '../Utils/color_utils.dart';

const List<String> list = <String>['Sinhala', 'English', 'Tamil'];

class PostImageTranslateScreen extends StatefulWidget {
  final String itemImageUrl;
  const PostImageTranslateScreen(this.itemImageUrl, {Key? key}) : super(key: key);

  @override
  State<PostImageTranslateScreen> createState() => _PostImageTranslateScreen(itemImageUrl);
}

class _PostImageTranslateScreen extends State<PostImageTranslateScreen> {
  final String itemImageUrl;

  _PostImageTranslateScreen( this.itemImageUrl);

  File? image;
  final _textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
  String outText = '';
  TextEditingController _textEditingController = TextEditingController();
  GoogleTranslator translator = GoogleTranslator();
  String selectedTargetLanguage = "si";
  String translatedText = '';

  Future<void> getText() async {
    // Download image
    final http.Response response = await http.get(Uri.parse(itemImageUrl));
    final Directory systemTempDir = Directory.systemTemp;
    final File file = File('${systemTempDir.path}/temp.jpg');
    await file.writeAsBytes(response.bodyBytes);
    InputImage inputImage = InputImage.fromFile(file);
    final recognizedText = await _textRecognizer.processImage(inputImage);
    setState(() {
      outText = recognizedText.text;
      _textEditingController = TextEditingController(text: outText);
    });
  }


  void translateText()
  {
    translator.translate(_textEditingController.text, to: selectedTargetLanguage)
        .then((output)
    {
      setState(() {
        translatedText = output.text;
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
                const SizedBox(
                  height: 20,
                ),
                itemImageUrl.isNotEmpty
                    ? Image.network(itemImageUrl)
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
                const SizedBox(height: 10,),
                const Text('Select Language you want translate :',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16
                  ),
                ),
                const SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    DropdownMenu<String>(
                      leadingIcon: const Icon(
                        Icons.language, // Custom icon
                        color: Colors.blue,
                      ),
                      textStyle: const TextStyle(
                          color: Colors.white
                      ),
                      initialSelection: list.first,
                      onSelected: (String? value) {
                        setState(() {
                          if( value! == "Sinhala"){
                            selectedTargetLanguage = "si";}
                          else if( value == "English"){
                            selectedTargetLanguage = "en";}
                          else if( value == "Tamil"){
                            selectedTargetLanguage = "ta";}
                        });
                      },
                      dropdownMenuEntries: list.map<DropdownMenuEntry<String>>((String value) {
                        return DropdownMenuEntry<String>(
                            value: value,
                            leadingIcon: const Icon(
                              Icons.language, // Custom icon
                              color: Colors.blue,
                            ),
                            label: value);
                      }).toList(),
                    )
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    translateText();
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.brown), // Set your desired button color here
                  ),
                  child: const Text('Translate'),
                ),
                const SizedBox(height: 20),
                Container(
                  width: 350,
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                  decoration: BoxDecoration(
                    color: hexStringToColor("422b0e"),
                    borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                  ),
                  child:
                  Text(
                    translatedText,
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
      drawer: mainDrawer(context),
    );
  }
}
