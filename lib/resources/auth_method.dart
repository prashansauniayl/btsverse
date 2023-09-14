// ignore_for_file: unnecessary_null_comparison, prefer_is_empty, avoid_print
import 'dart:typed_data';
import 'package:btsverse/resources/storage_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:btsverse/modal/user.dart' as model;
import 'package:flutter_image_compress/flutter_image_compress.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot documentSnapshot =
        await _firestore.collection('users').doc(currentUser.uid).get();

    return model.User.fromSnap(documentSnapshot);
  }

  // sign up the user
  Future<String> signupUser({
    required String email,
    required String password,
    required String displayName,
    required Uint8List file,
  }) async {
    String res = "Some error occurred";
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          displayName.isNotEmpty ||
          file != null) {
        if (displayName.length > 20) {
          res = "Username should be less than 20 characters";
        } else {
          // check if username already exists
          bool usernameExists = await checkUsername(displayName);
          if (usernameExists) {
            res = "Username already exists";
          } else {
            // Compress the image before uploading
            final compressedImage = await FlutterImageCompress.compressWithList(
              file,
              quality: 80, // Adjust the quality (0 to 100) to balance size and quality
            );

            // register the user
            UserCredential cred = await _auth.createUserWithEmailAndPassword(
                email: email, password: password);

            print(cred.user!.uid);

            String photoUrl = await StorageMethods()
                .uploadImageToStorage("profilePics", compressedImage!, false);

            model.User _user = model.User(
              username: displayName,
              uid: cred.user!.uid,
              photoUrl: photoUrl,
              email: email,
              followers: [],
              following: [],
            );

            // add user to the database
            await _firestore
                .collection("users")
                .doc(cred.user!.uid)
                .set(_user.toJson());
            res = "success";
          }
        }
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // check if the username already exists in the database
  Future<bool> checkUsername(String displayName) async {
    bool usernameExists = false;
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .where('username', isEqualTo: displayName)
          .get();
      if (snapshot.docs.length > 0) {
        usernameExists = true;
      }
    } catch (err) {
      print(err);
    }
    return usernameExists;
  }

  //login the user
  Future<String> loginUser(
      {required String email, required String password}) async {
    String res = "Some error occurred";

    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = "success";
      } else {
        res = "Please enter all the fields";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
