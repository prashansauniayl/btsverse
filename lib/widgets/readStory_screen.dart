// ignore_for_file: prefer_typing_uninitialized_variables
import 'package:btsverse/providers/user_provider.dart';
import 'package:btsverse/resources/firestore_comments.dart';
import 'package:btsverse/screens/home_screen.dart';
import 'package:btsverse/screens/profile_screen.dart';
import 'package:btsverse/screens/storyComment_screen.dart';
import 'package:btsverse/utils/color.dart';
import 'package:btsverse/utils/utils.dart';
import 'package:btsverse/widgets/like_animation.dart';
import 'package:btsverse/widgets/like_page.dart';
import 'package:btsverse/widgets/story_report.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:btsverse/modal/user.dart' as model;
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

class ReadStory extends StatefulWidget {
  final String storyId;
  final isSolutionVerified; // Add this lin
  final snap;
  const ReadStory(
      {Key? key, required this.storyId, this.snap, this.isSolutionVerified})
      : super(key: key);

  @override
  State<ReadStory> createState() => _ReadStoryState();
}

class _ReadStoryState extends State<ReadStory> {
  late Map<String, dynamic> story;
  int commentLen = 0;
  bool isLikeAnimating = false;
  bool isLoading = false;
  bool isNotInterested = false;
  int followers = 0;
  int following = 0;

  @override
  void initState() {
    super.initState();
    fetchStory();
    fetchCommentLen();
  }

