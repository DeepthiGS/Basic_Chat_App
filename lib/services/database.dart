import 'package:chatappa/helpers/names.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseMethods{


  getUsersByUserName(String userName)async{
    return await Firestore.instance.collection("users")
       .where("name",isEqualTo: userName)
       .getDocuments();
  }

  getUsersByEmail(String userEmail)async{
    return await Firestore.instance.collection("users")
        .where("email",isEqualTo: userEmail)
        .getDocuments();
  }

  uploadUserInfo(userMap){
    Firestore.instance.collection("users")
        .add(userMap).catchError((e) {
      print(e.toString());
    });
  }

createChatRoom(String ChatroomId,ChatRoomMap){
    Firestore.instance.collection("ChatRoom")
        .document(ChatroomId).setData(ChatRoomMap).catchError((e) {
      print(e.toString());
    });
}

  addConversationMessages(String ChatroomId,messageMap) async {
     await Firestore.instance.collection("ChatRoom").document(ChatroomId)
        .collection("chats").add(messageMap).catchError((e) {
      print(e.toString());
    });
}

  getConversationMessages(String ChatroomId) async {
     return await Firestore.instance.collection("ChatRoom").document(ChatroomId)
        .collection("chats")
         .orderBy("time",descending: false)
         .snapshots();
    }

getChatRooms(String userName) async{
    return await Firestore.instance.collection("ChatRoom")
        .where("users",arrayContains: userName).snapshots();
}

}




