import 'package:flutter/material.dart';

class Custombutton extends StatelessWidget {
  final void Function()? onPressed;
  final String title;
  const Custombutton({super.key, this.onPressed, required this.title});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      color: const Color(0xFF005F99),
      textColor: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(45),
      ),
      child: Text(title),
    );
  }
}
