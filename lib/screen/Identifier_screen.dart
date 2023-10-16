import 'package:flutter/material.dart';
import 'package:ethic_app/reusable_widgets/reusable_widget.dart';
import 'package:translator/translator.dart';
import '../Utils/color_utils.dart';

class IdentifierScreen extends StatefulWidget {
  const IdentifierScreen({Key? key}) : super(key: key);

  @override
  State<IdentifierScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<IdentifierScreen> {
  final inputText = TextEditingController();
  String translatedText = '';
  GoogleTranslator translator = GoogleTranslator();

  void translateText()
  {
    translator.translate(inputText.text)
        .then((output)
    {
      setState(() {
        if(output.sourceLanguage.name == "Automatic") {
          translatedText = "English";
        }
        else {
          translatedText = output.sourceLanguage.name;
        }
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
        title: const Text("LANGUAGE IDENTIFIER",
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
            ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter
            )
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                width: 350,
                height: 400,
                decoration: BoxDecoration(
                  color: hexStringToColor("422b0e"),
                  borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                ),
                child:
                TextField(
                  controller: inputText,
                  maxLines: null,
                  expands: true,
                  style: const TextStyle(
                      color: Colors.white
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Enter your text',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  translateText();
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.brown), // Set your desired button color here
                ),
                child: const Text('Identify Language'),
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
                Center(
                child: Text(
                  translatedText,
                  style: const TextStyle(fontSize: 16, color: Colors.white),
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