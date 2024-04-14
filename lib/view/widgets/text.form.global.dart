import 'package:flutter/material.dart';

class TextFormGlobal extends StatelessWidget {
  const TextFormGlobal (
    {super.key, 
    required this.controller, 
    required this.text, 
    required this.textInputType, 
    required this.obscure}
    );
  final TextEditingController controller;
  final String text;
  final TextInputType textInputType;
  final bool obscure; 


  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.only(top: 3.5, left: 20, right: 30),
      decoration: const BoxDecoration(
        color: Colors.white,
        // borderRadius: BorderRadius.circular(6),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.black.withOpacity(0.1),
        //     blurRadius: 7,
        //   ),
        // ],
      ),
      child: TextFormField(
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        controller: controller,
        keyboardType: textInputType,
        obscureText: obscure,
        decoration: InputDecoration(
          hintText: text,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 5
          ), // Mengatur padding konten
          hintStyle: const TextStyle(
            height: 1,
          ),
          focusedBorder: const UnderlineInputBorder( // Mengatur border saat input mendapatkan fokus
            borderSide: BorderSide(color: Colors.blue), // Warna underline saat input mendapatkan fokus
          ),
          enabledBorder: const UnderlineInputBorder( // Mengatur border saat input tidak dalam keadaan aktif
            borderSide: BorderSide(color: Colors.grey), // Warna underline saat input tidak dalam keadaan aktif
          ),
          // Set floatingLabelBehavior to FloatingLabelBehavior.always
          floatingLabelBehavior: FloatingLabelBehavior.always,
        ),
      ),
    );
  }
}