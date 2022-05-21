import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
final _firestore = FirebaseFirestore.instance;
late User signedInUser;

class ChatScreen extends StatefulWidget {

  static const screenRoute = 'chat';

  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class  _ChatScreenState extends State<ChatScreen> {
  final messageTextContrller = TextEditingController();
  final _auth = FirebaseAuth.instance;
String? messageText;
  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        signedInUser = user;
        print(signedInUser.email);
      }
    }
    catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Row(
          children: [
            SizedBox(width: 10),
            Text('RetroChat', style: TextStyle(color: Colors.green),),
          ],
        ),
        actions: [
          IconButton(onPressed: () {
            _auth.signOut();
            Navigator.pop(context);
                      }, icon: Icon(Icons.close,))
        ],
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            MessageStringBulider(),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                      color: Colors.black54,
                      width: 2
                  ),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(child: TextField(
                    controller: messageTextContrller,
                    onChanged: (value) {
                      messageText = value;
                    },
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 20,
                      ),
                      hintText: 'Write your message here...',
                      border: InputBorder.none,
                    ),
                  ),
                  ),
                  TextButton(
                    onPressed: () {
                      messageTextContrller.clear();
                     _firestore.collection('messages').add({
                       'text': messageText,
                       'sender': signedInUser.email,
                       'time' : FieldValue.serverTimestamp(),
                     });
                    },
                    child: Text(
                      'send', style: TextStyle(
                      color: Colors.black38,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
class MessageStringBulider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream:_firestore.collection('messages').orderBy('time').snapshots() ,
      builder: (context, snapshot){
        List<MessageLine> messageWidgets = [];
        if (!snapshot.hasData){
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.green,
            ),
          );
        }
        final messages = snapshot.data!.docs.reversed;
        for(var message in messages){
          final messageText = message.get('text');
          final messageSender = message.get('sender');
          final currentUser = signedInUser.email;

          final messageWidget =MessageLine(sender: messageSender,text: messageText,
          isMe: currentUser == messageSender,);
          messageWidgets.add(messageWidget);
        }

        return Expanded(
          child: ListView(
            reverse: true,
            padding: EdgeInsets.symmetric(horizontal: 10,vertical: 20),
            children: messageWidgets,
          ),
        );
      },
    );
  }
}

class MessageLine extends StatelessWidget {
  final String? sender;
  final String? text;
  final bool isMe;

  const MessageLine({this.text, this.sender,required this.isMe}) ;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,

        children: [
          Text('$sender', style: TextStyle(fontSize: 12,color: Colors.black54),),
          Material(
            borderRadius: isMe ?BorderRadius.only(
            topLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
              bottomLeft: Radius.circular(20),
            ) :BorderRadius.only(
              topRight: Radius.circular(20),
              bottomRight: Radius.circular(20),
              bottomLeft: Radius.circular(20),
            ) ,
            color: isMe ? Colors.green :Colors.black ,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 20),
              child: Text('$text - $sender',
                style: TextStyle(fontSize: 18,color: isMe ? Colors.white : Colors.white),),
            ),
          ),
        ],
      ),
    );
  }
}