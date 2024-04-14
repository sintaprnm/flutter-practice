import 'package:flutter/material.dart';
import 'package:flutter_application/utils/global.colors.dart';
import 'package:flutter_application/view/home.view.dart';
import 'package:flutter_application/view/register.view.dart';
import 'package:flutter_application/view/widgets/button.global.dart';
import 'package:flutter_application/view/widgets/password.field.dart';
import 'package:flutter_application/view/widgets/social.login.dart';
import 'package:flutter_application/view/widgets/text.form.global.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<StatefulWidget> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  bool isPasswordVisible = false;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
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
                    controller: emailController,
                    text: 'Email',
                    obscure: false,
                    textInputType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 15),
                  //// Password Input
                  PasswordField(
                    controller: passwordController,
                    isVisible: isPasswordVisible,
                    key: const ValueKey('password_field'),
                  ),
                  const SizedBox(height: 4),
                  ButtonGlobal(
                    onPressed: () {
                    // Navigasi ke halaman beranda dan mengganti seluruh stack route dengan halaman beranda
                    Navigator.pushReplacement(
                      context,
                       MaterialPageRoute(builder: (context) => const HomeView(key: ValueKey('home_page'),))
                    );
                  },
                    // onPressed: validateAndLogin, 
                    text: 'Log In',),
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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const RegisterView(key: ValueKey('register_page'),)
                  ),
              );
            },
          ),
        ],
      ),
    ),
  );
}