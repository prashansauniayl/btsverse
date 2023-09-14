// ignore_for_file: use_build_context_synchronously, unused_local_variable
import 'dart:async';
import 'dart:io';
import 'package:btsverse/ad_mob_service.dart';
import 'package:btsverse/utils/color.dart';
import 'package:btsverse/widgets/drawer.dart';
import 'package:btsverse/widgets/post_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:image_picker/image_picker.dart';

class ImagePostScreen extends StatefulWidget {
  const ImagePostScreen({Key? key}) : super(key: key);

  @override
  State<ImagePostScreen> createState() => _ImagePostScreenState();
}

class _ImagePostScreenState extends State<ImagePostScreen> {
  File? _imageFile;
  final TextEditingController _captionController = TextEditingController();
  bool _isSubmitting = false;
  InterstitialAd? _interstitialAd;

  void _createInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdMobService.interstitialAdUnitId!,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) => _interstitialAd = ad,
        onAdFailedToLoad: (LoadAdError error) => _interstitialAd = null,
      ),
    );
  }

  void _showInterstitialAd() {
    if (_interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          _createInterstitialAd();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          _createInterstitialAd();
        },
      );
      _interstitialAd!.show();
      _interstitialAd = null;
    }
  }

  @override
  void initState() {
    super.initState();
    _createInterstitialAd();
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

  void _submitPost() async {
    setState(() {
      _isSubmitting = true;
    });

    if (_imageFile == null || _captionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please select an image and enter a caption'),
      ));
    } else {
      // Compress the image before uploading
      final compressedImage = await FlutterImageCompress.compressWithFile(
        _imageFile!.path,
        quality:
            80, // Adjust the quality (0 to 100) to balance size and quality
      );

      final imagePath = 'userPost/${DateTime.now().microsecondsSinceEpoch}.jpg';

      // Upload the compressed image to Firebase Storage
      final storageRef = FirebaseStorage.instance.ref().child(imagePath);
      final task = storageRef.putData(compressedImage!);
      final snapshot = await task.whenComplete(() {});
      final downloadUrl = await snapshot.ref.getDownloadURL();

      // Save post to Firestore database
      final firestore = FirebaseFirestore.instance;
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final user = FirebaseAuth.instance.currentUser!;
      final userDoc = await firestore.collection('users').doc(uid).get();
      final followers = List<String>.from(userDoc.get('followers'));
      final following = List<String>.from(userDoc.get('following'));
      final post = {
        'postId': DateTime.now().microsecondsSinceEpoch,
        'imageUrl': downloadUrl,
        'caption': _captionController.text,
        'timestamp': DateTime.now().microsecondsSinceEpoch,
        'userId': uid,
        'username': userDoc.get('username'),
        'photoUrl': userDoc.get('photoUrl'),
        'likes': [],
        'downloads': 0, // Add downloads to the post
        'followers': followers,
        'following': following,
      };
      final postDocRef = await firestore.collection('posts').add(post);
      final postId = postDocRef.id;

      // Update the postId of the post in Firestore
      await firestore
          .collection('posts')
          .doc(postId)
          .update({'postId': postId});

      // Increment the value of downloads by 1
      await firestore
          .collection('posts')
          .doc(postId)
          .update({'downloads': FieldValue.increment(1)});

      // Show the Snack bar message
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Post successful'),
      ));

      // Clear the form fields
      setState(() {
        _imageFile = null;
        _captionController.clear();
      });
    }
    setState(() {
      _isSubmitting = false;
    });
  }

  @override
  void dispose() {
    _captionController.dispose();
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
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        drawer: const DrawerScreen(),
        body: Theme(
          data: ThemeData(
            colorScheme: ColorScheme.fromSwatch().copyWith(secondary: purple),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  if (_isSubmitting)
                    const LinearProgressIndicator(
                      backgroundColor: Colors.white,
                      valueColor: AlwaysStoppedAnimation<Color>(purple),
                    ),
                  GestureDetector(
                    onTap: () {
                      _showBottomSheet(context);
                    },
                    child: Container(
                      width: 400,
                      height: 400,
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          colors: [purple.withOpacity(0.9), Colors.transparent],
                          center: Alignment.topLeft,
                          radius: 1.5,
                        ),
                      ),
                      child: _imageFile != null
                          ? Image.file(_imageFile!, fit: BoxFit.cover)
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(
                                  Icons.image,
                                  size: 50,
                                  color: Colors.white,
                                ),
                                Text(
                                  'Select media from you device',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'pal',
                                      fontSize: 15),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                              ],
                            ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 30),
                    child: TextField(
                      controller: _captionController,
                      maxLines: null,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontFamily: 'pal',
                      ),
                      decoration: InputDecoration(
                        hintText: 'Type your caption...',
                        hintStyle: const TextStyle(
                          fontFamily: 'pal',
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey[300],
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                      ),
                    ),
                  ),
                  PostButton(
                    text: 'P O S T',
                    press: () {
                      _showInterstitialAd();
                      _submitPost();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
