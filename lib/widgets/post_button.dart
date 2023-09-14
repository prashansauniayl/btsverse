import 'package:flutter/material.dart';

class PostButton extends StatelessWidget {
  final String text;
  final VoidCallback press;

  const PostButton({super.key, required this.text, required this.press});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Container(
        width: 340,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
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
              fontWeight: FontWeight.bold,
              fontFamily: 'Sen',
            ),
          ),
        ),
      ),
    );
  }
}
