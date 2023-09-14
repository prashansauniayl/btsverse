import 'package:btsverse/ad_mob_service.dart';
import 'package:btsverse/screens/message_screen.dart';
import 'package:btsverse/utils/color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:page_transition/page_transition.dart';

class ChatScreen extends StatefulWidget {
  final String recipientId;

  ChatScreen({required this.recipientId});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late List<ChatTileData> chatTiles = [];
  BannerAd? _banner;

  void _createBannerAd() {
    _banner = BannerAd(
      size: AdSize.fullBanner,
      adUnitId: AdMobService.bannerAdUnitId!,
      listener: AdMobService.bannerListener,
      request: const AdRequest(),
    )..load();
  }

  @override
  void initState() {
    super.initState();
    fetchChatTiles();
    _createBannerAd();
  }

  void fetchChatTiles() async {
    String currentUserId = FirebaseAuth.instance.currentUser!.uid;

    QuerySnapshot messagesSnapshot = await FirebaseFirestore.instance
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .get();

    Set<String> uniqueUserIds = Set<String>();
    List<ChatTileData> tiles = [];

    for (DocumentSnapshot messageDoc in messagesSnapshot.docs) {
      String senderId = messageDoc['senderId'];
      String recipientId = messageDoc['recipientId'];
      String otherUserId = currentUserId == senderId ? recipientId : senderId;
      String text = messageDoc['text'];

      if (senderId == currentUserId || recipientId == currentUserId) {
        if (!uniqueUserIds.contains(otherUserId)) {
          uniqueUserIds.add(otherUserId);
          DocumentSnapshot userDoc = await FirebaseFirestore.instance
              .collection('users')
              .doc(otherUserId)
              .get();

          if (userDoc.exists) {
            String profilePhotoUrl = userDoc['photoUrl'];
            String username = userDoc['username'];

            DateTime timestamp = messageDoc['timestamp'].toDate();

            ChatTileData chatTile = ChatTileData(
              profilePhotoUrl: profilePhotoUrl,
              username: username,
              lastMessage: text,
              recipientId: otherUserId,
              timestamp: timestamp,
            );
            tiles.add(chatTile);
          }
        }
      }
    }

    setState(() {
      chatTiles = tiles;
    });
  }

  @override
  Widget build(BuildContext context) {
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
        bottomNavigationBar: _banner == null
            ? Container()
            : Container(
          margin: EdgeInsets.only(bottom: 12),
          height: 52,
          child: AdWidget(ad: _banner!),
        ),
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            'Messages Screen',
            style:
                TextStyle(color: Colors.white, fontFamily: 'Sen', fontSize: 16),
          ),
          centerTitle: true,
        ),
        body: Theme(
          data: ThemeData(
            colorScheme: ColorScheme.fromSwatch().copyWith(secondary: purple),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 22.0, horizontal: 6),
            child: ListView.builder(
              itemCount: chatTiles.length,
              itemBuilder: (context, index) {
                ChatTileData chatTile = chatTiles[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: purple,
                    backgroundImage: NetworkImage(chatTile.profilePhotoUrl),
                  ),
                  title: Text(
                    chatTile.username,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      fontFamily: 'Sen',
                    ),
                  ),
                  subtitle: Text(
                    chatTile.lastMessage,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 13,
                      fontFamily: 'Sen',
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType
                            .fade, // Set the type to PageTransitionType.slideLeft
                        duration: const Duration(
                            milliseconds:
                                200), // Set the duration of the animation
                        child: MessageScreen(
                          recipientId: chatTile
                              .recipientId, // Pass the recipientUsername here
                        ), // Replace HomeScreen with your destination screen
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class ChatTileData {
  final String profilePhotoUrl;
  final String username;
  final String lastMessage;
  final String recipientId;
  final DateTime timestamp;

  ChatTileData({
    required this.profilePhotoUrl,
    required this.username,
    required this.lastMessage,
    required this.recipientId,
    required this.timestamp,
  });
}
