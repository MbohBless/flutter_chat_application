import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled/services/database.dart';

import '../helper/helper_functions.dart';
import '../widgets/widget.dart';

class ConversationScreen extends StatefulWidget {
  final String chatRoomId;

  ConversationScreen({required this.chatRoomId});

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

String? _myName;

class _ConversationScreenState extends State<ConversationScreen> {
  DatabaseMethods databaseMethods = DatabaseMethods();
  TextEditingController messageController = TextEditingController();
  Stream<QuerySnapshot>? chats;

  getUserInfo() async {
    _myName = await HelperFunctions.getUsernameSharedPreferences();
    setState(() {});
  }

  sendMessage() {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        "message": messageController.text,
        "sentBy": _myName!,
        "time": DateTime
            .now()
            .microsecondsSinceEpoch
      };
      databaseMethods.addConversationMessages(widget.chatRoomId, messageMap);
      messageController.text = "";
    }
  }

  @override
  void initState() {
    getUserInfo();
    databaseMethods.getConversationMessages(widget.chatRoomId).then((val) {
      setState(() {
        chats = val!;
      });
    });
    super.initState();
  }

  Widget ChatMessageList() {
    return StreamBuilder(
        stream: chats,
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          return snapshot.hasData
              ? ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                return MessageTile(
                    message: snapshot.data!.docs[index].get("message"),
                    isSentByMe: snapshot.data!.docs[index].get("sentBy") ==
                        _myName);
              })
              : Container();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: Container(
        child: Stack(
          children: [
            ChatMessageList(),
            Container(
              alignment: Alignment.bottomCenter,
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              child: Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                color: const Color(0x54FFFFFF),
                child: Row(
                  children: [
                    Expanded(
                        child: TextField(
                          controller: messageController,
                          style: simpleTextStyle(),
                          decoration: const InputDecoration(
                              hintText: "Message ...",
                              hintStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                              border: InputBorder.none),
                        )),
                    const SizedBox(
                      width: 16,
                    ),
                    GestureDetector(
                      onTap: () {
                        sendMessage();
                      },
                      child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                  colors: [
                                    Color(0x36FFFFFF),
                                    Color(0x0FFFFFFF)
                                  ],
                                  begin: FractionalOffset.topLeft,
                                  end: FractionalOffset.bottomRight),
                              borderRadius: BorderRadius.circular(40)),
                          child: const Icon(
                            Icons.send,
                            color: Colors.white,
                          )),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool isSentByMe;

  MessageTile({required this.message, required this.isSentByMe});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:   EdgeInsets.only(
        top: 8,
        bottom: 8,
        left: isSentByMe ? 0 : 24,
        right: isSentByMe ? 24 : 0),
      margin: const EdgeInsets.symmetric(vertical: 8),
      width: MediaQuery
          .of(context)
          .size
          .width,
      alignment: isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: isSentByMe ? [
                  const Color(0xff007EF4),
                  const Color(0xff2A75BC)
                ] : [
                  const Color(0x1AFFFFFF),
                  const Color(0x1AFFFFFF),
                ]
            ),
            borderRadius: isSentByMe ?
            const BorderRadius.only(
              topLeft: Radius.circular(23),
              topRight: Radius.circular(23),
              bottomLeft: Radius.circular(23),

            ): const BorderRadius.only(
              topLeft: Radius.circular(23),
              topRight: Radius.circular(23),
              bottomRight: Radius.circular(23),
            )
        ),
        child: Text(message,
            style: const TextStyle(color: Colors.white, fontSize: 17)),
      ),
    );
  }
}
