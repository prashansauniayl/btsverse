import 'package:btsverse/modal/user.dart';
import 'package:btsverse/providers/user_provider.dart';
import 'package:btsverse/resources/firestore_comments.dart';
import 'package:btsverse/utils/color.dart';
import 'package:btsverse/utils/utils.dart';
import 'package:btsverse/widgets/comment_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StoryCommentScreen extends StatefulWidget {
  final storyId;
  const StoryCommentScreen({Key? key, required this.storyId}) : super(key: key);

  @override
  _StoryCommentScreenState createState() => _StoryCommentScreenState();
}

class _StoryCommentScreenState extends State<StoryCommentScreen> {
  final TextEditingController commentEditingController =
      TextEditingController();

  void postComment(String uid, String name, String profilePic) async {
    try {
      String res = await FireStoreComments().storyComment(
        widget.storyId,
        commentEditingController.text,
        uid,
        name,
        profilePic,
      );

      if (res != 'success') {
        showSnackBar(context, res);
      }
      setState(() {
        commentEditingController.text = "";
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
    final User user = Provider.of<UserProvider>(context).getUser;

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
          title: const Text(
            'C O M M E N T',
            style:
                TextStyle(color: Colors.white, fontFamily: 'Sen', fontSize: 15),
          ),
          centerTitle: true,
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('story')
              .doc(widget.storyId)
              .collection('comments')
              .snapshots(),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: purple,
                ),
              );
            }

            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (ctx, index) => CommentCard(
                snap: snapshot.data!.docs[index],
              ),
            );
          },
        ),
        // text input
        bottomNavigationBar: SafeArea(
          child: Container(
            height: kToolbarHeight,
            margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            padding: const EdgeInsets.only(left: 16, right: 8),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(user.photoUrl),
                  radius: 18,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16, right: 8),
                    child: TextField(
                      controller: commentEditingController,
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'Sen',
                      ),
                      decoration: InputDecoration(
                        hintText: 'Comment as ${user.username}',
                        hintStyle: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'Sen',
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () => postComment(
                    user.uid,
                    user.username,
                    user.photoUrl,
                  ),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    child: const Icon(
                      Icons.send,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
