import 'package:flutter/material.dart';

Widget appBarMain(BuildContext context){
  return AppBar(
    title: Image.asset("assets/images/whatsapp.png",height: 40,),
    elevation: 0,
      centerTitle: false,
  );
}

InputDecoration textFieldDecoration(String hintText){
  return InputDecoration(
    hintText: hintText,
    hintStyle: TextStyle(
      color: Colors.white54,
    ),
      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
  );
}

TextStyle simpleTextStyle(){
  return TextStyle(color: Colors.white,fontSize: 16);
}
TextStyle mediumTextStyle(){
  return TextStyle(color: Colors.white,fontSize: 17);
}