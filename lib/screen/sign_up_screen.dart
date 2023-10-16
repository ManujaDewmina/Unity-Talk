import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ethic_app/screen/sign_in_screen.dart';
import '../Utils/color_utils.dart';
import '../reusable_widgets/reusable_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

    final TextEditingController _passwordTextController = TextEditingController();
    final TextEditingController _emailTextController = TextEditingController();
    final TextEditingController _userNameTextController = TextEditingController();

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
              padding: const EdgeInsets.fromLTRB(20, 90, 20, 20),
              child: Column(
                children: <Widget>[
                  headBar(),
                  const SizedBox(height: 70,),
                  reusableTextField("Enter User Name", Icons.person_outlined, false, _userNameTextController),
                  const SizedBox(height: 20,),
                  reusableTextField("Enter Email", Icons.email_outlined, false, _emailTextController),
                  const SizedBox(height: 20,),
                  reusableTextField("Enter Password", Icons.lock_outlined, true, _passwordTextController),
                  const SizedBox(height: 20,),
                  signInSignUpButton(context, "SIGN UP", () async {

                    if(_userNameTextController.text == ""){
                      ScaffoldMessenger.of(context).showSnackBar(
                          errorMessage("Enter Your User Name")
                      );
                    }
                    else if(_emailTextController.text == ""){
                      ScaffoldMessenger.of(context).showSnackBar(
                          errorMessage("Enter Your Email")
                      );
                    }
                    else if(_passwordTextController.text == ""){
                      ScaffoldMessenger.of(context).showSnackBar(
                          errorMessage("Enter Your Password")
                      );
                    }
                    else{
                      try {
                        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _emailTextController.text, password: _passwordTextController.text);
                        User? user = FirebaseAuth.instance.currentUser;
                        if (user!= null) {
                          var db = FirebaseFirestore.instance;
                          final dbuser = <String, String>{
                            "username": _userNameTextController.text,
                            "useremail": _emailTextController.text,
                          };
                          db
                              .collection("Users")
                              .doc(user.uid)
                              .set(dbuser);
                        }
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> const SignInScreen()));
                      }
                      on FirebaseAuthException catch (e) {
                        if (e.code == 'weak-password') {
                          ScaffoldMessenger.of(context).showSnackBar(
                              errorMessage("Password must be at least 6 characters"));
                        } else if (e.code == 'email-already-in-use') {
                          ScaffoldMessenger.of(context).showSnackBar(
                              errorMessage("Account already exists for that email"));
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            errorMessage("User Registration Failed"));
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
                " Sign up",
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
  }
