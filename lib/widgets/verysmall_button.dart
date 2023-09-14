import 'package:flutter/material.dart';

class VerySmallButton extends StatelessWidget {
  final String text;
  final VoidCallback press;

  const VerySmallButton({super.key, required this.text, required this.press});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: press,
        highlightColor:
            Colors.transparent, // Set highlight color to transparent
        splashColor: Colors.transparent, // Set splash color to transparent
        child: Container(
          width: 60,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            gradient: const LinearGradient(
              colors: [
                Color(0xff4259EF),
                Color(0xff8150F4),
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          child: Center(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontFamily: 'Sen',
              ),
            ),
          ),
        ),
      ),
    );
  }
}
