import 'package:chatapp/Views/chatroom.dart';
import 'package:chatapp/helper/helperfunction.dart';
import 'package:chatapp/services/auth.dart';
import 'package:chatapp/services/database.dart';
import 'package:flutter/material.dart';
import 'package:chatapp/Widgets/widget.dart';

class SignUp extends StatefulWidget {
  final Function toggleView;
  SignUp(this.toggleView);
  //const SignUp({Key key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  final formKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  AuthMethods authmethods = new AuthMethods();
  DatabaseMethods databaseMethods= new DatabaseMethods();

  void signMeUp() async {
    if (formKey.currentState.validate()) {
      Map<String,String> userInfoMap = {
        "name":usernameController.text,
        "email":emailController.text,
      };
      HelperFunctions.saveUserEmailSharedPreference(emailController.text);
      HelperFunctions.saveUserNameSharedPreference(usernameController.text);
      setState(() {
        isLoading = true;
      });

      authmethods.signUpWithEmailAndPassword(
          emailController.text, passwordController.text).then((val) {
        //print("${val.uid}");

        databaseMethods.uploadUserInfo(userInfoMap);
        HelperFunctions.saveUserLoggedInSharedPreference(true);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => ChatRoom()));
      });
    }

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: isLoading?Container(child: Center(child: CircularProgressIndicator(),),):SingleChildScrollView(
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
                    key: formKey,
                      child: Column(
                      children: [
                      TextFormField(
                        validator: (val){
                          return val.isEmpty || val.length < 3 ? "Enter Username 3+ characters" : null;
                        },
                        controller: usernameController,
                        decoration: textFieldDecoration("Username"),
                        style: simpleTextStyle(),
                      ),
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
                  )),
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
                       signMeUp();
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.symmetric(vertical: 20),
                      decoration: BoxDecoration(
                          color: Colors.green[800],
                          borderRadius: BorderRadius.circular(30)
                      ),
                      child: Text("Sign Up",style: TextStyle(
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
                    child: Text("Sign Up with Google",style: TextStyle(
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
                      Text("Already have an account? ",style: simpleTextStyle(),),
                      GestureDetector(
                          onTap: () {
                            widget.toggleView();
                          },
                          child: Text("Log In now",style: TextStyle(color: Colors.white,fontSize: 17,decoration: TextDecoration.underline),)),
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
