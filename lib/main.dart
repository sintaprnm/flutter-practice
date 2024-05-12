import 'package:flutter/material.dart';
import 'package:flutter_application/view/home.view.dart';
import 'package:flutter_application/view/login.view.dart';
import 'package:flutter_application/view/register.view.dart';
import 'package:flutter_application/view/splash.view.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logger/logger.dart';

void main() async {
  await GetStorage.init();
  runApp(App());
}

class App extends StatelessWidget {
  App({super.key});

  final dio = Dio();
  final myStorage = GetStorage();
  final secureStorage = const FlutterSecureStorage();
  final apiurl = 'https://mobileapis.manpits.xyz/api/';
  final Logger logger = Logger();

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => const SplashView()),
        GetPage(name: '/login', page: () => const LoginView()),
        GetPage(name: '/register', page: () => const RegisterView(key: ValueKey('register_page'))),
        GetPage(name: '/user', page: () => const HomeView(key: ValueKey('user_info'))),
      ],
    );
  }
}
