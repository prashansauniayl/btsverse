// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously
import 'package:btsverse/resources/auth_method.dart';
import 'package:btsverse/utils/color.dart';
import 'package:btsverse/utils/utils.dart';
import 'package:btsverse/widgets/long_button.dart';
import 'package:btsverse/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailTextController =
      TextEditingController(text: "");
  final TextEditingController _passwordTextController =
      TextEditingController(text: "");
  final TextEditingController _userTextController =
      TextEditingController(text: "");
  Uint8List? _image;
  late bool showSpinner = false;

  bool _validateFields() {
    if (_emailTextController.text.isEmpty ||
        _passwordTextController.text.isEmpty ||
        _userTextController.text.isEmpty) {
      showSnackBar(context, 'Please fill all the fields');
      return false;
    }
    return true;
  }

  @override
  void dispose() {
    super.dispose();
    _emailTextController.dispose();
    _passwordTextController.dispose();
    _userTextController.dispose();
  }

  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  void signUpUser() async {
    if (!_validateFields()) {
      return;
    }
    if (_image == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please select an image.'),
      ));
      return;
    }

    setState(() {
      showSpinner = true;
    });

    // Check if username already exists
    bool usernameExists =
        await AuthMethods().checkUsername(_userTextController.text);
    if (usernameExists) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Username already exists.'),
      ));
      setState(() {
        showSpinner = false;
      });
      return;
    }

    String res = await AuthMethods().signupUser(
      email: _emailTextController.text,
      password: _passwordTextController.text,
      displayName: _userTextController.text,
      file: _image!,
    );
    if (res != "success") {
      showSnackBar(context, res);
    } else {
      Navigator.pushNamed(context, "home_screen");
    }

    setState(() {
      showSpinner = false;
    });
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
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'R E G I S T E R',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Sen',
                    fontSize: 30,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                GestureDetector(
                  onTap: () {
                    selectImage();
                  },
                  child: Container(
                    width: 140,
                    height: 140,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xff813CBC),
                    ),
                    child: _image != null
                        ? CircleAvatar(
                            radius: 70,
                            backgroundImage: MemoryImage(_image!),
                          )
                        : const Icon(
                            Icons.person,
                            size: 80,
                            color: Colors.white,
                          ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomTextField(
                  hintText: 'Enter your email',
                  icon: Icons.email,
                  textEditingController: _emailTextController,
                  obscureText: false,
                ),
                const SizedBox(
                  height: 15,
                ),
                CustomTextField(
                  hintText: 'Enter your password',
                  icon: Icons.lock,
                  textEditingController: _passwordTextController,
                  obscureText: true,
                ),
                const SizedBox(
                  height: 15,
                ),
                CustomTextField(
                  hintText: 'Enter your Username',
                  icon: Icons.person,
                  textEditingController: _userTextController,
                  obscureText: false,
                ),
                const SizedBox(
                  height: 30,
                ),
                showSpinner
                    ? const CircularProgressIndicator(
                        color: purple,
                      )
                    : LongButton(
                        text: 'SUBMIT',
                        press: () {
                          signUpUser();
                        },
                      ),
                const SizedBox(
                  height: 12,
                ),
                GestureDetector(
                  onTap: () {
                    // navigate to login page
                    Navigator.pushNamed(context, 'login_screen');
                  },
                  child: const Text(
                    'Already have an account? Login',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'pal',
                      decoration: TextDecoration
                          .underline, // add this line to underline the text
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
