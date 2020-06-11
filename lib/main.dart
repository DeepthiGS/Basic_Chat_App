import 'package:chatappa/screens/dart/chatrooms.dart';
import 'package:chatappa/screens/dart/signin.dart';
import 'package:chatappa/screens/dart/signup.dart';
import 'package:flutter/material.dart';

import 'helpers/app_constants.dart';
import 'helpers/helperfunctions.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  bool userIsLoggedIn = false ;
  @override
  void initState() {
    getLoggedInState();
    super.initState();
  }

  getLoggedInState() async {
//    here the value is boolean value: we are creating it so tht we can put a condition and checck whether if this is null or we can show a container or even authenticate
    await HelperFunctions.getUserLoggedInSharedPreferrence().then((value){
      setState(() {
        print(value);
        userIsLoggedIn  = value;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
        primaryColor: AppConstants.hexToColor(AppConstants.APP_PRIMARY_COLOR),
        backgroundColor:
        AppConstants.hexToColor(AppConstants.APP_BACKGROUND_COLOR),
        primaryColorLight:
        AppConstants.hexToColor(AppConstants.APP_PRIMARY_COLOR_LIGHT),
        accentColor: Colors.black,
        accentIconTheme: IconThemeData(color: Colors.black),
        dividerColor: Colors.black12,
        textTheme: TextTheme(
          caption: TextStyle(color: Colors.white),
        ),
      ),
      home: userIsLoggedIn? ChatRooms() : SignUp(),
    );
  }
}









