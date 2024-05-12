// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/utils/global.colors.dart';
import 'package:flutter_application/view/home.view.dart';
import 'package:flutter_application/view/register.view.dart';
// import 'package:flutter_application/view/widgets/button.global.dart';
import 'package:flutter_application/view/widgets/password.field.dart';
import 'package:flutter_application/view/widgets/social.login.dart';
import 'package:flutter_application/view/widgets/text.form.global.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/route_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logger/logger.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<StatefulWidget> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  bool isPasswordVisible = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  // final RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  // String? emailError;

  // void validateAndLogin() {
  //   final email = emailController.text.trim();
  //   if (!emailRegex.hasMatch(email)) {
  //     // Show warning message if email format is invalid
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text('Invalid email format'),
  //         backgroundColor: Colors.red,
  //       ),
  //     );
  //     return;
  //   }
  // }
  
  final myStorage = GetStorage();
  final secureStorage = const FlutterSecureStorage();
  final logger = Logger();
  final dio = Dio();
  final apiUrl = 'https://mobileapis.manpits.xyz/api/';

  void _saveUserData() {
  // Implementasi logika penyimpanan data pengguna ke dalam GetStorage
  myStorage.write('email', _emailController.text);
  myStorage.write('password', _passwordController.text);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SingleChildScrollView(
      child: SafeArea(
        child: Container(
          // color: Colors.green,
          width: double.infinity,
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.center,
                child: Image.asset(
                  'assets/images/logo2.png',
                  width: 300,
                  height: 200,
                ),
              ),
              const SizedBox(height: 50),
              Text(
                'Log in to your account!',
                style: TextStyle(
                  color: GlobalColors.textColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                width: MediaQuery.of(context).size.width * 0.85, // Mengatur lebar menjadi 60% dari lebar layar
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: GlobalColors.mainColor.withOpacity(0.9),
                      blurRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                children: [
                  //// Email Input
                  TextFormGlobal(
                    controller: _emailController,
                    text: 'Email',
                    obscure: false,
                    textInputType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 15),
                  //// Password Input
                  PasswordField(
                    controller: _passwordController,
                    isVisible: isPasswordVisible,
                    key: const ValueKey('password_field'),
                  ),
                  const SizedBox(height: 4),
                  //menambahkan button login
                  ElevatedButton(
                    onPressed: () => validateAndLogin(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: GlobalColors.mainColor,
                      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 30.0),
                    ),
                    child: const Text('Log In', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),),
                  ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Forget password?',
                          style: TextStyle(fontSize: 11),
                        ),
                        InkWell(
                          child: Text(
                            ' Reset Password',
                            style: TextStyle(
                              color: GlobalColors.mainColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                          onTap: () {
                            // Logic untuk menangani ketika teks "Reset Password" diklik
                          },
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                ],
              ),
              // const SizedBox(height: 10),
              // ButtonGlobal(onPressed: validateAndLogin),
              // const SizedBox(height: 15),
              // const SocialLogin(),
            ),
          const SizedBox(height: 40),
          const SocialLogin(),
          ],
          ),
        ),
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
            'Don\'t have an account?',
            style: TextStyle(fontSize: 13),
          ),
          InkWell(
            child: Text(
              ' Sign Up',
              style: TextStyle(
                color: GlobalColors.mainColor,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
            onTap: () {
              // Navigate to the registration page
              Get.to(RegisterView(key: UniqueKey(),));
            },
          ),
        ],
      ),
    ),
  );

  void validateAndLogin() async {
  bool isEmailValid = _emailController.text.isNotEmpty;
  bool isPasswordValid = _passwordController.text.isNotEmpty;
  String email = _emailController.text;
  String password = _passwordController.text;

  if (!isEmailValid || !isPasswordValid) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please fill in all fields'),
        backgroundColor: Colors.red,
      ),
    );
    return;
  }

  try {
    // Send login data to API
    Response response = await Dio().post(
      'https://mobileapis.manpits.xyz/api/login',
      data: {
        'email': email,
        'password': password,
      },
       options: Options(contentType: 'application/x-www-form-urlencoded',),
    );

    // Check if login is successful
    if (response.statusCode == 200) {
      // Handle successful login
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login successful'),
          backgroundColor: Colors.green,
        ),
      );

    _saveUserData();
        if (kDebugMode) {
         print(response.data);
        }
        myStorage.write('token', response.data['data']['token']); 

      // Navigate user to home page
      Get.to(HomeView(key: UniqueKey(),));
    } else {
      // Handle login failure
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login failed'),
          backgroundColor: Colors.red,
        ),
      );
    }
  } catch (e) {
    // Handle errors
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('An error occurred during login'),
        backgroundColor: Colors.red,
      ),
    );
    if (kDebugMode) {
      print('Error during login: $e');
    }
  }
}
}