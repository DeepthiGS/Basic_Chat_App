import 'package:chatappa/Widgets/widgets.dart';
import 'package:chatappa/helpers/app_constants.dart';
import 'package:chatappa/helpers/helperfunctions.dart';
import 'package:chatappa/screens/dart/signup.dart';
import 'package:chatappa/services/auth.dart';
import 'package:chatappa/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';

import 'chatrooms.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}


class _SignInState extends State<SignIn> {
  int _selectedIndex = 0 ;


  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  bool isLoading=false;
  QuerySnapshot snapshotUserInfo;

  final formkey = GlobalKey<FormState>();

  TextEditingController userEmailTextEditingController = new TextEditingController();
  TextEditingController userPasswordTextEditingController = new TextEditingController();



  _submit () async {
    try {
      if
      (_selectedIndex == 0 && formkey.currentState.validate()) {
        HelperFunctions.saveUserEmailSharedPreferrence(userEmailTextEditingController.text);
        formkey.currentState.save();
        setState(() {
          isLoading =true;
        });
        databaseMethods.getUsersByEmail(userEmailTextEditingController.text).then((value) {
          snapshotUserInfo = value;
          HelperFunctions.
          saveUserNameSharedPreferrence(snapshotUserInfo.documents[0].data["name"]);
        });
        await
        authMethods.SignInwithEmailAndPasswrord(
            userEmailTextEditingController.text,
            userPasswordTextEditingController.text).then((val){

          HelperFunctions.saveuserLoggedInSharedPreferrence(true);
              Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (context) => ChatRooms()
              ));
        });
      }
    }
    on PlatformException catch (error) {
      _showErrorDialog(error.message);
    }
  }


  _showErrorDialog ( String errorMessage)   {
    showDialog (context : context ,
      builder : (_)   {
        return AlertDialog (
          title : Text ( 'Error' ) ,
          content : Text (errorMessage) ,
          actions : < Widget > [
            FlatButton (
                onPressed : () => Navigator.pushReplacement(context, MaterialPageRoute(
                    builder: (context)=>SignIn()
                )) ,
                child : Text ( 'OK' )),
          ] ,
        ) ;
      } ,
    ) ;
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24) ,
          height: MediaQuery.of(context).size.height,
          child: Column(
//          this has taken the text within the column in center
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Welcome!',
                  style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.w600)),
              const SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  width: 130.0,

                  child: FlatButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),),
                    color: _selectedIndex == 0? AppConstants.hexToColor(AppConstants.APP_PRIMARY_COLOR):Colors.grey[300],

                    child: Text("Sign In",style: TextStyle(fontSize:20,
                      color:_selectedIndex ==0 ? Colors.white : AppConstants.hexToColor(AppConstants.APP_PRIMARY_COLOR),),
                    ),
                    onPressed: (){
                      setState(() {
                        _selectedIndex = 0 ;
                      });
                    },
                  ),

                ),
                Container(
                  width: 130,
                  child: FlatButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),),
                    color: _selectedIndex == 1? AppConstants.hexToColor(AppConstants.APP_PRIMARY_COLOR):Colors.grey[300],

                    child: Text("Sign Up",
                        style: TextStyle(fontSize:20, color:_selectedIndex ==1 ? Colors.white : AppConstants.hexToColor(AppConstants.APP_PRIMARY_COLOR),)
                    ),
                    onPressed: (){
                      setState(() {
                        _selectedIndex = 1;
                      });
                      Navigator.pushReplacement(context, MaterialPageRoute(
                          builder: (context) => SignUp()
                      ));
                    },
                  ),
                ),
              ],
            ),

              Form(
                    key: formkey,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                            validator: (val){
                              return RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(val) ? null: "Please provide a valid email Id ";
                            },
                            controller: userEmailTextEditingController,
                            decoration: textFieldInputDecoration("email")
                        ),
                        TextFormField(
                          obscureText: true,
                          validator: (val){
                            return val.length >6 ? null : "Password length should be greater than 6" ;
                          },
                          controller: userPasswordTextEditingController,
                          decoration: textFieldInputDecoration("password"),
                        ),
                      ],
                    ),
                  ),

              const SizedBox(height: 20.0),

              Container(
                width: MediaQuery.of(context).size.width,
                child: FlatButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  color: AppConstants.hexToColor(AppConstants.APP_PRIMARY_COLOR),
                  child: Text("Submit",style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),),
                  onPressed: (){
                    _submit();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
