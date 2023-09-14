// ignore_for_file: use_build_context_synchronously

import 'package:btsverse/resources/auth_method.dart';
import 'package:btsverse/utils/color.dart';
import 'package:btsverse/utils/utils.dart';
import 'package:btsverse/widgets/long_button.dart';
import 'package:flutter/material.dart';
import 'package:btsverse/widgets/text_field.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailTextController =
      TextEditingController(text: "");
  final TextEditingController _passwordTextController =
      TextEditingController(text: "");
  late bool showSpinner = false;

  @override
  void dispose() {
    super.dispose();
    _emailTextController.dispose();
    _passwordTextController.dispose();
  }

  void loginUser() async {
    setState(() {
      showSpinner = true;
    });
    String res = await AuthMethods().loginUser(
        email: _emailTextController.text,
        password: _passwordTextController.text);
    setState(() {
      showSpinner = false;
    });
    if (res == "success") {
      Navigator.pushNamed(context, "home_screen");
    } else {
      showSnackBar(context, res);
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
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 80,
              ),
              const Text(
                'L O G I N',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Sen',
                  fontSize: 30,
                ),
              ),
              const SizedBox(
                height: 30,
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
                height: 30,
              ),
              showSpinner
                  ? const CircularProgressIndicator(
                      color: purple,
                    )
                  : LongButton(
                      text: 'SUBMIT',
                      press: () {
                        loginUser();
                      },
                    ),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        alignment: Alignment.bottomCenter,
                        child: Image.asset(
                          'images/bts.png',
                          fit: BoxFit.cover,
                          width: 280,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
