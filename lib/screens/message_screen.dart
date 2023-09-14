import 'package:btsverse/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/message_bubble.dart';

class MessageScreen extends StatefulWidget {
  final String recipientId;

  MessageScreen({required this.recipientId});

  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  TextEditingController messageController = TextEditingController();
  late String currentUserId;
  late String recipientUsername;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    fetchRecipientUsername();
  }

  void getCurrentUser() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        currentUserId = user.uid;
      });
    }
  }

  Future<void> fetchRecipientUsername() async {
    DocumentSnapshot recipientSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.recipientId)
        .get();

    if (recipientSnapshot.exists) {
      setState(() {
        recipientUsername = recipientSnapshot['username'];
        isLoading = false;
      });
    } else {
      setState(() {
        recipientUsername = 'Unknown User';
        isLoading = false;
      });
    }
  }

  void sendMessage() async {
    String messageText = messageController.text.trim();
    if (messageText.isNotEmpty) {
      Message message = Message(
        senderId: currentUserId,
        recipientId: widget.recipientId,
        text: messageText,
        timestamp: Timestamp.now(),
      );

      CollectionReference messagesRef =
          FirebaseFirestore.instance.collection('messages');

      await messagesRef.add(message.toMap());

      messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              primaryColor,
              secondaryColor,
              purple,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomRight,
          ),
        ),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                primaryColor,
                secondaryColor,
                purple,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomRight,
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
              child: CircularProgressIndicator(
                color: purple,
              ),
            ),
          ),
        ),
      );
    }

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            primaryColor,
            secondaryColor,
            purple,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomRight,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          backgroundColor: purple,
          title: Text(
            'Chat with $recipientUsername',
            style:
                TextStyle(color: Colors.white, fontFamily: 'Sen', fontSize: 15),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('messages')
                    .where('senderId', isEqualTo: currentUserId)
                    .where('recipientId', isEqualTo: widget.recipientId)
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: purple,
                      ),
                    );
                  }

                  List<QueryDocumentSnapshot> sentDocs = snapshot.data!.docs;
                  List<Message> sentMessages = sentDocs
                      .map((doc) =>
                          Message.fromMap(doc.data() as Map<String, dynamic>))
                      .toList();

                  return StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('messages')
                        .where('senderId', isEqualTo: widget.recipientId)
                        .where('recipientId', isEqualTo: currentUserId)
                        .orderBy('timestamp', descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: purple,
                          ),
                        );
                      }

                      List<QueryDocumentSnapshot> receivedDocs =
                          snapshot.data!.docs;
                      List<Message> receivedMessages = receivedDocs
                          .map((doc) => Message.fromMap(
                              doc.data() as Map<String, dynamic>))
                          .toList();

                      List<Message> allMessages = [
                        ...sentMessages,
                        ...receivedMessages
                      ];
                      allMessages
                          .sort((a, b) => b.timestamp.compareTo(a.timestamp));

                      return ListView.builder(
                        reverse: true,
                        itemCount: allMessages.length,
                        itemBuilder: (context, index) {
                          Message message = allMessages[index];
                          bool isSentByCurrentUser =
                              message.senderId == currentUserId;

                          return MessageBubble(
                            sender:
                                isSentByCurrentUser ? 'You' : recipientUsername,
                            text: message.text,
                            isMe: isSentByCurrentUser,
                            time: message.timestamp,
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      style: TextStyle(color: Colors.white, fontFamily: 'Sen'),
                      controller: messageController,
                      decoration: InputDecoration(
                        hintText: 'Type your message...',
                        hintStyle:
                            TextStyle(color: Colors.white54, fontFamily: 'Sen'),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send),
                    onPressed: sendMessage,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Message {
  final String senderId;
  final String recipientId;
  final String text;
  final Timestamp timestamp;

  Message({
    required this.senderId,
    required this.recipientId,
    required this.text,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'recipientId': recipientId,
      'text': text,
      'timestamp': timestamp,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      senderId: map['senderId'],
      recipientId: map['recipientId'],
      text: map['text'],
      timestamp: map['timestamp'],
    );
  }
}
