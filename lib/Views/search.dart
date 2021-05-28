import 'package:chatapp/Views/conversation_screen.dart';
import 'package:chatapp/Widgets/widget.dart';
import 'package:chatapp/helper/constants.dart';
import 'package:chatapp/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class SerachScreen extends StatefulWidget {
  const SerachScreen({Key key}) : super(key: key);

  @override
  _SerachScreenState createState() => _SerachScreenState();
}

class _SerachScreenState extends State<SerachScreen> {

  TextEditingController searchEditingController =TextEditingController();
  DatabaseMethods databaseMethods= DatabaseMethods();
  QuerySnapshot searchSnapshot;

  initiateSearch(){
    databaseMethods.getUserByUsername(searchEditingController.text).then((val){
      setState(() {
        searchSnapshot=val;
      });
    });
  }

  createChatRoomAndStartConversation(String userName){
    if(userName!=Constants.myName){

    String chatRoomId = getChatRoomId(userName, Constants.myName);

    List<String> users=[userName,Constants.myName];
    Map<String,dynamic>chatRoomMap={
      "users":users,
      "chatroomId": chatRoomId,
    };
    DatabaseMethods().createChatRoom(chatRoomId, chatRoomMap);
    Navigator.push(context, MaterialPageRoute(builder: (context)=>ConversationScreen(chatRoomId: chatRoomId,)));
  }
    else print("Cant talk to self");
}

  Widget searchList(){
    return searchSnapshot!=null? ListView.builder(
      itemCount: searchSnapshot.docs.length,
        shrinkWrap: true,
        itemBuilder: (context,index){
        return SearchTile(
          userName: searchSnapshot.docs[index]["name"],
          userEmail: searchSnapshot.docs[index]["email"],
        );
        }
    ):Container();
  }

  Widget SearchTile({String userName,
  String userEmail}){
    print(userName.toString());
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
           Expanded(
             child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userName,
                    style:simpleTextStyle(),
                  ),
                  Text(
                    userEmail,
                    style: simpleTextStyle(),
                  )
                ],
              ),
           ),

          Spacer(),
          GestureDetector(
            onTap: (){
              createChatRoomAndStartConversation(userName);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12,vertical: 8),
              decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(24)
              ),
              child: Text("Message",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16
                ),),
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
       body:
      // isLoading ? Container(
      //   child: Center(
      //     child: CircularProgressIndicator(),
      //   ),
      // ) :
      Container(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              color: Color(0x54FFFFFF),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: searchEditingController,
                      style: simpleTextStyle(),
                      decoration: InputDecoration(
                          hintText: "search username ...",
                          hintStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                          border: InputBorder.none
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      initiateSearch();
                      },
                    child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [
                                  const Color(0x36FFFFFF),
                                  const Color(0x0FFFFFFF)
                                ],
                                begin: FractionalOffset.topLeft,
                                end: FractionalOffset.bottomRight
                            ),
                            borderRadius: BorderRadius.circular(40)
                        ),
                        padding: EdgeInsets.all(12),
                        child: Image.asset("assets/images/search_white.png",
                          height: 25, width: 25,)),
                  ),

                ],
              ),

            ),
            searchList(),
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

