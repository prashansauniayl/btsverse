// ignore_for_file: await_only_futures, unnecessary_null_comparison, avoid_print

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/drawer.dart';

late User loggedInUser;
final _firestore = FirebaseFirestore.instance;

class KpopKrazies extends StatefulWidget {
  const KpopKrazies({Key? key}) : super(key: key);

  @override
  State<KpopKrazies> createState() => _KpopKraziesState();
}

class _KpopKraziesState extends State<KpopKrazies> {
  final messageTextController = TextEditingController();
  late String displayName;
  late String messageText;
  final _auth = FirebaseAuth.instance;
  late String username = '';

  @override
  void initState() {
    getCurrentUser();
    super.initState();
    username = '';
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser!;
      if (user != null) {
        loggedInUser = user;
        DocumentSnapshot snapshot =
            await _firestore.collection('users').doc(loggedInUser.uid).get();
        if (snapshot.exists) {
          setState(() {
            username = snapshot.get('username');
          });
        }
      }
    } catch (e) {
      print(e);
    }
  }

  void messagesStream() async {
    await for (var snapshot in _firestore.collection('kpop_chat').snapshots()) {
      for (var message in snapshot.docs) {
        print(message.data().cast());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.purple,
        ),
        backgroundColor: Colors.white,
        title: const Text(
          'K - P O P     K R A Z I E S',
          style: TextStyle(
            color: Colors.purple,
            fontSize: 14,
          ),
        ),
        centerTitle: true,
      ),
      drawer: const DrawerWidget(),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'images/k-pop.png'), // Replace with your own image
                fit: BoxFit.cover,
              ),
            ),
            child: BackdropFilter(
              filter:
                  ImageFilter.blur(sigmaX: 10, sigmaY: 10), // Add blur effect
              child: Container(
                color: Colors.white.withOpacity(
                    0.3), // Add opacity to achieve glassmorphism effect
              ),
            ),
          ),
          Theme(
            data: ThemeData(
              colorScheme:
                  ColorScheme.fromSwatch().copyWith(secondary: Colors.white),
            ),
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  MessagesStream(username: username),
                  Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Colors.purple, width: 2.0),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: TextField(
                            controller: messageTextController,
                            onChanged: (value) {
                              messageText = value;
                            },
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 20.0),
                              hintText: 'Type your message here...',
                              hintStyle: TextStyle(
                                fontFamily: 'Sen',
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            messageTextController.clear();
                            _firestore.collection('kpop_chat').add({
                              'text': messageText,
                              'sender': username,
                              "time": DateTime.now(),
                            });
                          },
                          child: const Icon(
                            Icons.send,
                            size: 24,
                            color: Colors.purple,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MessagesStream extends StatelessWidget {
  final String username;
  const MessagesStream({Key? key, required this.username}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('kpop_chat')
          .orderBy('time', descending: false)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.purple,
            ),
          );
        }
        final messages = snapshot.data!.docs.reversed;
        List<MessageBubble> messageBubbles = [];
        for (var message in messages) {
          final messageText = message.get('text');
          final messageSender = message.get('sender');
          final messageTime = message.get('time') as Timestamp;
          final currentUser =
              username; // Use the passed username instead of loggedInUser.email

          final messageBubble = MessageBubble(
            sender: messageSender,
            text: messageText,
            isMe: currentUser ==
                messageSender, // Update isMe property to align messages correctly
            time: messageTime,
          );
          messageBubbles.add(messageBubble);
        }
        return Expanded(
          child: ListView(
            reverse: true,
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 20,
            ),
            children: messageBubbles,
          ),
        );
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    super.key,
    required this.sender,
    required this.text,
    required this.isMe,
    required this.time,
  });

  final String sender;
  final String text;
  final bool isMe;
  final Timestamp time;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            sender,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black54,
              fontFamily: 'Sen',
            ),
          ),
          Material(
            borderRadius: isMe
                ? const BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0))
                : const BorderRadius.only(
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
            elevation: 4.0,
            color: isMe ? Colors.purple : Colors.white,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Text(
                text,
                style: TextStyle(
                  color: isMe ? Colors.white : Colors.purple,
                  fontSize: 15,
                  fontFamily: 'Sen',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
