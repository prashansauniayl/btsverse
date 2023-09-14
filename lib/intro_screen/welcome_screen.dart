import 'package:btsverse/utils/color.dart';
import 'package:btsverse/widgets/small_button.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: linearGradient(),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: Column(
          children: [
            const SizedBox(
              height: 12,
            ),
            const Text(
              'BTSverse',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Sen',
                fontSize: 35,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'A world of music, passion, and love. Join us on a \n journey of discovery and inspiration with the global phenomenon BTS',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Color(0xFFBDBDBD), fontFamily: 'amar', fontSize: 15),
            ),
            const SizedBox(
              height: 52,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SmallButton(
                  text: 'REGISTER',
                  press: () {
                    Navigator.pushNamed(context, "register_screen");
                  },
                ),
                const SizedBox(
                  width: 15,
                ),
                SmallButton(
                  text: 'LOGIN',
                  press: () {
                    Navigator.pushNamed(context, "login_screen");
                  },
                ),
              ],
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
                        width: 300,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  LinearGradient linearGradient() {
    return const LinearGradient(
      colors: [
        primaryColor,
        secondaryColor,
        purple,
      ],
      begin: Alignment.topCenter,
      end: Alignment.bottomRight,
    );
  }
}
