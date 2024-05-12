// ignore_for_file: use_build_context_synchronously

// import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/utils/global.colors.dart';
// import 'package:flutter_application/view/home.view.dart';
import 'package:flutter_application/view/login.view.dart';
// import 'package:flutter_application/view/widgets/button.global.dart';
import 'package:flutter_application/view/widgets/password.field.dart';
import 'package:flutter_application/view/widgets/social.regist.dart';
import 'package:flutter_application/view/widgets/text.form.global.dart';
import 'package:get/route_manager.dart';
// import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';
// import 'package:fl_country_code_picker/fl_country_code_picker.dart' as flc;

// enum Gender { male, female }

class RegisterView extends StatefulWidget {
  const RegisterView({required Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _RegisterViewState();
}
 
class _RegisterViewState extends State<RegisterView> {
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
  
  final TextEditingController _usernameController = TextEditingController(text: '');
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  // final TextEditingController genderController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

  // Gender selectedGender = Gender.male;
  // String selectedCountryCode = '+62'; // Default country code

  final myStorage = GetStorage();
  final secureStorage = const FlutterSecureStorage();
  final logger = Logger();
  final dio = Dio();
  final apiUrl = 'https://mobileapis.manpits.xyz/api/';

  void _saveUserData() {
  // Implementasi logika penyimpanan data pengguna ke dalam GetStorage
  myStorage.write('name', _usernameController.text);
  myStorage.write('email', _emailController.text);
  myStorage.write('password', _passwordController.text);
}

Future<void> _registerUser() async{
  String email = _emailController.text;
  String password = _passwordController.text;
  String username = _usernameController.text;
  try {
      // Send registration data to API
      Response response = await Dio().post(
        'https://mobileapis.manpits.xyz/api/register', // Menggunakan endpoint yang sesuai
        data: {
          'name': username,
          'email': email,
          'password': password,
        },
        options: Options(contentType: 'application/x-www-form-urlencoded',),
      );

      if (kDebugMode) {
        print(response.data);
      }
      
      // Check if registration is successful
      if (response.statusCode == 200) {
        // Handle successful registration
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registration successful'),
            backgroundColor: Colors.green,
          ),
        );

        _saveUserData();
        if (kDebugMode) {
         print(response.data);
        }

        // Navigate user to login page
        Get.to(const LoginView(key: ValueKey('login_page')));
      } else {
        // Handle registration failure
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registration failed'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      logger.e('Error during registration: $e');
      if (kDebugMode) {
        print('Error: $e');
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An error occurred during registration'),
          backgroundColor: Colors.red,
        ),
      );
    }
  } 
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/logo2.png',
                    width: 150,
                    height: 100,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Register your account here',
                    style: TextStyle(
                      color: GlobalColors.textColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  // const SizedBox(height: 5),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.80, // Mengatur lebar menjadi 60% dari lebar layar
              padding: const EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: GlobalColors.mainColor.withOpacity(0.9),
                    blurRadius: 2,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormGlobal(
                    controller: _usernameController,
                    text: 'Username',
                    obscure: false,
                    textInputType: TextInputType.text,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormGlobal(
                          controller: _firstNameController,
                          text: 'First Name',
                          obscure: false,
                          textInputType: TextInputType.text,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextFormGlobal(
                          controller: _lastNameController,
                          text: 'Last Name',
                          obscure: false,
                          textInputType: TextInputType.text,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  // // Radio for Gender
                  // Column(
                  //   crossAxisAlignment: CrossAxisAlignment.stretch,
                  //   children: [
                  //     const Text('Gender:'),
                  //     Row(
                  //       children: [
                  //         Flexible(
                  //           child: Row(
                  //             mainAxisAlignment: MainAxisAlignment.center,
                  //             children: [
                  //               Radio<Gender>(
                  //                 value: Gender.male,
                  //                 groupValue: selectedGender,
                  //                 onChanged: (value) {
                  //                   setState(() {
                  //                     selectedGender = value!;
                  //                   });
                  //                 },
                  //               ),
                  //               const Text('Male', style: TextStyle(fontSize: 12),),
                  //             ],
                  //           ),
                  //         ),
                  //         const SizedBox(width: 1), // SizedBox untuk jarak antara Male dan Female
                  //         Flexible(
                  //           child: Row(
                  //             mainAxisAlignment: MainAxisAlignment.center,
                  //             children: [
                  //               Radio<Gender>(
                  //                 value: Gender.female,
                  //                 groupValue: selectedGender,
                  //                 onChanged: (value) {
                  //                   setState(() {
                  //                     selectedGender = value!;
                  //                   });
                  //                 },
                  //               ),
                  //               const Text('Female', style: TextStyle(fontSize: 12),),
                  //             ],
                  //           ),
                  //         ),
                  //         // const SizedBox(width: 1), // SizedBox untuk jarak antara Female dan Unspecified
                  //         // Flexible(
                  //         //   child: Row(
                  //         //     mainAxisAlignment: MainAxisAlignment.start,
                  //         //     children: [
                  //         //       Radio<Gender>(
                  //         //         value: Gender.unspecified,
                  //         //         groupValue: selectedGender,
                  //         //         onChanged: (value) {
                  //         //           setState(() {
                  //         //             selectedGender = value!;
                  //         //           });
                  //         //         },
                  //         //       ),
                  //         //       const Text('Unspecified', style: TextStyle(fontSize: 11),),
                  //         //     ],
                  //         //   ),
                  //         // ),
                  //         const Padding(padding: EdgeInsets.symmetric(horizontal: 10.0),
                  //         ),
                  //       ],
                  //     ),
                  //   ],
                  // ),
                  const SizedBox(height: 5),
                  TextFormGlobal(
                    controller: _emailController,
                    text: 'Email',
                    obscure: false,
                    textInputType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 10),
                  PasswordField(
                    controller: _passwordController,
                    isVisible: isPasswordVisible,
                    key: const ValueKey('password_field'),
                  ),
                  // const SizedBox(height: 10),
                  PasswordField(
                    controller: _confirmPasswordController,
                    isVisible: isConfirmPasswordVisible,
                    key: const ValueKey('confirm_password_field'),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed:(){
                      _registerUser();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: GlobalColors.mainColor,
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                    ),
                    child: const Text('Sign Up', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            const SocialRegist(),
          ],
        ),
      ),
      bottomNavigationBar: Container(
      height: 40,
      color: Colors.white,
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Already have an account?',
            style: TextStyle(fontSize: 13),
          ),
          InkWell(
            child: Text(
              ' Log In',
              style: TextStyle(
                color: GlobalColors.mainColor,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
            onTap: () {
              // Navigate to the registration page
              Get.to(const LoginView(key: ValueKey('login_page')),
              );
            },
          ),
        ],
      ),
    ),
    );
  }
}