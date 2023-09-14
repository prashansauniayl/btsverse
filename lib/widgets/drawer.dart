import 'package:btsverse/screens/group_chat_screen.dart';
import 'package:btsverse/screens/home_screen.dart';
import 'package:btsverse/screens/post_screen.dart';
import 'package:btsverse/screens/profile_screen.dart';
import 'package:btsverse/screens/search_screen.dart';
import 'package:btsverse/screens/settings_screen.dart';
import 'package:btsverse/screens/story_screen.dart';
import 'package:btsverse/utils/color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class DrawerScreen extends StatefulWidget {
  const DrawerScreen({Key? key}) : super(key: key);

  @override
  State<DrawerScreen> createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  @override
  Widget build(BuildContext context) {
    return const DrawerWidget();
  }
}

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Container(
        padding: const EdgeInsets.all(8),
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
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                border: Border(
                  bottom: Divider.createBorderSide(context,
                      color: Colors.transparent, width: 0),
                ),
              ),
              child: const Center(
                child: Text(
                  'BTSverse',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Sen',
                    fontSize: 24,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: Image.asset(
                'icons/home.png',
                color: Colors.white,
                width: 16,
              ),
              title: const Text(
                "H O M E",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType
                        .fade, // Set the type to PageTransitionType.slideLeft
                    duration: const Duration(
                        milliseconds: 200), // Set the duration of the animation
                    child:
                        const HomeScreen(), // Replace HomeScreen with your destination screen
                  ),
                );
              },
            ),
            ListTile(
              leading: Image.asset(
                'icons/search.png',
                color: Colors.white,
                width: 16,
              ),
              title: const Text(
                "S E A R C H",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType
                        .fade, // Set the type to PageTransitionType.slideLeft
                    duration: const Duration(
                        milliseconds: 200), // Set the duration of the animation
                    child:
                    const SearchScreen(), // Replace HomeScreen with your destination screen
                  ),
                );
              },
            ),
            ListTile(
              leading: Image.asset(
                'icons/group_chat.png',
                color: Colors.white,
                width: 16,
              ),
              title: const Text(
                "G R O U P  C H A T",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType
                        .fade, // Set the type to PageTransitionType.slideLeft
                    duration: const Duration(
                        milliseconds: 200), // Set the duration of the animation
                    child:
                        const GroupChatScreen(), // Replace HomeScreen with your destination screen
                  ),
                );
              },
            ),
            ListTile(
              leading: Image.asset(
                'icons/post.png',
                color: Colors.white,
                width: 16,
              ),
              title: const Text(
                " P O S T ",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType
                        .fade, // Set the type to PageTransitionType.slideLeft
                    duration: const Duration(
                        milliseconds: 200), // Set the duration of the animation
                    child:
                        const PostScreen(), // Replace HomeScreen with your destination screen
                  ),
                );
              },
            ),
            ListTile(
              leading: Image.asset(
                'icons/news.png',
                color: Colors.white,
                width: 16,
              ),
              title: const Text(
                "S T O R I E S",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType
                        .fade, // Set the type to PageTransitionType.slideLeft
                    duration: const Duration(
                        milliseconds: 200), // Set the duration of the animation
                    child:
                    const StoryScreen(), // Replace HomeScreen with your destination screen
                  ),
                );
              },
            ),
            ListTile(
              leading: Image.asset(
                'icons/profile.png',
                color: Colors.white,
                width: 16,
              ),
              title: const Text(
                "P R O F I L E",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType
                        .fade, // Set the type to PageTransitionType.slideLeft
                    duration: const Duration(
                        milliseconds: 200), // Set the duration of the animation
                    child: ProfileScreen(
                        uid: FirebaseAuth.instance.currentUser!
                            .uid), // Replace HomeScreen with your destination screen
                  ),
                );
              },
            ),
            ListTile(
              leading: Image.asset(
                'icons/settings.png',
                color: Colors.white,
                width: 16,
              ),
              title: const Text(
                "S E T T I N G S",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType
                        .fade, // Set the type to PageTransitionType.slideLeft
                    duration: const Duration(
                        milliseconds: 200), // Set the duration of the animation
                    child:
                    const SettingsScreen(), // Replace HomeScreen with your destination screen
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