  fetchStory() async {
    setState(() {
      isLoading = true;
    });
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('story')
          .doc(widget.storyId)
          .get();
      story = snapshot.data()!;
    } catch (err) {
      showSnackBar(
        context,
        err.toString(),
      );
    }
    setState(() {});
    setState(() {
      isLoading = false;
    });
  }

  fetchCommentLen() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('story')
          .doc(widget.storyId)
          .collection('comments')
          .get();
      commentLen = snap.docs.length;
    } catch (err) {
      showSnackBar(
        context,
        err.toString(),
      );
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final model.User user = Provider.of<UserProvider>(context).getUser;

    return isLoading
        ? Container(
            color: Colors.white,
            child: const Center(
              child: CircularProgressIndicator(
                color: purple,
              ),
            ),
          )
        : Scaffold(
            body: Theme(
              data: ThemeData(
                colorScheme:
                    ColorScheme.fromSwatch().copyWith(secondary: purple),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Container(
                          height: 350,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(
                                story['imageUrl'].toString(),
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomRight,
                                colors: [
                                  Colors.black.withOpacity(.9),
                                  Colors.black.withOpacity(.1),
                                ],
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Text(
                                    story['title'].toString(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 2),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 30, vertical: 50),
                            child: Align(
                                alignment: Alignment.topLeft,
                                child: Icon(Icons.arrow_back_rounded,
                                    color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                      child: Row(
                        children: [
                          InkWell(
                            child: CircleAvatar(
                              backgroundColor: Colors.purple,
                              backgroundImage: NetworkImage(
                                story['photoUrl'].toString(),
                              ),
                            ),
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ProfileScreen(
                                    uid: story['userId'].toString(),
                                  ),
                                ),
                              );
                            },
                          ),
                          SizedBox(width: 8,),
                          InkWell(
                            child: Row(
                              children: [
                                Text(
                                  story['username'].toString(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: purple,
                                      fontSize: 16),
                                ),
                                const SizedBox(
                                  width: 2,
                                ),
                                if (widget.isSolutionVerified)
                                  const Icon(
                                    Icons.verified,
                                    size: 16,
                                    color: Colors.blue,
                                  ),
                              ],
                            ),
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ProfileScreen(
                                    uid: story['userId'].toString(),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 6),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              if (!isLikeAnimating) {
                                setState(() {
                                  isLikeAnimating = true;
                                });
                                await FireStoreComments().likeStory(
                                    story['storyId'].toString(),
                                    user.uid,
                                    story['likes']);
                                setState(() {
                                  isLikeAnimating = false;
                                  if (story['likes'].contains(user.uid)) {
                                    story['likes'].remove(user.uid);
                                  } else {
                                    story['likes'].add(user.uid);
                                  }
                                });
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              child: LikeAnimation(
                                isAnimating: isLikeAnimating,
                                child: Image.asset(
                                  story['likes'].contains(user.uid)
                                      ? 'icons/heart.png' // Image asset for liked state
                                      : 'icons/heart_outlined.png', // Image asset for unliked state
                                  color: story['likes'].contains(user.uid)
                                      ? Colors.deepPurpleAccent.shade200
                                      : secondaryColor,
                                  width: 21,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          InkWell(
                            child: Image.asset(
                              'icons/group_chat.png',
                              width: 20,
                              color: secondaryColor,
                            ),
                            onTap: () {
                              Navigator.of(context).push(
                                PageTransition(
                                  type: PageTransitionType
                                      .fade, // Set the type to PageTransitionType.slideLeft
                                  duration: const Duration(
                                      milliseconds:
                                      200),
                                  child: StoryCommentScreen(
                                    storyId: story['storyId'].toString(),
                                  ),
                                ),
                              );
                            },
                          ),
                          SizedBox(width: 20,),
                          InkWell(
                            child: Image.asset(
                              'icons/share.png',
                              width: 20,
                              color: secondaryColor,
                            ),
                            onTap: () async {
                              String postLink =
                                  'https://btsverse.page.link/start';
                              await Share.share(
                                  'Check out this amazing content! $postLink',
                                  subject: 'Subject text');
                            },
                          ),
                          IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    backgroundColor: Colors.white,
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        FirebaseAuth.instance.currentUser!
                                                    .uid ==
                                                story['userId']
                                            ? Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  const Text(
                                                    'Delete',
                                                    style: TextStyle(
                                                        color: purple,
                                                        fontFamily: 'Sen'),
                                                  ),
                                                  IconButton(
                                                    onPressed: () {
                                                      FirebaseFirestore.instance
                                                          .collection('story')
                                                          .doc(story['storyId'])
                                                          .delete()
                                                          .then((value) {
                                                        Navigator.pushReplacement(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (_) =>
                                                                    const HomeScreen()));
                                                      });
                                                    },
                                                    icon: const Icon(
                                                      Icons.delete,
                                                      color: purple,
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  const Text(
                                                    'Not Interested',
                                                    style: TextStyle(
                                                        color: purple,
                                                        fontFamily: 'Sen'),
                                                  ),
                                                  IconButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        isNotInterested = true;
                                                      });
                                                      Navigator.pop(context);
                                                    },
                                                    icon: const Icon(
                                                      Icons.close_rounded,
                                                      color: purple,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                        const SizedBox(height: 16),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(
                                              'Report',
                                              style: TextStyle(
                                                  color: purple,
                                                  fontFamily: 'Sen'),
                                            ),
                                            IconButton(
                                              onPressed: () async {
                                                Navigator.pop(context);
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          StoryReport(
                                                            storyId: story[
                                                                'storyId'],
                                                          )),
                                                );
                                              },
                                              icon: const Icon(
                                                Icons
                                                    .report_gmailerrorred_outlined,
                                                color: purple,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                            icon: const Icon(
                              Icons.more_vert,
                              color: secondaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 28, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            child: Text(
                              '${story['likes'].length} likes',
                              style: const TextStyle(
                                  color: purple, fontWeight: FontWeight.bold),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                PageTransition(
                                  type: PageTransitionType
                                      .fade, // Set the type to PageTransitionType.slideLeft
                                  duration: const Duration(
                                      milliseconds:
                                      200),
                                  child: LikePage(
                                    postId: story['userId'],
                                    likes: story['likes'],
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => StoryCommentScreen(
                                    storyId: story['storyId'].toString(),
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Text(
                                'View $commentLen comments',
                                style: const TextStyle(
                                  color: purple,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            story['caption'].toString(),
                            style: const TextStyle(
                              fontSize: 15,
                              fontFamily: 'Sen',
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
