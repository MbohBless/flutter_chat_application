import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'package:untitled/services/auth.dart';
import 'package:untitled/services/database.dart';
import 'package:untitled/widgets/widget.dart';

import '../helper/helper_functions.dart';
import 'chatroomscreen.dart';

class SignIn extends StatefulWidget {
  final Function toogle;

  SignIn(this.toogle);

  @override
  State<StatefulWidget> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final formKey = GlobalKey<FormState>();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordEditingController = TextEditingController();
  AuthMethods authMethods = AuthMethods();
  bool isLoading = false;
  QuerySnapshot? snapshotUserInfo;
  DatabaseMethods databaseMethods = DatabaseMethods();

  signIn() {
    if (formKey.currentState!.validate()) {
      HelperFunctions.saveUserEmailSharedPreferences(
          emailTextEditingController.text);
      databaseMethods
          .getUserByEmail(emailTextEditingController.text)
          .then((val) {
        snapshotUserInfo = val;
        HelperFunctions.saveUsernameSharedPreferences(
            snapshotUserInfo?.docs[0].get("name"));
      });
      setState(() {
        isLoading = true;
      });

      authMethods
          .signInWithEmailAndPassword(
              emailTextEditingController.text, passwordEditingController.text)
          .then((val) {
        if (val != null) {
          HelperFunctions.saveUserLoggedInSharedPreferences(true);
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => const ChatRoom()));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarMain(context),
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Container(
                height: MediaQuery.of(context).size.height - 100,
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                            validator: (val) {
                              return RegExp(
                                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                      .hasMatch(val!)
                                  ? null
                                  : "Please Enter Correct Email";
                            },
                            controller: emailTextEditingController,
                            style: simpleTextStyle(),
                            decoration: textFieldInputDecoration("email")),
                        TextFormField(
                            obscureText: true,
                            validator: (val) {
                              return val!.length > 6
                                  ? null
                                  : "Provide password 6+ characters";
                            },
                            controller: passwordEditingController,
                            style: simpleTextStyle(),
                            decoration: textFieldInputDecoration("password")),
                        const SizedBox(height: 8),
                        Container(
                            alignment: Alignment.centerRight,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              child: Text("Forgot Password",
                                  style: simpleTextStyle()),
                            )),
                        GestureDetector(
                          onTap: () {
                            signIn();
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            decoration: BoxDecoration(
                                gradient: const LinearGradient(colors: [
                                  Color(0xff007EF4),
                                  Color(0xff2A75BC)
                                ]),
                                borderRadius: BorderRadius.circular(30.0)),
                            child: Text("Sign In", style: mediumTextStyle()),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30.0)),
                          child: const Text(
                            "Sign In With Google",
                            style: TextStyle(color: Colors.black, fontSize: 17),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Don't have an account?",
                                style: mediumTextStyle()),
                            GestureDetector(
                              onTap: () {
                                widget.toogle();
                              },
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 17),
                                child: const Text("Register now",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 17,
                                        decoration: TextDecoration.underline)),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 50,
                        )
                      ],
                    ),
                  ),
                ),
              )));
  }
}
