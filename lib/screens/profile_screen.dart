// ignore_for_file: prefer_interpolation_to_compose_strings
import 'package:btsverse/resources/firestore_methods.dart';
import 'package:btsverse/screens/chat_screen.dart';
import 'package:btsverse/screens/message_screen.dart';
import 'package:btsverse/utils/color.dart';
import 'package:btsverse/utils/utils.dart';
import 'package:btsverse/widgets/drawer.dart';
import 'package:btsverse/widgets/followers_page.dart';
import 'package:btsverse/widgets/following_page.dart';
import 'package:btsverse/widgets/imageView.dart';
import 'package:btsverse/widgets/profile_button.dart';
import 'package:btsverse/widgets/storyView.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:btsverse/widgets/edit_profile.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:page_transition/page_transition.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({Key? key, required this.uid}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userData = {};
  int postLen = 0;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;
  bool isLoading = false;
  late List<Widget> _tabBarViews; // Update this line

  @override
  void initState() {
    super.initState();
    _tabBarViews = [
      // Update this line
      //image view
      ImageView(
        uid: widget.uid,
      ),
      //story view
      StoryView(
        uid: widget.uid,
      ),
    ];
    getData();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();

      // get post length
      var postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('userId', isEqualTo: widget.uid)
          .get();

      postLen = postSnap.docs.length;
      userData = userSnap.data()!;
      followers = userSnap.data()!['followers'].length;
      following = userSnap.data()!['following'].length;
      isFollowing = userSnap
          .data()!['followers']
          .contains(FirebaseAuth.instance.currentUser!.uid);
      setState(() {});
    } catch (e) {
      showSnackBar(
        context,
        e.toString(),
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _handleRefresh() async {
    return await Future.delayed(Duration(seconds: 2));
  }

  //tab bar
  final List<Widget> tabs = const [
    Tab(
      icon: Icon(Icons.image),
    ),
    Tab(
      icon: Icon(Icons.book),
    ),
  ];

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
      child: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: purple,
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
              child: DefaultTabController(
                length: 2,
                child: Scaffold(
                  backgroundColor: Colors.transparent,
                  appBar: AppBar(
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                  ),
                  drawer: const DrawerScreen(),
                  body: LiquidPullToRefresh(
                    onRefresh: _handleRefresh,
                    color: purple,
                    height: 300,
                    backgroundColor: Colors.white,
                    child: Theme(
                      data: ThemeData(
                        colorScheme:
                            ColorScheme.fromSwatch().copyWith(secondary: purple),
                      ),
                      child: ListView(
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
                                          milliseconds:
                                          200),
                                      child:
                                          FollowersPage(userId: widget.uid),
                                    ),
                                  );
                                },
                                child: Column(
                                  children: [
                                    Text(
                                      followers.toString(),
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const Text(
                                      'followers',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                width: 30,
                              ),
                              CircleAvatar(
                                radius: 50,
                                backgroundImage:
                                    NetworkImage(userData['photoUrl']),
                                backgroundColor: purple,
                              ),
                              const SizedBox(
                                width: 30,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    PageTransition(
                                      type: PageTransitionType
                                          .fade, // Set the type to PageTransitionType.slideLeft
                                      duration: const Duration(
                                          milliseconds:
                                          200),
                                      child: FollowingPage(userId: widget.uid),
                                    ),
                                  );
                                },
                                child: Column(
                                  children: [
                                    Text(
                                      following.toString(),
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const Text(
                                      'following',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '@' + userData['username'],
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                width: 2,
                              ),
                              if (followers >= 100 && following >= 0)
                                const Icon(
                                  Icons.verified,
                                  size: 16,
                                  color: Colors.blue,
                                ),
                            ],
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FirebaseAuth.instance.currentUser!.uid == widget.uid
                                  ? ProfileButton(
                                      text: 'Edit Profile',
                                      press: () {
                                        Navigator.push(
                                            context,
                                            PageTransition(
                                              type: PageTransitionType
                                                  .fade, // Set the type to PageTransitionType.slideLeft
                                              duration: const Duration(
                                                  milliseconds:
                                                  200),
                                              child:
                                                  const EditAccount(),
                                            ));
                                      })
                                  : isFollowing
                                      ? ProfileButton(
                                          text: 'Unfollow',
                                          press: () async {
                                            await FireStoreMethods().followUser(
                                              FirebaseAuth
                                                  .instance.currentUser!.uid,
                                              userData['uid'],
                                            );
                                            setState(() {
                                              isFollowing = false;
                                              followers--;
                                            });
                                          })
                                      : ProfileButton(
                                          text: 'Follow',
                                          press: () async {
                                            await FireStoreMethods().followUser(
                                              FirebaseAuth
                                                  .instance.currentUser!.uid,
                                              userData['uid'],
                                            );
                                            setState(() {
                                              isFollowing = true;
                                              followers++;
                                            });
                                          }),
                              const SizedBox(
                                width: 15,
                              ),
                              FirebaseAuth.instance.currentUser!.uid == widget.uid
                                  ? ProfileButton(
                                      text: 'Messages',
                                      press: () {
                                        Navigator.push(
                                          context,
                                          PageTransition(
                                            type: PageTransitionType
                                                .fade, // Set the type to PageTransitionType.slideLeft
                                            duration: const Duration(
                                                milliseconds:
                                                    200), // Set the duration of the animation
                                            child: ChatScreen(
                                                recipientId: widget
                                                    .uid), // Replace HomeScreen with your destination screen
                                          ),
                                        );
                                      })
                                  : ProfileButton(
                                      text: 'Message',
                                      press: () {
                                        Navigator.push(
                                          context,
                                          PageTransition(
                                            type: PageTransitionType
                                                .fade, // Set the type to PageTransitionType.slideLeft
                                            duration: const Duration(
                                                milliseconds:
                                                    200), // Set the duration of the animation
                                            child: MessageScreen(
                                                recipientId: widget
                                                    .uid), // Replace HomeScreen with your destination screen
                                          ),
                                        );
                                      }),
                            ],
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          TabBar(
                            tabs: tabs,
                            indicatorColor: purple,
                          ),
                          SizedBox(
                            height: 1000,
                            child: TabBarView(
                              children: _tabBarViews,
                            ),
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
