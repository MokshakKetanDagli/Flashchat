import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../constants.dart';

class ChatScreen extends StatefulWidget {
  static String id = 'chat_screen';
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  String? email;
  bool isUserLoggedIn = true;
  String? messageData;
  TextEditingController myTextFieldController = TextEditingController();

  void getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        isUserLoggedIn = true;
        // print(user.email);
        setState(() {
          email = user.email!;
        });
      } else {
        isUserLoggedIn = false;
      }
    } catch (e) {
      print(e);
    }
  }

  // void getMessages() async {
  //   //final messages =
  //   await _firebaseFirestore.collection('messages').doc('doc').get();
  //   // for (var message in messages.data()!.values) {
  //   //   print(message);
  //   // }
  //   final listOfMessages = _firebaseFirestore
  //       .collection('messages')
  //       .get()
  //       .then((QuerySnapshot querySnapshot) {
  //     querySnapshot.docs.forEach((doc) {
  //       print(doc['message']);
  //     });
  //   });
  // }
  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Chat Screen'),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(gradient: myLinearGradient),
        ),
        actions: [
          isUserLoggedIn == true
              ? Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: IconButton(
                    onPressed: () {
                      _auth.signOut();
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Logged Out Successfully')));
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.logout,
                      size: 30,
                    ),
                  ),
                )
              : Text(''),
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.all(4.0),
        child: Column(
          children: [
            Expanded(
              flex: 8,
              child: StreamBuilder<QuerySnapshot>(
                stream: _firebaseFirestore.collection('messages').snapshots(),
                builder: (context, snapshots) {
                  List<MessageBox> messageBoxes = [];
                  if (snapshots.hasData) {
                    final messages = snapshots.data!.docs;
                    for (var message in messages) {
                      final messageText = message.get('message');
                      final messageSender = message.get('sender');
                      final currentUser = _auth.currentUser!.email;
                      final messageBox = MessageBox(
                        message: messageText,
                        sender: messageSender,
                        isMe: currentUser == messageSender,
                      );
                      messageBoxes.add(messageBox);
                    }
                  }
                  return ListView(
                    scrollDirection: Axis.vertical,
                    reverse: true,
                    padding: EdgeInsets.all(8.0),
                    children: messageBoxes,
                  );
                },
              ),
            ),
            Row(
              children: [
                Expanded(
                  flex: 8,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 15,
                      bottom: 4,
                      top: 4,
                      right: 0,
                    ),
                    child: TextField(
                      controller: myTextFieldController,
                      decoration: InputDecoration(
                        hintText: 'Type your message here ..',
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 3, horizontal: 8),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Colors.orange,
                          ),
                        ),
                        focusColor: Colors.orange,
                        hoverColor: Colors.orange,
                        fillColor: Colors.orange,
                      ),
                      onChanged: (messageValue) {
                        messageData = messageValue;
                      },
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.send,
                    color: Colors.orange,
                    size: 30,
                  ),
                  onPressed: () {
                    myTextFieldController.clear();
                    final senderMessageToCloud =
                        _firebaseFirestore.collection('messages').add(
                      {'message': messageData, 'sender': email},
                    );
                    senderMessageToCloud.whenComplete(
                      () => {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Message send from : $email'),
                          ),
                        )
                      },
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class MessageBox extends StatelessWidget {
  MessageBox({
    Key? key,
    required this.message,
    required this.sender,
    required this.isMe,
  }) : super(key: key);

  final String message;
  final String sender;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      alignment: isMe == true ? Alignment.centerRight : Alignment.centerLeft,
      widthFactor: 0.6,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: isMe == true
              ? BorderRadius.only(
                  topLeft: Radius.circular(25),
                  bottomLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25),
                )
              : BorderRadius.only(
                  bottomLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                  bottomRight: Radius.circular(25),
                ),
          color: isMe == true ? Colors.orange.shade100 : Colors.orange,
        ),
        width: 250,
        alignment: isMe == true ? Alignment.centerRight : Alignment.centerLeft,
        padding: EdgeInsets.symmetric(
          vertical: 5,
          horizontal: 10,
        ),
        margin: EdgeInsets.symmetric(vertical: 3),
        child: Column(
          children: [
            Align(
              alignment:
                  isMe == true ? Alignment.centerRight : Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3.0),
                child: Text(
                  sender,
                  style: TextStyle(
                    color: Colors.black54,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Container(
              padding: EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 10,
              ),
              width: 200,
              decoration: BoxDecoration(
                borderRadius: isMe == true
                    ? BorderRadius.only(
                        topLeft: Radius.circular(25),
                        bottomLeft: Radius.circular(25),
                        bottomRight: Radius.circular(25),
                      )
                    : BorderRadius.only(
                        bottomLeft: Radius.circular(25),
                        topRight: Radius.circular(25),
                        bottomRight: Radius.circular(25),
                      ),
                color: isMe == true ? Colors.orange : Colors.orange.shade100,
              ),
              child: Text(
                message,
                textAlign: isMe == true ? TextAlign.end : TextAlign.start,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
