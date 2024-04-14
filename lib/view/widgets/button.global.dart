// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_application/utils/global.colors.dart';

class ButtonGlobal extends StatelessWidget {
  final VoidCallback onPressed; // Menggunakan VoidCallback
  final String text;
  const ButtonGlobal({super.key, required this.onPressed, required this.text});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        alignment: Alignment.center,
        height: 40,
        width: 130,
        decoration: BoxDecoration(
          color: GlobalColors.mainColor,
          borderRadius: BorderRadius.circular(6),
          boxShadow: const [
            BoxShadow(
              color: Colors.black,
              blurRadius: 3,
            ),
          ]
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}