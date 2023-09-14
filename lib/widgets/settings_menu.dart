import 'package:flutter/material.dart';

class SettingMenu extends StatelessWidget {
  final String text, icon;
  final VoidCallback press;

  const SettingMenu(
      {super.key, required this.text, required this.icon, required this.press});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 18,
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: TextButton(
          style: ButtonStyle(
            overlayColor: MaterialStateProperty.all(Colors.white12),
            backgroundColor: MaterialStateProperty.all(Colors.white10),
            padding: MaterialStateProperty.all(
              const EdgeInsets.all(18),
            ),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          onPressed: press,
          child: Row(
            children: [
              Image.asset(
                icon,
                width: 18,
                color: Colors.white,
              ),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                child: Text(
                  text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontFamily: 'Sen',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
