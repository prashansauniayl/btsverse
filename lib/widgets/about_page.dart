import 'package:btsverse/utils/color.dart';
import 'package:btsverse/widgets/drawer.dart';
import 'package:flutter/material.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
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
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        drawer: const DrawerScreen(),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
            child: Theme(
              data: ThemeData(
                colorScheme:
                    ColorScheme.fromSwatch().copyWith(secondary: purple),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: const [
                    Text(
                      'BTSVerse',
                      style: TextStyle(
                          color: Colors.white, fontFamily: 'Sen', fontSize: 30),
                    ),
                    SizedBox(
                      height: 28,
                    ),
                    Text(
                      '''
BTSVerse is an app designed specifically for fans of BTS, one of the most popular K-pop groups in the world. The app allows fans to connect with each other and share their love for BTS through various features.

One of the main features of the app is the ability to post images with captions. Fans can upload pictures of themselves or their favorite BTS moments and add a caption to express their thoughts or feelings. Other fans can then like or comment on these posts, creating a sense of community and engagement.

Another feature of BTSVerse is the ability to share personal stories with other fans. Fans can share their BTS "stan" stories, or even real-life stories, with other fans who understand and appreciate their love for BTS. This creates a space where fans can connect with each other on a deeper level and feel supported by a like-minded community.

The app also includes a follow feature, which allows fans to follow each other and stay up-to-date with each other's posts. This helps fans build relationships with other fans and grow their own following within the BTSVerse community.

Additionally, BTSVerse has a group chat feature where fans can connect with each other in real-time. The app includes six different community groups, each focused on a different aspect of BTS and K-pop culture. This allows fans to connect with people who share their interests and make new friends within the BTSVerse community.

Finally, BTSVerse has a search feature that allows users to search for other users they may be interested in following or interacting with. This helps fans find like-minded individuals and build relationships within the app.

Overall, BTSVerse provides a space for BTS fans to connect with each other, share their love for BTS, and build a community around their shared interests.
                    
                    
       
                    ''',
                      style: TextStyle(color: Colors.white, fontFamily: 'Sen'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
