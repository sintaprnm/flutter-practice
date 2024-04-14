// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class PasswordField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool isVisible;

  const PasswordField({
    required Key key,
    required this.controller,
    this.hintText = 'Password',
    this.isVisible = false,
  }) : super(key: key);

  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  late bool _isVisible; // Ubah menjadi late
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _isVisible = widget.isVisible; // Assign nilai awal isVisible
  }

  void _validatePassword(String value) {
    setState(() {
      _errorMessage = null; // Reset error message

      if (value.length < 8) {
        _errorMessage = 'The password must have a minimum of 8 characters';
      } else if (!value.contains(RegExp(r'\d'))) {
        _errorMessage = 'The password must contain at least one number';
      } else if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
        _errorMessage = 'The password must contain at least one special character';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 75,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            controller: widget.controller,
            obscureText: !_isVisible, // Menggunakan _isVisible
            onChanged: _validatePassword,
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: const TextStyle(
                fontSize: 14, // Ukuran font untuk hint text
                fontWeight: FontWeight.bold,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _isVisible ? Icons.visibility : Icons.visibility_off,
                ),
                iconSize: 20,
                onPressed: () {
                  setState(() {
                    _isVisible = !_isVisible; // Mengubah nilai _isVisible
                  });
                },
              ),
            ),
          ),
          if (_errorMessage != null)
            Padding(
              padding: const EdgeInsets.only(top: 2.0),
              child: Text(
                _errorMessage!,
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 10,
                ),
              ),
            ),
        ],
      ),
    );
  }
}