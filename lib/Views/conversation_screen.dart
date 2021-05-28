
import 'package:chatapp/Widgets/widget.dart';
import 'package:chatapp/helper/constants.dart';
import 'package:chatapp/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ConversationScreen extends StatefulWidget {
 // const ConversationScreen({Key key}) : super(key: key);
final String chatRoomId;
ConversationScreen({this.chatRoomId});
  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {

  DatabaseMethods databaseMethods= new DatabaseMethods();
  TextEditingController messageController= new TextEditingController();
  Stream chatMessageStream;

  Widget ChatMessageList(){
    return StreamBuilder(
      stream: chatMessageStream,
      builder: (context,snapshot){
        return snapshot.hasData?ListView.builder(
           itemCount: snapshot.data.docs.length,
            itemBuilder: (context,index){
               return MessageTile(
                 message:snapshot.data.docs[index].data()["message"],
                 isSendByMe: snapshot.data.docs[index].data()["sendBy"]==Constants.myName,
               );
            }
        ):Container();
      },
    );
  }

  sendMessage(){

    if(messageController.text.isNotEmpty) {

      Map<String,dynamic>messageMap={
        "message":messageController.text,
        "sendBy":Constants.myName,
        "time": DateTime.now().millisecondsSinceEpoch,
      };
      databaseMethods.addConversationMessage(widget.chatRoomId, messageMap);
      messageController.text="";
      }

  }

@override
  void initState() {
    databaseMethods.getConversationMessage(widget.chatRoomId).then((value){
    setState(() {
      chatMessageStream=value;
    });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: Container(
        child: Stack(
          children: [
            ChatMessageList(),
            //SizedBox(height: 10,),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                color: Color(0x54FFFFFF),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: messageController,
                        style: simpleTextStyle(),
                        decoration: InputDecoration(
                            hintText: "type message here ...",
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
                        sendMessage();
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
                          child: Image.asset("assets/images/send.png",
                            height: 25, width: 25,)),
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
  //const MessageTile({Key key}) : super(key: key);
  final String message;
  final bool isSendByMe;
  MessageTile({this.message,this.isSendByMe});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: isSendByMe?0:24,right: isSendByMe?24:0),
      margin: EdgeInsets.symmetric(vertical: 8),
      width: MediaQuery.of(context).size.width,
      alignment: isSendByMe?Alignment.centerRight:Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24,vertical: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isSendByMe?[Colors.green,Colors.lightGreen]:[Colors.grey,Colors.grey],
          ),
          borderRadius: isSendByMe?BorderRadius.only(
            topLeft: Radius.circular(23),
            topRight: Radius.circular(23),
            bottomLeft: Radius.circular(23)
          ):
              BorderRadius.only(
                  topLeft: Radius.circular(23),
                  topRight: Radius.circular(23),
                  bottomRight: Radius.circular(23)
              )
        ),
        child: Text(
          message,
          style: TextStyle(
          color: Colors.white,fontSize: 17,
        ),
        ),
      ),
    );
  }
}
