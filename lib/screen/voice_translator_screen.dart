import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ethic_app/reusable_widgets/reusable_widget.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:translator/translator.dart';
import '../Utils/color_utils.dart';
import 'package:avatar_glow/avatar_glow.dart';

const List<String> list = <String>['Sinhala', 'English', 'Tamil'];

class VoiceTranslatorScreen extends StatefulWidget {
  const VoiceTranslatorScreen({Key? key}) : super(key: key);

  @override
  State<VoiceTranslatorScreen> createState() => _VoiceTranslatorScreen();
}

class _VoiceTranslatorScreen extends State<VoiceTranslatorScreen> {
  File? image;
  final _textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
  String outText = '';
  TextEditingController _textEditingController = TextEditingController();
  GoogleTranslator translator = GoogleTranslator();
  String selectedTargetLanguage = "si";
  String translatedText = '';
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String text = 'click to speak';
  double _confidence = 1.0;

  Future<void> getText() async {
    InputImage inputImage = InputImage.fromFile(image!);
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
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: hexStringToColor("301c01"),
        centerTitle: true,
        foregroundColor: Colors.brown,
        title: const Text(
          "VOICE TRANSLATOR",
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
                Text(text,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16
                  ),
                ),
                AvatarGlow(
                  animate: _isListening,
                  glowColor: Theme.of(context).primaryColor,
                  duration: const Duration(milliseconds: 2000),
                  repeat: true,
                  child: FloatingActionButton(
                    onPressed: _listen,
                    child: Icon(_isListening ? Icons.mic : Icons.mic_none),
                  ),
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
  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            _textEditingController.text = val.recognizedWords;
            if (val.hasConfidenceRating && val.confidence > 0) {
              _confidence = val.confidence;
            }
          }),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }
}
