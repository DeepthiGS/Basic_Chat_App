import 'package:chatappa/Widgets/widgets.dart';
import 'package:chatappa/helpers/app_constants.dart';
import 'package:chatappa/helpers/helperfunctions.dart';
import 'package:chatappa/screens/dart/signin.dart';
import 'package:chatappa/services/database.dart';
import "package:flutter/material.dart";
import 'package:chatappa/services/auth.dart';
import 'package:flutter/services.dart';

import 'chatrooms.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}



class _SignUpState extends State<SignUp> {

  int _selectedIndex = 1 ;

   AuthMethods authMethods = new AuthMethods();
   DatabaseMethods databaseMethods = new DatabaseMethods();

   bool isLoading=false;

  final formkey = GlobalKey<FormState>();
  TextEditingController userNameTextEditingController = new TextEditingController();
  TextEditingController userEmailTextEditingController = new TextEditingController();
  TextEditingController userPasswordTextEditingController = new TextEditingController();

  SignMeUp(){
    if(formkey.currentState.validate()){
      setState(() {
        isLoading =true;
      });
    }
  }

  _submit () async {
    try {
//      SET STATE  IS ZERO THEN  NAVIGARTE TO SIGNIN
      if
      (_selectedIndex == 1 && formkey.currentState.validate()) {
        formkey.currentState.save();
        await
        authMethods.signup(userNameTextEditingController.text,
            userEmailTextEditingController.text,
            userPasswordTextEditingController.text).then((val){
          Map<String , String> userInfoMap = {
            "name": userNameTextEditingController.text,
            "email": userEmailTextEditingController.text,
          };
          HelperFunctions.saveUserEmailSharedPreferrence(userEmailTextEditingController.text);
          HelperFunctions.saveUserNameSharedPreferrence(userNameTextEditingController.text);

          databaseMethods.uploadUserInfo(userInfoMap);
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
                  builder: (context)=>SignUp()
                )) ,
                child : Text ( 'OK' ))
          ] ,
        ) ;
       } ,
    );

  }


      @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading?Container(
          child: Center(child: CircularProgressIndicator()),
      ) : SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24) ,
          height: MediaQuery.of(context).size.height,
          child: Column(
////          this has taken the text within the column in center
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Welcome!',
                  style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.w600)),
              const SizedBox(height: 10.0),
//              signin and signup buttons
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
                        Navigator.pushReplacement(context, MaterialPageRoute(
                      builder: (context) => SignIn()
                    ));
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
                      },
                  ),
                  ),
                ],
              ),

//              textField
              Form(
                key: formkey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                    validator: (val){
                      return val.isEmpty || val.length < 4 ? "Please enter a valid username": null     ;
                    },
                    controller: userNameTextEditingController,
                    decoration: textFieldInputDecoration("username"),
                  ),
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
                    ),],
                ),
              ),
              const SizedBox(height: 20.0),

//              submit
              GestureDetector(
                child: Container(
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
                      SignMeUp();
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );;
  }
}
