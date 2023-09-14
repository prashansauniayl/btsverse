import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:page_transition/page_transition.dart';
import 'package:btsverse/modal/user.dart' as model;
import 'package:share/share.dart';
import 'package:btsverse/widgets/like_animation.dart';
import 'package:btsverse/widgets/like_page.dart';
import 'package:btsverse/widgets/report.dart';
import 'package:btsverse/providers/user_provider.dart';
import 'package:btsverse/resources/firestore_methods.dart';
import 'package:btsverse/screens/comment_screen.dart';
import 'package:btsverse/screens/profile_screen.dart';
import 'package:btsverse/screens/home_screen.dart';
import 'package:btsverse/utils/color.dart';
import 'package:btsverse/utils/utils.dart';
import 'package:btsverse/widgets/post_card.dart';

class PostCard extends StatefulWidget {
  final snap;
  const PostCard({Key? key, this.snap}) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  int commentLen = 0;
  bool isLikeAnimating = false;
  int? total;
  bool isNotInterested = false;
  int followers = 0;
  int following = 0;
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
  void initState() {
    super.initState();
    fetchCommentLen();
    checkIsVerified();
  }

  fetchCommentLen() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.snap['postId'])
          .collection('comments')
          .get();
      setState(() {
        commentLen = snap.docs.length;
      });
    } catch (err) {
      showSnackBar(
        context,
        err.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final model.User user = Provider.of<UserProvider>(context).getUser;

    return !isNotInterested
        ? Container(
      color: Colors.transparent,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          Container(
            padding:
            const EdgeInsets.symmetric(vertical: 4, horizontal: 16)
                .copyWith(right: 0),
            child: Row(
              children: [
                InkWell(
                  child: CircleAvatar(
                    backgroundColor: purple,
                    radius: 18,
                    backgroundImage: NetworkImage(
                      widget.snap['photoUrl'].toString(),
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ProfileScreen(
                          uid: widget.snap[
                          'userId'], // pass the user's uid to the profile screen
                        ),
                      ),
                    );
                  },
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          child: Row(
                            children: [
                              Text(
                                widget.snap['username'].toString(),
                                style: const TextStyle(
                                    fontFamily: 'Sen',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              const SizedBox(
                                width: 2,
                              ),
                              if (isVerified)
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
                                  uid: widget.snap[
                                  'userId'], // pass the user's uid to the profile screen
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
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
                              FirebaseAuth.instance.currentUser!.uid ==
                                  widget.snap['userId']
                                  ? Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
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
                                          .collection('posts')
                                          .doc(
                                          widget.snap['postId'])
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
                                MainAxisAlignment.spaceBetween,
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
                                        color: purple, fontFamily: 'Sen'),
                                  ),
                                  IconButton(
                                    onPressed: () async {
                                      Navigator.pop(
                                          context); // close the dialog box
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ReportScreen(
                                                    postId: widget
                                                        .snap['postId'])),
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.report_gmailerrorred_outlined,
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
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.50,
              width: double.infinity,
              child: CachedNetworkImage(
                imageUrl: widget.snap['imageUrl'].toString(),
                fit: BoxFit.cover,
                placeholder: (context, url) => Center(
                  child: CircularProgressIndicator(
                    color: purple,
                  ),
                ),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
          ),
          Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            child: Row(
              children: [
                LikeAnimation(
                  isAnimating: widget.snap['likes'].contains(user.uid),
                  smallLike: true,
                  child: GestureDetector(
                    onTap: () => FireStoreMethods().likePost(
                      widget.snap['postId'].toString(),
                      user.uid,
                      widget.snap['likes'],
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      child: Image.asset(
                        widget.snap['likes'].contains(user.uid)
                            ? 'icons/heart.png' // Image asset for liked state
                            : 'icons/heart_outlined.png', // Image asset for unliked state
                        color: widget.snap['likes'].contains(user.uid)
                            ? Colors.deepPurpleAccent.shade200
                            : Colors
                            .white, // Optional: Apply color to image for liked state
                        width: 21, // Set the width of the image
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                InkWell(
                  child: Image.asset(
                    'icons/group_chat.png',
                    width: 20,
                    color: Colors.white,
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => CommentsScreen(
                          postId: widget.snap['postId'].toString(),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(
                  width: 20,
                ),
                InkWell(
                  child: Image.asset(
                    'icons/share.png',
                    width: 20,
                    color: Colors.white,
                  ),
                  onTap: () async {
                    String postLink =
                        'https://btsverse.page.link/start';
                    await Share.share(
                        'Check out this amazing content! $postLink',
                        subject: 'Subject text');
                  },
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  child: Text(
                    '${widget.snap['likes'].length} likes',
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
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
                          postId: widget.snap['userId'],
                          likes: widget.snap['likes'],
                        ),
                      ),
                    );
                  },
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 8),
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                      children: [
                        TextSpan(
                            text: widget.snap['username'].toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontFamily: 'pal',
                              fontWeight: FontWeight.bold,
                            )),
                        TextSpan(
                            text:
                            '  ${widget.snap['caption'].toString()}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontFamily: 'pal',
                            )),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      PageTransition(
                        type: PageTransitionType
                            .fade, // Set the type to PageTransitionType.slideLeft
                        duration: const Duration(
                            milliseconds:
                            200),
                        child: CommentsScreen(
                          postId: widget.snap['postId'].toString(),
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      'View all $commentLen comments',
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    )
        : Container(
      color: Colors.transparent,
    );
  }
}
