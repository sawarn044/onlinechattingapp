import 'package:chatapp/Widgets/widget.dart';
import 'package:chatapp/helper/helperfunction.dart';
import 'package:chatapp/services/auth.dart';
import 'package:chatapp/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'chatroom.dart';

class SignIn extends StatefulWidget {
 // const SignIn({Key key}) : super(key: key);
  final Function toggleView;
  SignIn(this.toggleView);
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  @override
  final formkey = GlobalKey<FormState>();
  AuthMethods authMethods=new AuthMethods();
  DatabaseMethods databaseMethods=new DatabaseMethods();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  bool isLoading=false;
  QuerySnapshot snapshotUserInfo;

  signIn(){
    if(formkey.currentState.validate()){
      HelperFunctions.saveUserEmailSharedPreference(emailController.text);

      setState(() {
        isLoading=true;
      });
      databaseMethods.getUserByEmail(emailController.text).then(
          (val){
            snapshotUserInfo=val;
            HelperFunctions.saveUserEmailSharedPreference(snapshotUserInfo.docs[0]["name"]);
          }
      );
      authMethods.signInWithEmailAndPassword(emailController.text, passwordController.text).then((val) {
        if(val!=null){

          HelperFunctions.saveUserLoggedInSharedPreference(true);
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => ChatRoom()));
        }
      });

    }
  }


  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.bottomCenter,
          height: MediaQuery.of(context).size.height-50,
          child: Container(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Form(
                    key: formkey,
                    child: Column(
                      children: [
                        TextFormField(
                          validator: (val){
                            return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val) ?
                            null : "Enter correct email";
                          },
                          controller: emailController,
                          decoration: textFieldDecoration("email"),
                          style: simpleTextStyle(),
                        ),
                        TextFormField(
                          validator:  (val){
                            return val.length < 6 ? "Enter Password 6+ characters" : null;
                          },
                          obscureText: true,
                          controller: passwordController,
                          decoration: textFieldDecoration("password"),
                          style: simpleTextStyle(),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Text("Forgot Password ?",style: simpleTextStyle(),),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  GestureDetector(
                    onTap: (){
                      signIn();
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.symmetric(vertical: 20),
                      decoration: BoxDecoration(
                        color: Colors.green[800],
                        borderRadius: BorderRadius.circular(30)
                      ),
                      child: Text("Sign In",style: TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                      ),),

                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30)
                    ),
                    child: Text("Sign In with Google",style: TextStyle(
                      color: Colors.black,
                      fontSize: 17,
                    ),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have an account? ",style: simpleTextStyle(),),
                      GestureDetector(
                          onTap: () {
                            widget.toggleView();
                          },
                          child: Text("Register now",style: TextStyle(color: Colors.white,fontSize: 17,decoration: TextDecoration.underline),)),
                    ],
                  ),
                  SizedBox(
                    height: 100,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
