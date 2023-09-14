import 'package:btsverse/screens/profile_screen.dart';
import 'package:btsverse/utils/color.dart';
import 'package:btsverse/widgets/drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FollowersPage extends StatefulWidget {
  final String userId;

  const FollowersPage({Key? key, required this.userId}) : super(key: key);

  @override
  State<FollowersPage> createState() => _FollowersPageState();
}

class _FollowersPageState extends State<FollowersPage> {
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
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 35),
          child: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(widget.userId)
                .snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator(
                  color: purple,
                );
              }

              final List<dynamic>? followers = snapshot.data!['followers'];
              if (followers == null || followers.isEmpty) {
                return const Center(
                  child: Text(
                    'There are no followers yet',
                    style: TextStyle(color: Colors.white, fontFamily: 'Sen'),
                  ),
                );
              }

              return Theme(
                data: ThemeData(
                  colorScheme:
                      ColorScheme.fromSwatch().copyWith(secondary: purple),
                ),
                child: ListView.builder(
                  itemCount: followers.length,
                  itemBuilder: (BuildContext context, int index) {
                    final String followerId = followers[index];

                    return StreamBuilder<DocumentSnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .doc(followerId)
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<DocumentSnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return const Text('Something went wrong');
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        }

                        final String username = snapshot.data!['username'];
                        final String photoUrl = snapshot.data!['photoUrl'];

                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => ProfileScreen(uid: followerId),
                              ),
                            );
                          },
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: purple,
                              backgroundImage: NetworkImage(photoUrl),
                            ),
                            title: Text(
                              username,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Sen'),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
