import 'package:flutter/material.dart';
import 'package:untitled/helper/helper_functions.dart';
import 'package:untitled/services/auth.dart';
import 'package:untitled/services/database.dart';
import 'package:untitled/views/chatroomscreen.dart';
import 'package:untitled/widgets/widget.dart';

class SignUp extends StatefulWidget {
  final Function toogle;
   SignUp(this.toogle);
  @override
  State<StatefulWidget> createState() => _SignupState();
}

class _SignupState extends State<SignUp> {

  //variables
  final formKey = GlobalKey<FormState>();
  TextEditingController userNameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordEditingController = TextEditingController();
  bool isLoading = false;
  AuthMethods authMethods = AuthMethods();
  DatabaseMethods databaseMethods= DatabaseMethods();
  HelperFunctions helperFunctions=HelperFunctions();
  //functions
  signMeUp() {

    if (formKey.currentState!.validate()) {
      Map<String,String> userMap ={
        "name":userNameTextEditingController.text,
        "email":emailTextEditingController.text
      };
      HelperFunctions.saveUsernameSharedPreferences(userNameTextEditingController.text);
      HelperFunctions.saveUserEmailSharedPreferences(emailTextEditingController.text);
      setState(() {
        isLoading = true;
      });
      authMethods.signUpWIthEmailAndPassword(
          emailTextEditingController.text, passwordEditingController.text)
          .then((value) {
        databaseMethods.uploadUserInfo(userMap);
        HelperFunctions.saveUserLoggedInSharedPreferences(true);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => ChatRoom()));
      });
    }
  }

//ui
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarMain(context),
        body: isLoading ?
        const Center(
          child: CircularProgressIndicator(),
        ) :
        SingleChildScrollView(
            child: Container(
              height: MediaQuery
                  .of(context)
                  .size
                  .height - 100,
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Form(
                      key: formKey,
                      child: Column(
                        children: [
                          TextFormField(
                              validator: (val) {
                                return val!.isEmpty || val.length < 2
                                    ? "Please provide valid username"
                                    : null;
                              },
                              controller: userNameTextEditingController,
                              style: simpleTextStyle(),
                              decoration: textFieldInputDecoration("username")),
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
                              validator: (val) {
                                return val!.length > 6
                                    ? null
                                    : "Provide password 6+ characters";
                              },
                              obscureText: true,
                              controller: passwordEditingController,
                              style: simpleTextStyle(),
                              decoration: textFieldInputDecoration("password")),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () {
                        signMeUp();
                      },
                      child: Container(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                            gradient: const LinearGradient(
                                colors: [Color(0xff007EF4), Color(0xff2A75BC)]),
                            borderRadius: BorderRadius.circular(30.0)),
                        child: Text("Sign up", style: mediumTextStyle()),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30.0)),
                      child: const Text(
                        "Sign up With Google",
                        style: TextStyle(color: Colors.black, fontSize: 17),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                            "Already have an account,", style: mediumTextStyle()),
                        GestureDetector(
                          onTap: (){
                            widget.toogle();
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 17),
                            child: const Text("Sign in",
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
            )));
  }
}
