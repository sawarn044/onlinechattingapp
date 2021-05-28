import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
class DatabaseMethods{

  getUserByUsername(String username) async{
    return await FirebaseFirestore.instance.collection("users").where("name",isEqualTo: username).get();
  }
  getUserByEmail(String useremail) async{
    return await FirebaseFirestore.instance.collection("users").where("email",isEqualTo: useremail).get();
  }
  uploadUserInfo(userMap){
    FirebaseFirestore.instance.collection("users")
        .add(userMap);
  }
  createChatRoom(String chatRoomId,Map chatRoomMap){
    FirebaseFirestore.instance.collection("ChatRoom").doc(chatRoomId).set(chatRoomMap).
    catchError((e) {
      print(e.toString());
    });
  }
  addConversationMessage(String chatRoomID, messageMap){
    FirebaseFirestore.instance.collection("Chatroom").doc(chatRoomID).collection("chats").
    add(messageMap).catchError((e){
      print(e.toString());
    });
  }
  getConversationMessage(String chatRoomID)async{
    return await FirebaseFirestore.instance.collection("Chatroom").
    doc(chatRoomID).collection("chats").
    orderBy('time',descending: false).snapshots();
  }
  getChatRooms(String userName) async{
    return await FirebaseFirestore.instance.collection("ChatRoom").
    where("users",arrayContains: userName).snapshots();
  }
}