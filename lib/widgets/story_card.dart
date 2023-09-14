// ignore_for_file: prefer_typing_uninitialized_variables
import 'package:btsverse/providers/user_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:btsverse/modal/user.dart' as model;
import 'package:btsverse/widgets/readStory_screen.dart';

class StoryCard extends StatefulWidget {
  final snap;
  const StoryCard({Key? key, this.snap}) : super(key: key);

  @override
  State<StoryCard> createState() => _StoryCardState();
}

class _StoryCardState extends State<StoryCard> {
  int followers = 0;
  int following = 0;

  @override
  void initState() {
    super.initState();
    checkIsVerified();
  }

  bool isVerified = false;

  Future<void> checkIsVerified() async {
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.snap['userId'])
        .get();
    final user = userDoc.data() ?? {};
    setState(() {
      isVerified =
          user['followers']?.length >= 100 && user['following']?.length >= 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final model.User user = Provider.of<UserProvider>(context).getUser;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 24),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                height: 180,
                width: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white30,
                  image: DecorationImage(
                    image: NetworkImage(widget.snap['imageUrl'].toString()),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              Expanded(
                // Added Expanded widget here
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        String storyId = widget.snap['storyId']
                            .toString(); // Replace 'storyId' with the field name in Firestore that represents the story ID
                        Navigator.push(
                          context,
                          PageTransition(
                            type: PageTransitionType.fade,
                            child: ReadStory(
                              storyId: storyId,
                              isSolutionVerified: isVerified,
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: RichText(
                          text: TextSpan(
                            style: const TextStyle(
                              color: Color(0xFFE6E6FA),
                              fontSize: 15,
                              fontFamily: 'Sen',
                              fontWeight: FontWeight.bold,
                            ),
                            children: [
                              TextSpan(
                                text: widget.snap['title'].toString(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            color: Color(0xFFF8EFE0),
                            fontSize: 12,
                            fontFamily: 'Sen',
                          ),
                          children: [
                            TextSpan(
                                text: widget.snap['description'].toString()),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 22,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 1, vertical: 8),
                      child: Row(
                        children: [
                          const Image(
                            image: AssetImage('icons/heart.png'),
                            color: Colors.white,
                            width: 12,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            '${widget.snap['likes'].length}',
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 1),
                      child: Row(
                        children: [
                          const Image(
                            image: AssetImage('icons/profile.png'),
                            color: Colors.white,
                            width: 12,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Row(
                            children: [
                              Text(
                                widget.snap['username'].toString(),
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12),
                              ),
                              const SizedBox(
                                width: 2,
                              ),
                              if (isVerified)
                                const Icon(
                                  Icons.verified,
                                  size: 14,
                                  color: Colors.blue,
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          const Divider(
            color: Colors.grey,
          )
        ],
      ),
    );
  }
}
