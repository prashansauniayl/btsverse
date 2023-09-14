import 'package:btsverse/utils/color.dart';
import 'package:btsverse/widgets/small_button.dart';
import 'package:flutter/material.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({Key? key}) : super(key: key);

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
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
              'Share Your BTS Moment',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Sen',
                fontSize: 24,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Share your BTS moments, photos, \n and stories with ARMYs worldwide. Connect, \n inspire, and engage',
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
                  text: 'POST IMAGE',
                  press: () {
                    Navigator.pushNamed(context, "imagepost_screen");
                  },
                ),
                const SizedBox(
                  width: 15,
                ),
                SmallButton(
                  text: 'POST STORY',
                  press: () {
                    Navigator.pushNamed(context, "storypost_screen");
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
