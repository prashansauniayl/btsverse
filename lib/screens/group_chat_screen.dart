import 'package:btsverse/group_chat/army_hangout.dart';
import 'package:btsverse/group_chat/buddies.dart';
import 'package:btsverse/group_chat/hallyu.dart';
import 'package:btsverse/group_chat/kpop.dart';
import 'package:btsverse/group_chat/micdrop.dart';
import 'package:btsverse/group_chat/purple.dart';
import 'package:btsverse/utils/color.dart';
import 'package:btsverse/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class GroupChatScreen extends StatefulWidget {
  const GroupChatScreen({Key? key}) : super(key: key);

  @override
  State<GroupChatScreen> createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Simulating asynchronous data loading
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Container(
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
            child: const Center(
              child: CircularProgressIndicator(
                color: purple,
              ), // Show circular progress indicator while loading
            ),
          )
        : Container(
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
              body: Theme(
                data: ThemeData(
                  colorScheme:
                      ColorScheme.fromSwatch().copyWith(secondary: purple),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                PageTransition(
                                  type: PageTransitionType
                                      .fade, // Set the type to PageTransitionType.slideLeft
                                  duration: const Duration(
                                      milliseconds: 200), // Set the duration of the animation
                                  child:
                                  const ArmyHangout(), // Replace HomeScreen with your destination screen
                                ),
                              );
                            },
                            child: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: GroupContainer(
                                text: 'ARMY HANGOUT',
                                groupimage: AssetImage('images/army.png'),
                                description: 'Connect with fans',
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                PageTransition(
                                  type: PageTransitionType
                                      .fade, // Set the type to PageTransitionType.slideLeft
                                  duration: const Duration(
                                      milliseconds: 200), // Set the duration of the animation
                                  child:
                                  const BangtanBuddies(), // Replace HomeScreen with your destination screen
                                ),
                              );
                            },
                            child: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: GroupContainer(
                                text: 'Bangtan Buddies',
                                groupimage: AssetImage('images/buddies.png'),
                                description: 'Make friends here',
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                PageTransition(
                                  type: PageTransitionType
                                      .fade, // Set the type to PageTransitionType.slideLeft
                                  duration: const Duration(
                                      milliseconds: 200), // Set the duration of the animation
                                  child:
                                  const KpopKrazies(), // Replace HomeScreen with your destination screen
                                ),
                              );
                            },
                            child: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: GroupContainer(
                                text: 'K-Pop Krazies',
                                groupimage: AssetImage('images/k-pop.png'),
                                description: 'Explore K-pop world',
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                PageTransition(
                                  type: PageTransitionType
                                      .fade, // Set the type to PageTransitionType.slideLeft
                                  duration: const Duration(
                                      milliseconds: 200), // Set the duration of the animation
                                  child:
                                  const PurpleChat(), // Replace HomeScreen with your destination screen
                                ),
                              );
                            },
                            child: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: GroupContainer(
                                text: 'Purple Paradise',
                                groupimage: AssetImage('images/purple.png'),
                                description: 'Dreamy BTS vibes',
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                PageTransition(
                                  type: PageTransitionType
                                      .fade, // Set the type to PageTransitionType.slideLeft
                                  duration: const Duration(
                                      milliseconds: 200), // Set the duration of the animation
                                  child:
                                  const MicDrop(), // Replace HomeScreen with your destination screen
                                ),
                              );
                            },
                            child: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: GroupContainer(
                                text: 'Mic Drop Lounge',
                                groupimage: AssetImage('images/micdrop.png'),
                                description: 'Talk about performances',
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                PageTransition(
                                  type: PageTransitionType
                                      .fade, // Set the type to PageTransitionType.slideLeft
                                  duration: const Duration(
                                      milliseconds: 200), // Set the duration of the animation
                                  child:
                                  const Hallyu(), // Replace HomeScreen with your destination screen
                                ),
                              );
                            },
                            child: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: GroupContainer(
                                text: 'Hallyu Hangout',
                                groupimage: AssetImage('images/hallyu.png'),
                                description: 'Explore Korean culture',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}

class GroupContainer extends StatelessWidget {
  final String text;
  final AssetImage groupimage;
  final String description;
  const GroupContainer({
    Key? key,
    required this.text,
    required this.groupimage,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 160,
          width: 160,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            image: DecorationImage(image: groupimage, fit: BoxFit.cover),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        Text(
          text,
          style: const TextStyle(
              color: Colors.white,
              fontFamily: 'Sen',
              fontWeight: FontWeight.bold,
              fontSize: 15),
        ),
        Text(
          description,
          style: const TextStyle(
              color: Color(0xFFBDBDBD),
              fontFamily: 'pal',
              fontWeight: FontWeight.bold,
              fontSize: 14),
        ),
      ],
    );
  }
}
