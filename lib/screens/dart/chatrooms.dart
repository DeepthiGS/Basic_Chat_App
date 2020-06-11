import 'package:chatappa/Widgets/widgets.dart';
import 'package:chatappa/helpers/app_constants.dart';
import 'package:chatappa/helpers/helperfunctions.dart';
import 'package:chatappa/helpers/names.dart';
import 'package:chatappa/screens/dart/searchscreen.dart';
import 'package:chatappa/screens/dart/signin.dart';
import 'package:chatappa/services/auth.dart';
import 'package:chatappa/services/database.dart';
import "package:flutter/material.dart";

import 'conversationScreen.dart';



class ChatRooms extends StatefulWidget {
  @override
  _ChatRoomsState createState() => _ChatRoomsState();
}

class _ChatRoomsState extends State<ChatRooms> {

  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  Stream chatRoomsStream;

  Widget chatRoomsList(){
    return StreamBuilder(
      stream: chatRoomsStream,
      builder: (context,snapshot){
        return snapshot.hasData ? ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context,index){
              return ChatRoomTile(
                snapshot.data.documents[index].data["chatRoomId"]
                    .toString().replaceAll("_", "").replaceAll(Constant.myName, ""),
                  snapshot.data.documents[index].data["chatRoomId"]
              );
            }): Container();
      },
    );
  }

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  getUserInfo()async{
    Constant.myName  = await HelperFunctions.getUserNameSharedPreferrence();
    databaseMethods.getChatRooms(Constant.myName).then((val){
      setState(() {
        print(val);
        chatRoomsStream = val;
      });
    });
 }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Let's Connect.."),
//        Image.asset("assests/images/ca_logo.png"),
        actions: <Widget>[
          GestureDetector(
            onTap:(){
              authMethods.Signout();
              Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (context) => SignIn()
              ));
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
                child: Icon(Icons.exit_to_app)),
          )
        ],
      ),
      body: chatRoomsList(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppConstants.hexToColor(AppConstants.APP_PRIMARY_COLOR),
        child: Icon(Icons.search),
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(
            builder: (context)=>  searchScreen()
          ));
        },
      ),
    );
  }
}


class ChatRoomTile extends StatelessWidget {

  final String userName;
  final String chatRoomId;
  ChatRoomTile(this.userName,this.chatRoomId);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
          builder: (context)=> ChatScreen(chatRoomId)
        ));
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppConstants.hexToColor(AppConstants.APP_PRIMARY_FONT_COLOR_WHITE),
        ),
        margin: EdgeInsets.symmetric(vertical: 8),
        padding: EdgeInsets.symmetric(horizontal:24,vertical: 10),
        child: Row(
          children: <Widget>[
            Container(
              height: 40,
              width: 40,
              alignment: Alignment.center,
//            this container can be sued to store the profile pic
              decoration: BoxDecoration(
                  color: AppConstants.hexToColor(AppConstants.APP_PRIMARY_COLOR_ACTION),
                   borderRadius: BorderRadius.circular(40)
              ),
              child: Text("${userName.substring(0,1).toUpperCase()}"),
            ),
            SizedBox(width: 8,),
            Text(userName,style: TextStyle(
              color:Colors.black54,
              fontSize: 17,
            ),)
          ],
        ),

      ),
    );
  }
}
