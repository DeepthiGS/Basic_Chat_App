import 'package:chatappa/Widgets/widgets.dart';
import 'package:chatappa/helpers/app_constants.dart';
import 'package:chatappa/helpers/names.dart';
import 'package:chatappa/screens/dart/conversationScreen.dart';
import 'package:chatappa/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// ignore: camel_case_types
class searchScreen extends StatefulWidget {
  @override
  _searchScreenState createState() => _searchScreenState();
}

class _searchScreenState extends State<searchScreen> {


  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController searchUserTextEdititngController = new TextEditingController();

  QuerySnapshot searchSnapshot;


  Widget searchList(){
    return searchSnapshot != null ?ListView.builder(
        shrinkWrap: true,
        itemCount: searchSnapshot.documents.length ,
        itemBuilder: (context,index){
          return SearchBox(
            userName: searchSnapshot.documents[index].data["name"],
            userEmail: searchSnapshot.documents[index].data["email"],
          );
        }): Container();
  }
//  defining the initiate search funciton here
  initiateSearch() {
     databaseMethods.getUsersByUserName(searchUserTextEdititngController.text)
        .then((val){
      setState(() {
        searchSnapshot = val;
      });
    });
  }



  CreateRoomAndConvo({String userName}){
    if(userName != Constant.myName){

    String chatRoomId = getChatRoomId(Constant.myName,userName);
    List<String> users = [userName,Constant.myName];
    Map<String, dynamic> ChatRoomMap = {
      "users": users,
      "chatRoomId" : chatRoomId,
    };

    DatabaseMethods().createChatRoom(chatRoomId, ChatRoomMap);

    Navigator.push(context, MaterialPageRoute(
        builder: (context) => ChatScreen(chatRoomId)));
    }
    else{
    print("you cannot send message to yourself  !!!");
    }
  }


 Widget SearchBox({String userName,String userEmail}){
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24,vertical: 16 ),
        child: Row(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(userName,style: TextStyle(
                    color: Colors.black,
                    fontSize: 12),),
                Text(userEmail,style: TextStyle(
                    color: Colors.black,
                    fontSize: 13),)
              ],
            ),
            Spacer(),
            GestureDetector(
              onTap: (){
                CreateRoomAndConvo(userName:userName);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: AppConstants.hexToColor(AppConstants.APP_PRIMARY_COLOR_ACTION),
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: EdgeInsets.symmetric(horizontal: 12,vertical:12 ),
                child: Text("Message",style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),),
              ),
            ),
          ],
        ),
      ),
    );
 }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search here.."),),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              color: AppConstants.hexToColor(AppConstants.APP_BACKGROUND_COLOR_GRAY ),
              padding: EdgeInsets.symmetric(horizontal :24,vertical: 8),
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: TextField(
                        controller: searchUserTextEdititngController,
                        style: TextStyle(
                          color:Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 20
                        ),
                        decoration: InputDecoration(
                          hintText: "Search userName..",
                          hintStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 14
                          ),
                          border: InputBorder.none,
                        ),
                      )),
                  GestureDetector(
                    onTap: (){
                      initiateSearch();
                    },
                    child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors:[Color(0x50FFFFFF),Color(0x70FFFFFF)],
                          ),
                          borderRadius: BorderRadius.circular(40),
                        ),
                        padding: EdgeInsets.all(10),
                        child: Image.asset("assests/images/search_white.png")),
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

//Condition
getChatRoomId(String a, String b) {
  if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
    return "$b\_$a";
  } else {
    return "$a\_$b";
  }
}