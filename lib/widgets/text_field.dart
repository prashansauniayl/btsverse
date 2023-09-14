import 'package:btsverse/utils/color.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController textEditingController;
  final bool obscureText;
  final IconData icon;

  const CustomTextField({
    Key? key,
    required this.hintText,
    required this.textEditingController,
    required this.icon,
    required this.obscureText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [purple, secondaryColor],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Icon(
                icon,
                color: Colors.white.withOpacity(0.7),
              ),
            ),
            Expanded(
              child: TextField(
                obscureText: obscureText,
                controller: textEditingController,
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'pal',
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: hintText,
                  hintStyle: const TextStyle(
                    color: Colors.white70,
                    fontFamily: 'pal',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
