// ignore_for_file: use_build_context_synchronously

import 'package:btsverse/utils/color.dart';
import 'package:btsverse/widgets/readStory_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:page_transition/page_transition.dart';

class StoryView extends StatefulWidget {
  final String uid;
  const StoryView({Key? key, required this.uid}) : super(key: key);

  @override
  State<StoryView> createState() => _StoryViewState();
}

class _StoryViewState extends State<StoryView> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('story')
          .where('userId', isEqualTo: widget.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(
            color: purple,
          );
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (!snapshot.hasData || snapshot.data?.docs.isEmpty == true) {
          return const Padding(
            padding: EdgeInsets.all(80),
            child: Text(
              "",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Sen',
                  fontWeight: FontWeight.bold),
            ),
          );
        }
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2.0),
          child: MasonryGridView.builder(
            itemCount: snapshot.data!.docs.length,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start, // Align text to the start (left)
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: InkWell(
                      onTap: () async {
                        String storyId = snapshot.data!.
                        docs[index].id;
                        final userDoc = await FirebaseFirestore.instance
                            .collection('users')
                            .doc(snapshot.data!.docs[index]['userId'])
                            .get();
                        final user = userDoc.data() ?? {};
                        bool isSolutionVerified =
                            user['followers']?.length >= 100 &&
                                user['following']?.length >= 0;
                        Navigator.push(
                          context,
                          PageTransition(
                            type: PageTransitionType.fade,
                            child: ReadStory(
                              storyId: storyId,
                              isSolutionVerified: isSolutionVerified,
                            ),
                          ),
                        );
                      },
                      child: Image.network(
                        snapshot.data!.docs[index]['imageUrl'],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(
                      height: 8), // Add spacing between image and title
                  Text(
                    snapshot.data!.docs[index]['title'], // Add title text here
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'Sen',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
