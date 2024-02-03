import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Utils/color_utils.dart';
import '../reusable_widgets/reusable_widget.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {

  final TextEditingController _emailTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        // title: const Text(
        //   "Sign Up",
        //   style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold
        //   ),
        // ),
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
                end: Alignment.bottomCenter
            )
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 120, 20, 20),
            child: Column(
              children: <Widget>[
                headBar(),
                const SizedBox(height: 80,),
                reusableTextField("Enter Email", Icons.email_outlined, false, _emailTextController),
                const SizedBox(height: 20,),
                signInSignUpButton(context, "SEND", () async {

                  if(_emailTextController.text == ""){
                    ScaffoldMessenger.of(context).showSnackBar(
                        errorMessage("Enter Your Email")
                    );
                  }
                  else{
                    try {
                      FirebaseAuth.instance.sendPasswordResetEmail(email: _emailTextController.text);

                      ScaffoldMessenger.of(context).showSnackBar(
                          ackMessage("Successfully Send password reset email"));
                      } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          errorMessage("Send password reset email failed"));
                    }
                  }
                })
              ],
            ),
          ),
        ),
      ),
    );
  }
  Row headBar(){
    return const Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        RotatedBox(quarterTurns: -1,
            child: Text(
              " Forgot \n Password",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 50),
            ),
        ),
        SizedBox(width: 10,),
        Image(image: AssetImage('assets/images/Hand.png'),
          width: 210,
        ),
      ],
    );
  }
}
