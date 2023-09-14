import 'package:btsverse/screens/profile_screen.dart';
import 'package:btsverse/utils/color.dart';
import 'package:btsverse/widgets/drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LikePage extends StatefulWidget {
  final String postId;
  final List<dynamic> likes;

  const LikePage({
    Key? key,
    required this.postId,
    required this.likes,
  }) : super(key: key);

  @override
  State<LikePage> createState() => _LikePageState();
}

class _LikePageState extends State<LikePage> {
  late List<DocumentSnapshot> users = [];
  late Future<void> _fetchUsersFuture;

  @override
  void initState() {
    super.initState();
    _fetchUsersFuture = fetchUsers();
  }

  Future<void> fetchUsers() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    for (String userId in widget.likes) {
      final DocumentSnapshot userSnapshot =
      await firestore.collection('users').doc(userId).get();
      users.add(userSnapshot);
    }
  }

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
          title: Text(
            'Likes (${widget.likes.length})',
            style: const TextStyle(fontFamily: 'Sen', fontSize: 18),
          ),
        ),
        drawer: const DrawerScreen(),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 35),
          child: FutureBuilder<void>(
            future: _fetchUsersFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // Show the circular progress indicator while fetching data
                return const Center(
                  child: CircularProgressIndicator(
                    color: purple,
                  ),
                );
              } else if (users.isEmpty) {
                return const Center(
                  child: Text(
                    'There are no likes yet',
                    style: TextStyle(color: Colors.white, fontFamily: 'Sen'),
                  ),
                );
              } else {
                return Theme(
                  data: ThemeData(
                    colorScheme: ColorScheme.fromSwatch().copyWith(secondary: purple),
                  ),
                  child: ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final userSnapshot = users[index];
                      final Map<String, dynamic> userData =
                      userSnapshot.data() as Map<String, dynamic>;

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ProfileScreen(uid: userSnapshot.id),
                            ),
                          );
                        },
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: purple,
                            backgroundImage: NetworkImage(userData['photoUrl']),
                          ),
                          title: Text(
                            userData['username'],
                            style: const TextStyle(
                                color: Colors.white,
                                fontFamily: 'Sen',
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      );
                    },
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
