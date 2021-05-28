import 'package:chatapp/Views/conversation_screen.dart';
import 'package:chatapp/Views/search.dart';
import 'package:chatapp/Widgets/widget.dart';
import 'package:chatapp/helper/constants.dart';
import 'package:chatapp/helper/helperfunction.dart';
import 'package:chatapp/services/auth.dart';
import 'package:chatapp/services/database.dart';
import 'package:flutter/material.dart';
import 'package:chatapp/helper/authenticate.dart';

class ChatRoom extends StatefulWidget {
  const ChatRoom({Key key}) : super(key: key);

  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  AuthMethods authMethods= new AuthMethods();
  DatabaseMethods databaseMethods= new DatabaseMethods();
  Stream chatRoomStream;

  Widget chatRoomList(){
    return StreamBuilder(
      stream: chatRoomStream,
      builder: (context,snapshot){
        return snapshot.hasData?ListView.builder(
            itemCount: snapshot.data.docs.length,
            itemBuilder: (context,index){
             return ChatRoomTile(
               userName: snapshot.data.docs[index].data()['chatRoomID']
               .toString().replaceAll("_", "").replaceAll(Constants.myName, ""),
               chatRoomId:snapshot.data.docs[index].data()["chatRoomID"] ,);
            }
        ):Container();
      }

    );
  }
  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  getUserInfo() async{
    Constants.myName= await HelperFunctions.getUserNameSharedPreference();
    databaseMethods.getChatRooms(Constants.myName).then((value) {
      setState(() {
        chatRoomStream = value;
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset("assets/images/whatsapp.png",height: 40,),
        elevation: 0,
        centerTitle: false,
        actions: [
          GestureDetector(
            onTap: (){
                 authMethods.signOut();
                 Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Authenticate()));
            },
            child: Container(
             padding: EdgeInsets.symmetric(horizontal: 16),
             child: Icon(Icons.exit_to_app)),
          ),
        ],
      ),
      body: chatRoomList(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>SerachScreen()));
        },
      ),
    );
  }
}
class ChatRoomTile extends StatelessWidget {
  //const ChatRoomTile({Key key}) : super(key: key);
  final String userName;
  final String chatRoomId;
  ChatRoomTile({this.userName,this.chatRoomId});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>ConversationScreen(chatRoomId: chatRoomId)));
      },
      child: Container(
        color: Colors.black,
        padding: EdgeInsets.symmetric(horizontal: 24,vertical: 16),
        child: Row(
          children: [
            Container(
              height: 40,
                width: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.lightGreen,
                borderRadius: BorderRadius.circular(40),
              ),
              child: Text(
                "${userName.substring(0,1).toUpperCase()}",
                style: mediumTextStyle(),
              ),
            ),
            SizedBox(width: 8,),
            Text(userName,style: mediumTextStyle(),)
          ],
        ),
      ),
    );
  }
}
