import 'package:ethic_app/screen/Identifier_screen.dart';
import 'package:ethic_app/screen/home_screen_test.dart';
import 'package:ethic_app/screen/translator_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../Utils/color_utils.dart';
import '../screen/ocr_screen.dart';
import '../screen/post_image_translate_screen.dart';
import '../screen/sign_in_screen.dart';
import '../screen/voice_translator_screen.dart';

Image logoWidget(String imageName) {
  return Image.asset(
    imageName,
    fit: BoxFit.fitWidth,
    width: 150,
    height: 150,
    color: Colors.white,
  );
}

TextField reusableTextField(String text, IconData icon, bool isPasswordType,
    TextEditingController controller) {
  return TextField(
    controller: controller,
    obscureText: isPasswordType,
    enableSuggestions: !isPasswordType,
    autocorrect: !isPasswordType,
    cursorColor: Colors.white,
    style: TextStyle(color: Colors.white.withOpacity(0.9)),
    decoration: InputDecoration(
      prefixIcon: Icon(
        icon,
        color: Colors.white,
      ),
      labelText: text,
      labelStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
      filled: true,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      fillColor: Colors.white.withOpacity(0.1),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: const BorderSide(width: 0, style: BorderStyle.none)),
    ),
    keyboardType: isPasswordType
        ? TextInputType.visiblePassword
        : TextInputType.emailAddress,
  );
}

Container signInSignUpButton(
    BuildContext context, String text1, Function onTap) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 50,
    margin: const EdgeInsets.fromLTRB(210, 10, 0, 20),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)),
    child: ElevatedButton(
      onPressed: () {
        onTap();
      },
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.pressed)) {
              return Colors.black26;
            }
            return Colors.white;
          }),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)))),
      child: Text(
        text1,
        style: const TextStyle(
            color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 16),
      ),
    ),
  );
}

SnackBar errorMessage(String msg) {
  return SnackBar(
    content: Container(
        padding: const EdgeInsets.all(16),
        height: 80,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Column(
          children: [
            const Text(
              "ERROR",
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0)),
            Text(
              msg,
              style: const TextStyle(color: Colors.black54, fontSize: 14),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        )),
    behavior: SnackBarBehavior.fixed,
    backgroundColor: Colors.transparent,
    elevation: 0,
  );
}

SnackBar ackMessage(String msg) {
  return SnackBar(
    content: Container(
        padding: const EdgeInsets.all(16),
        height: 80,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Column(
          children: [
            const Text(
              "Info",
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0)),
            Text(
              msg,
              style: const TextStyle(color: Colors.black54, fontSize: 14),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        )),
    behavior: SnackBarBehavior.fixed,
    backgroundColor: Colors.transparent,
    elevation: 0,
  );
}

Card swapCard(String topic) {
  return Card(
    elevation: 10,
    color: Colors.white12,
    shape: const RoundedRectangleBorder(
      side: BorderSide(
        color: Colors.white,
      ),
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
    child: SizedBox(
      width: 250,
      height: 150,
      child: Center(
        child: Text(
          topic,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    ),
  );
}

Card commentCard(String itemUser, String itemDescription, String itemImageUrl,
    BuildContext context) {
  return Card(
    elevation: 4,
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
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
              ? Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Navigate to the PostImageTranslate page and pass the image link
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                PostImageTranslateScreen(itemImageUrl),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        primary:
                            Colors.brown, // Set the background color to brown
                      ),
                      child: Text('Translate Image'),
                    ),
                    const SizedBox(height: 8),
                    Image.network(
                      itemImageUrl,
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width * 0.4,
                    ),
                  ],
                )
              : Container(),
        ],
      ),
    ),
  );
}

Drawer mainDrawer(BuildContext context) {
  return Drawer(
    backgroundColor: hexStringToColor("422b0e"),
    child: ListView(
      children: [
        DrawerHeader(
            decoration: BoxDecoration(
              color: hexStringToColor("301c01"),
            ),
            child: const Column(
              children: [
                Text(
                  'UNITY TALKS',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Image(
                  image: AssetImage('assets/images/Hand.png'),
                  height: 100,
                ),
              ],
            )),
        ListTile(
          leading: const Icon(
            FontAwesomeIcons.peopleGroup,
            color: Colors.white,
          ),
          title: const Text(
            'Discussion forum',
            style: TextStyle(
              color: Colors.white, // White text color
            ),
          ),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const HomeScreen()));
          },
        ),
        ListTile(
          leading: const Icon(
            FontAwesomeIcons.language,
            color: Colors.white,
          ),
          title: const Text(
            'Text Translator',
            style: TextStyle(
              color: Colors.white, // White text color
            ),
          ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const TranslatorScreen()));
          },
        ),
        ListTile(
          leading: const Icon(
            Icons.photo_camera,
            color: Colors.white,
          ),
          title: const Text(
            'Image Translator',
            style: TextStyle(
              color: Colors.white, // White text color
            ),
          ),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const OcrScreen()));
          },
        ),
        // ListTile(
        //   leading: const Icon(
        //     Icons.volume_up,
        //     color: Colors.white,
        //   ),
        //   title: const Text(
        //     'Voice Translator',
        //     style: TextStyle(
        //       color: Colors.white, // White text color
        //     ),
        //   ),
        //   onTap: () {
        //     Navigator.push(context,
        //         MaterialPageRoute(builder: (context) => const VoiceTranslatorScreen()));
        //   },
        // ),
        ListTile(
          leading: const Icon(
            Icons.find_in_page,
            color: Colors.white,
          ),
          title: const Text(
            'Language Identifier',
            style: TextStyle(
              color: Colors.white, // White text color
            ),
          ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const IdentifierScreen()));
          },
        ),
        ListTile(
          leading: const Icon(
            Icons.logout,
            color: Colors.white,
          ),
          title: const Text(
            'LogOut',
            style: TextStyle(
              color: Colors.white, // White text color
            ),
          ),
          onTap: () {
            FirebaseAuth.instance.signOut().then((value) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SignInScreen()));
            });
          },
        ),
      ],
    ),
  );
}
