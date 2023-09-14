// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:btsverse/ad_mob_service.dart';
import 'package:btsverse/utils/color.dart';
import 'package:btsverse/widgets/drawer.dart';
import 'package:btsverse/widgets/long_button.dart';
import 'package:btsverse/widgets/text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:image_picker/image_picker.dart';

class EditAccount extends StatefulWidget {
  const EditAccount({Key? key}) : super(key: key);

  @override
  State<EditAccount> createState() => _EditAccountState();
}

class _EditAccountState extends State<EditAccount> {
  File? _imageFile;
  final TextEditingController _usernameController = TextEditingController();
  bool _isSubmitting = false;
  BannerAd? _banner;

  @override
  void initState() {
    super.initState();
    _createBannerAd();
  }

  void _createBannerAd() {
    _banner = BannerAd(
      size: AdSize.fullBanner,
      adUnitId: AdMobService.bannerAdUnitId!,
      listener: AdMobService.bannerListener,
      request: const AdRequest(),
    )..load();
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);

    setState(() {
      _imageFile = File(pickedFile!.path);
    });
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 180,
          color: Colors.white,
          child: Theme(
            data: ThemeData(
              colorScheme: ColorScheme.fromSwatch().copyWith(secondary: purple),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(
                      Icons.photo_library,
                      color: purple,
                    ),
                    title: const Text(
                      'Select from gallery',
                      style: TextStyle(fontFamily: 'Sen', color: purple),
                    ),
                    onTap: () {
                      _pickImage(ImageSource.gallery);
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.camera_alt,
                      color: purple,
                    ),
                    title: const Text(
                      'Capture with camera',
                      style: TextStyle(fontFamily: 'Sen', color: purple),
                    ),
                    onTap: () {
                      _pickImage(ImageSource.camera);
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.cancel,
                      color: purple,
                    ),
                    title: const Text(
                      'Cancel',
                      style: TextStyle(fontFamily: 'Sen', color: purple),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }


  void _saveProfile() async {
    setState(() {
      _isSubmitting = true;
    });

    final firestore = FirebaseFirestore.instance;
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final userDocRef = firestore.collection('users').doc(uid);
    final userDocSnapshot = await userDocRef.get();
    final userDocData = userDocSnapshot.data()!;

    final username = _usernameController.text.trim();
    final isUsernameChanged =
        username.isNotEmpty && username != userDocData['username'];
    final isImageChanged = _imageFile != null;

    if (username.length > 20) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Username should be less than 20 characters'),
        ),
      );
      setState(() {
        _isSubmitting = false;
      });
      return;
    }

    if (!isUsernameChanged && !isImageChanged) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('No changes to save'),
      ));
      setState(() {
        _isSubmitting = false;
      });
    } else {
      if (isUsernameChanged) {
        // Update the username in the "story" collection
        final storyCollectionRef = firestore.collection('story');
        final storyDocs = await storyCollectionRef
            .where('userId', isEqualTo: uid)
            .get()
            .then((snapshot) => snapshot.docs);
        for (final doc in storyDocs) {
          await doc.reference.update({'username': username});
        }

        // Update the username in the "posts" collection
        final postsCollectionRef = firestore.collection('posts');
        final postsDocs = await postsCollectionRef
            .where('userId', isEqualTo: uid)
            .get()
            .then((snapshot) => snapshot.docs);
        for (final doc in postsDocs) {
          await doc.reference.update({'username': username});
        }
      }

      showDialog(
        context: context,
        builder: (BuildContext context) => const Center(
          child: CircularProgressIndicator(
            color: purple,
          ),
        ),
        barrierDismissible: false,
      );

      String? photoUrl = userDocData['photoUrl'];
      if (isImageChanged && _imageFile!.path.isNotEmpty) {
        final imagePath = 'profilePics/$uid.jpg';
        final storageRef = FirebaseStorage.instance.ref().child(imagePath);
        final task = storageRef.putFile(_imageFile!);
        final snapshot = await task.whenComplete(() {});
        photoUrl = await snapshot.ref.getDownloadURL();

        // Update the profile image URL in the "story" collection
        final storyCollectionRef = firestore.collection('story');
        final storyDocs = await storyCollectionRef
            .where('userId', isEqualTo: uid)
            .get()
            .then((snapshot) => snapshot.docs);
        for (final doc in storyDocs) {
          await doc.reference.update({'photoUrl': photoUrl});
        }

        // Update the profile image URL in the "posts" collection
        final postsCollectionRef = firestore.collection('posts');
        final postsDocs = await postsCollectionRef
            .where('userId', isEqualTo: uid)
            .get()
            .then((snapshot) => snapshot.docs);
        for (final doc in postsDocs) {
          await doc.reference.update({'photoUrl': photoUrl});
        }
      }

      await userDocRef.update({
        if (isUsernameChanged) 'username': username,
        'photoUrl': photoUrl,
      });

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Profile updated successfully'),
      ));

      setState(() {
        _imageFile = null;
        _usernameController.clear();
        _isSubmitting = false;
      });
      Navigator.pushNamed(context, "home_screen");
    }
  }


  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
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
        bottomNavigationBar: _banner == null
            ? Container()
            : Container(
          margin: EdgeInsets.only(bottom: 12),
          height: 52,
          child: AdWidget(ad: _banner!),
        ),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        drawer: const DrawerScreen(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Column(
                children: [
                  const Text(
                    'EDIT ACCOUNT',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Sen',
                      fontSize: 30,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    'Edit your profile, Give it a new look \n click on profile for a magic and update the name \n if you like, And show it off',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Color(0xFFBDBDBD),
                        fontFamily: 'amar',
                        fontSize: 15),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const CircularProgressIndicator(
                          color: purple,
                        );
                      }
                      if (!snapshot.data!.exists) {
                        return const Text('Document does not exist');
                      }
                      Map<String, dynamic> data =
                          snapshot.data!.data() as Map<String, dynamic>;
                      return Column(
                        children: [
                          GestureDetector(
                            child: Container(
                              height: 150,
                              width: 150,
                              decoration: BoxDecoration(
                                color: Colors.white54,
                                borderRadius: BorderRadius.circular(100),
                                image: DecorationImage(
                                  image: _imageFile != null
                                      ? Image.file(_imageFile!,
                                              fit: BoxFit.cover)
                                          .image
                                      : NetworkImage(
                                          (data['photoUrl']),
                                        ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            onTap: () {
                              _showBottomSheet(context);
                            },
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          CustomTextField(
                            hintText: 'Enter your new Username',
                            icon: Icons.person,
                            textEditingController: _usernameController,
                            obscureText: false,
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  LongButton(
                      text: 'SAVE PROFILE',
                      press: () async {
                        _saveProfile();
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .update({
                          // Add the fields to update in Firestore
                        });
                      }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
