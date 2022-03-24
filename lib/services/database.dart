import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  getUsersByUsername(String username) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where("name", isEqualTo: username)
        .get();
  }

  getUserByEmail(String email) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: email)
        .get();
  }

  uploadUserInfo(userMap) {
    FirebaseFirestore.instance.collection("users").add(userMap);
  }

  createChatRoom(String chatRoomId, chatRoomMap) {
    FirebaseFirestore.instance
        .collection("chatroom")
        .doc(chatRoomId)
        .set(chatRoomMap)
        .catchError((e) {});
  }

  addConversationMessages(String chatRoomId, messageMap) {
    FirebaseFirestore.instance
        .collection("chatroom")
        .doc(chatRoomId)
        .collection("chats")
        .add(messageMap)
        .catchError((e) {
      print(e.toString());
    });
  }
  getConversationMessages(String chatRoomId) async{
   return await FirebaseFirestore.instance
        .collection("chatroom")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy("time",descending: false)
        .snapshots();
  }
  getChatRooms(String username)async{
    return await FirebaseFirestore.instance.collection("chatroom")
        .where("users",arrayContains: username)
        .snapshots();
  }
}
