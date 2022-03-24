import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:untitled/helper/authenticate.dart';
import 'package:untitled/helper/helper_functions.dart';
import 'package:untitled/services/auth.dart';
import 'package:untitled/services/database.dart';
import 'package:untitled/views/conversations.dart';
import 'package:untitled/views/search.dart';
import 'package:untitled/widgets/widget.dart';

class ChatRoom extends StatefulWidget {
  const ChatRoom({Key? key}) : super(key: key);

  @override
  State createState() => ChatState();
}

String? _myName;

class ChatState extends State<ChatRoom> {
  AuthMethods authMethods = AuthMethods();
  DatabaseMethods databaseMethods = DatabaseMethods();
  Stream<QuerySnapshot>? chatRooms;

  Widget chatRoomList() {
    return StreamBuilder(
      stream: chatRooms,
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  return ChatRoomTile(
                      userName: snapshot.data!.docs[index]
                          .get("chatroomId")
                          .toString()
                          .replaceAll("_", "")
                          .replaceAll(_myName!, ""),
                      chatRoomId: snapshot.data!.docs[index].get("chatroomId"));
                },
              )
            : Container();
      },
    );
  }

  @override
  void initState() {
    getUserInfo();

    super.initState();
  }

  getUserInfo() async {
    _myName = await HelperFunctions.getUsernameSharedPreferences();
    databaseMethods.getChatRooms(_myName!).then((val) {
      setState(() {
        chatRooms = val!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          "assets/images/logo.png",
          height: 20,
        ),
        actions: [
          GestureDetector(
            onTap: () {
              HelperFunctions.saveUserLoggedInSharedPreferences(false);
              authMethods.signOut();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => Authenticate()));
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: const Icon(Icons.exit_to_app),
            ),
          ),
        ],
      ),
      body: chatRoomList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => SearchScreen()));
        },
        child: const Icon(Icons.search),
      ),
    );
  }
}

class ChatRoomTile extends StatelessWidget {
  final String userName;
  final String chatRoomId;

  ChatRoomTile({Key? key, required this.userName, required this.chatRoomId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ConversationScreen(chatRoomId: chatRoomId)));
      },
      child: Container(
        color: Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(40)),
              child: Text(
                userName.substring(0, 1).toUpperCase(),
                style: mediumTextStyle(),
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Text(
              userName,
              style: mediumTextStyle(),
            )
          ],
        ),
      ),
    );
  }
}
