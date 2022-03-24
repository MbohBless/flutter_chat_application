import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:untitled/helper/constants.dart';
import 'package:untitled/services/database.dart';
import 'package:untitled/views/conversations.dart';
import 'package:untitled/widgets/widget.dart';

import '../helper/helper_functions.dart';

class SearchScreen extends StatefulWidget {
  @override
  State createState() => _SearchScreenState();
}

String? _myName="hello";

class _SearchScreenState extends State<SearchScreen> {
  DatabaseMethods databaseMethods = DatabaseMethods();
  TextEditingController searchEditingEditingController =
      TextEditingController();
  QuerySnapshot? searchSnapshot;

  Widget searchList() {
    return searchSnapshot != null
        ? ListView.builder(
            itemCount: searchSnapshot!.docs.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return SearchTile(
                  userName: searchSnapshot!.docs[index].get("name"),
                  userEmail: searchSnapshot!.docs[index].get("email"));
            },
          )
        : Container();
  }

  initiateSearch() {
    databaseMethods
        .getUsersByUsername(searchEditingEditingController.text)
        .then((val) {
      setState(() {
        searchSnapshot = val;
      });
    });
  }

//create chat Room, send user to conversation screen
  createChatRoomAndStartConversation({required String username}) {
    print(username);
    if (username!= _myName) {
      String chatRoomId = getChatRoomId(username,_myName!);
      List<String> users = [username,_myName!];
      Map<String, dynamic> chatRoomMap = {
        "users": users,
        "chatroomId": chatRoomId
      };
      DatabaseMethods().createChatRoom(chatRoomId, chatRoomMap);
      Navigator.push(context,
          MaterialPageRoute(builder: (context) =>  ConversationScreen(chatRoomId: chatRoomId,)));
    } else {
      print("You cannot send message to yourself");
    }
  }

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  getUserInfo() async {
    _myName = await HelperFunctions.getUsernameSharedPreferences();
    setState(() {

    });
    print("$_myName");
  }

  Widget SearchTile({required String userName, required String userEmail}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                style: mediumTextStyle(),
              ),
              Text(
                userEmail,
                style: mediumTextStyle(),
              )
            ],
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {
              createChatRoomAndStartConversation(username: userName);
            },
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(30)),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Text(
                "Message",
                style: mediumTextStyle(),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: Container(
        child: Column(
          children: [
            Container(
              color: const Color(0x54FFFFFF),
              padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 16),
              child: Row(children: [
                Expanded(
                  child: TextField(
                    controller: searchEditingEditingController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                        hintText: "Search Username....",
                        hintStyle: TextStyle(color: Colors.white54),
                        border: InputBorder.none),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    initiateSearch();
                  },
                  child: Container(
                      height: 45,
                      width: 45,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          gradient: const LinearGradient(
                              colors: [Colors.white10, Colors.white24]),
                          borderRadius: BorderRadius.circular(40)),
                      child: Image.asset(
                        "assets/images/search.png",
                        color: Colors.white,
                      )),
                )
              ]),
            ),
            searchList()
          ],
        ),
      ),
    );
  }
}

getChatRoomId(String a, String b) {
  if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
    return "$b\_$a";
  } else {
    return "$a\_$b";
  }
}
