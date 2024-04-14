import 'package:flutter/material.dart';
import 'package:flutter_application/utils/global.colors.dart';
import 'package:flutter_application/view/home.view.dart';
import 'package:flutter_application/view/login.view.dart';
import 'package:flutter_application/view/widgets/button.global.dart';
import 'package:flutter_application/view/widgets/password.field.dart';
import 'package:flutter_application/view/widgets/social.regist.dart';
import 'package:flutter_application/view/widgets/text.form.global.dart';
// import 'package:fl_country_code_picker/fl_country_code_picker.dart' as flc;

enum Gender { male, female, unspecified }

class RegisterView extends StatefulWidget {
  const RegisterView({required Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _RegisterViewState();
}
 
class _RegisterViewState extends State<RegisterView> {
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

  Gender selectedGender = Gender.unspecified;
  // String selectedCountryCode = '+62'; // Default country code

  void validateAndRegister() {
    final email = emailController.text.trim();
    if (!emailRegex.hasMatch(email)) {
      // Show warning message if email format is invalid
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid email format'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;
    if (password != confirmPassword) {
      // Show warning message if passwords do not match
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Passwords do not match'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Perform registration logic here
    // Jika email dan password valid, maka navigasikan pengguna ke halaman beranda
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const HomeView(key: ValueKey('home_page'),)
      ),
    );
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
                    controller: usernameController,
                    text: 'Username',
                    obscure: false,
                    textInputType: TextInputType.text,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormGlobal(
                          controller: firstNameController,
                          text: 'First Name',
                          obscure: false,
                          textInputType: TextInputType.text,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextFormGlobal(
                          controller: lastNameController,
                          text: 'Last Name',
                          obscure: false,
                          textInputType: TextInputType.text,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  // Radio for Gender
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text('Gender:'),
                      Row(
                        children: [
                          Flexible(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Radio<Gender>(
                                  value: Gender.male,
                                  groupValue: selectedGender,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedGender = value!;
                                    });
                                  },
                                ),
                                const Text('Male', style: TextStyle(fontSize: 12),),
                              ],
                            ),
                          ),
                          const SizedBox(width: 1), // SizedBox untuk jarak antara Male dan Female
                          Flexible(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Radio<Gender>(
                                  value: Gender.female,
                                  groupValue: selectedGender,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedGender = value!;
                                    });
                                  },
                                ),
                                const Text('Female', style: TextStyle(fontSize: 12),),
                              ],
                            ),
                          ),
                          // const SizedBox(width: 1), // SizedBox untuk jarak antara Female dan Unspecified
                          // Flexible(
                          //   child: Row(
                          //     mainAxisAlignment: MainAxisAlignment.start,
                          //     children: [
                          //       Radio<Gender>(
                          //         value: Gender.unspecified,
                          //         groupValue: selectedGender,
                          //         onChanged: (value) {
                          //           setState(() {
                          //             selectedGender = value!;
                          //           });
                          //         },
                          //       ),
                          //       const Text('Unspecified', style: TextStyle(fontSize: 11),),
                          //     ],
                          //   ),
                          // ),
                          const Padding(padding: EdgeInsets.symmetric(horizontal: 10.0),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  TextFormGlobal(
                    controller: emailController,
                    text: 'Email',
                    obscure: false,
                    textInputType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 10),
                  PasswordField(
                    controller: passwordController,
                    isVisible: isPasswordVisible,
                    key: const ValueKey('password_field'),
                  ),
                  // const SizedBox(height: 10),
                  PasswordField(
                    controller: confirmPasswordController,
                    isVisible: isConfirmPasswordVisible,
                    key: const ValueKey('confirm_password_field'),
                  ),
                  const SizedBox(height: 10),
                  ButtonGlobal(
                    text: 'Sign Up',
                    onPressed: validateAndRegister,
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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginView(key: ValueKey('login_page'),)
                  ),
              );
            },
          ),
        ],
      ),
    ),
    );
  }
}