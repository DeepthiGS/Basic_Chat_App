import 'package:chatappa/Widgets/widgets.dart';
import 'package:chatappa/helpers/app_constants.dart';
import 'package:chatappa/helpers/names.dart';
import 'package:chatappa/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class ChatScreen extends StatefulWidget {


  final String chatRoomId;
  ChatScreen(this.chatRoomId);


  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {


  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController messageController = new TextEditingController();

  Stream chatMessagesStream;

  Widget ChatMessageList() {
    return StreamBuilder(
      stream: chatMessagesStream,
      builder: (context, snapshot)
      {
        return snapshot.hasData ?  ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index){
//          we are creating a  tile that is small bar of the incoming and outgoing message at the bottom at the end
              return MessageTile(
                snapshot.data.documents[index].data["message"],
                snapshot.data.documents[index].data["sendBy"]==Constant.myName,
              );
            }) : Container();
      },
    );
  }

  sendMessage() {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        "sendBy": Constant.myName,
        "message": messageController.text,
        "time":DateTime.now().millisecondsSinceEpoch,

      };


      databaseMethods.addConversationMessages(widget.chatRoomId, messageMap);
//      after we have sent the message the messge bar should be cleared
      messageController.text="";
    }
  }

  @override
  void initState() {
//    for calling the method from another dart file we willhave to first initiate a object which we have already done now we will call by firrst the name .me5ho
    databaseMethods.getConversationMessages(widget.chatRoomId).then((value){
      setState(() {
        chatMessagesStream = value;
      });
    });
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chats"),
      ),
      body: Container(
        child: Stack(
          children: <Widget>[
            ChatMessageList(),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
        color: Colors.grey[200],
        padding: EdgeInsets.symmetric(horizontal :5,vertical: 8),
        child: Row(
          children: <Widget>[
        RawMaterialButton(
                onPressed: (){
                  AlertDialog(
                    title: Text("To be Updated.."),
                    content: Text("Sending image will be enables in next version"),
                    actions: <Widget>[
                      FlatButton(
                        onPressed:()=>Navigator.pop(context),
                        child: Text("OK"),
                      )
                    ],
                  );
                },
                  padding: EdgeInsets.all(12.0),
                  child: Icon(
                   Icons.camera_alt,
                    color: Colors.white,
                     size: 25.0,
                      ),
                     shape: CircleBorder(),
                     elevation: 3.0,
                     fillColor: Theme.of(context).primaryColor,
                  ),
              Expanded(
                   child: TextField(
                     controller: messageController,
                      decoration: InputDecoration(
                       border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                     Radius.circular(10.0),
                        ),
                        ),
                      hintText: 'Type your message...',
                     filled: true,
                        hintStyle: TextStyle(color: Colors.grey[600]),
                           ),
                       ),
                     ),
              GestureDetector(
                      onTap: (){
                        sendMessage();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                            height: 47,
                            width: 47,
                            decoration: BoxDecoration(
                              color: AppConstants.hexToColor(AppConstants.APP_PRIMARY_COLOR),
                              borderRadius: BorderRadius.circular(40),
                            ),
                            padding: EdgeInsets.all(10),
                            child: Image.asset("assests/images/send.png")
                        ),
                      ),
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

//  entire messages decoration and all the stuff
class MessageTile extends StatelessWidget {

  final String message;
  final bool isSendByMe;
  MessageTile(this.message,this.isSendByMe);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          left: isSendByMe ? 0 : 20,
          right: isSendByMe ? 20 : 0),
      margin: EdgeInsets.symmetric(vertical: 8),
      width: MediaQuery.of(context).size.width,
      alignment: isSendByMe?Alignment.centerRight:Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 18,vertical: 15),
        decoration: BoxDecoration(
            color: isSendByMe? AppConstants.hexToColor(AppConstants.APP_PRIMARY_COLOR_ACTION)
                :AppConstants.hexToColor(AppConstants.APP_PRIMARY_FONT_COLOR_WHITE),
          borderRadius: isSendByMe ? BorderRadius.only(
              topLeft: Radius.circular(23),
              topRight: Radius.circular(23),
              bottomLeft: Radius.circular(23)
          ) :
          BorderRadius.only(
              topLeft: Radius.circular(23),
              topRight: Radius.circular(23),
              bottomRight: Radius.circular(23)),
        ),
        child: Text(message,style:  TextStyle(
          color: isSendByMe? Colors.white : Colors.black,
          fontSize: 15,
        ),),
      ),
    );
  }
}


