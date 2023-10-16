import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ethic_app/Utils/color_utils.dart';
import 'package:ethic_app/reusable_widgets/reusable_widget.dart';
import 'package:ethic_app/screen/forgot_password_screen.dart';
import 'package:ethic_app/screen/home_screen_test.dart';
import 'package:ethic_app/screen/sign_up_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {

  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            padding: EdgeInsets.fromLTRB(
                20, 90, 20, 0),
            child: Column(
              children: <Widget>[
                headBar(),
                //logoWidget("assert/images/login.png"),
                const SizedBox(height: 50,),
                reusableTextField("Enter Email", Icons.email_outlined, false, _emailTextController),
                const SizedBox(height: 20,),
                reusableTextField("Enter Password", Icons.lock_outlined, true, _passwordTextController),
                const SizedBox(height: 20,),
                forgotPassword(),
                signInSignUpButton(context, "LOG IN", () async {
                  if(_emailTextController.text == ""){
                    ScaffoldMessenger.of(context).showSnackBar(
                        errorMessage("Enter Your Email")
                    );
                  }
                  else if(_passwordTextController.text == ""){
                    ScaffoldMessenger.of(context).showSnackBar(
                        errorMessage("Enter Your Password")
                    );
                  }
                  else {
                    try {
                      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                          email: _emailTextController.text,
                          password: _passwordTextController.text
                      );
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
                    }
                    on FirebaseAuthException catch (e) {
                      if (e.code == 'INVALID_LOGIN_CREDENTIALS') {
                        ScaffoldMessenger.of(context).showSnackBar(
                            errorMessage("Invalid login credentials"));
                      } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              errorMessage("Error occurred"));
                      }
                    }
                }}),

                const SizedBox(height: 30,),
                signUpOption()
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
          " Sign in",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 60),
        )
        ),
        SizedBox(width: 40,),
        Image(image: AssetImage('assert/images/Hand.png'),
          width: 210,
        ),
      ],
    );
  }

  Row forgotPassword(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => const ForgotPassword()));
          },
          child: const Text(
            " Forgot Password?",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }

  Row signUpOption(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Text(
          "Don't have an account?",
          style: TextStyle(color: Colors.white70)
        ),
        GestureDetector(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUpScreen()));
          },
          child: const Text(
            " Sign Up",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
}
