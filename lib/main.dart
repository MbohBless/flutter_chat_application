import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:untitled/helper/authenticate.dart';
import 'package:untitled/helper/helper_functions.dart';
import 'package:untitled/views/chatroomscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
   bool? userIsLoggedIn;
  @override
  void initState() {
       getLoggedInState();
    super.initState();
  }
  getLoggedInState() async{
    await HelperFunctions.getUserLoggedInSharedPreferences().then((value) {
      setState(() {
        userIsLoggedIn=value!;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: const Color(0xff145c9e),
        scaffoldBackgroundColor: const Color(0xff1f1f1f),
        primarySwatch: Colors.blue,
      ),
      home:userIsLoggedIn==true ?const ChatRoom(): Authenticate()
    );
  }
}


