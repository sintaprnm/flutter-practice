// // ignore_for_file: avoid_print

// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_application/utils/global.colors.dart';
// import 'package:flutter_application/view/login.view.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';

// class ProfileView extends StatefulWidget {
//   const ProfileView({super.key});

//   @override
//   State<ProfileView> createState() => _ProfileViewState();
// }

// class _ProfileViewState extends State<ProfileView> {
//   final dio = Dio();
//   final apiUrl = 'https://mobileapis.manpits.xyz/api';
//   final myStorage = GetStorage();
//   final TextEditingController _usernameController = TextEditingController(text: '');
//   final TextEditingController _emailController = TextEditingController();
//   // late TextEditingController usernameController;
//   // late TextEditingController emailController;

//   @override
//   void initState() {
//     super.initState();
//     // _usernameController = TextEditingController();
//     // _emailController = TextEditingController();
//     getUserData();
//   }

//   Future<void> getUserData() async {
//     final dio = Dio();
//     const apiUrl = 'https://mobileapis.manpits.xyz/api';
//     final myStorage = GetStorage();
//     try {
//       final response = await dio.get(
//       '$apiUrl/user',
//       options: Options(
//       headers: {'Authorization': 'Bearer ${myStorage.read('token')}'},
//       ),
//       );
//         print('Response: $response');

//       if (response.data['success'] == true) {
//         final userData = response.data['data']['user'];
//         setState(() {
//           _usernameController.text = userData['name'];
//           _emailController.text = userData['email'];
//         });
//       }
//     } catch (error) {
//         print('Error occurred: $error');
//       }
//     }
    
//   void _showEditProfileSheet() {
//     showModalBottomSheet(
//       context: context,
//       builder: (BuildContext context) {
//         return Container(
//           padding: const EdgeInsets.all(20.0),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text(
//                 'Edit Profile',
//                 style: TextStyle(
//                   fontSize: 20.0,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 20.0),
//               TextField(
//                 controller: _usernameController,
//                 decoration: const InputDecoration(labelText: 'Name'),
//               ),
//               const SizedBox(height: 20.0),
//               TextField(
//                 controller: _emailController,
//                 decoration: const InputDecoration(labelText: 'Email'),
//               ),
//               const SizedBox(height: 20.0),
//               ElevatedButton(
//                 onPressed: () {
//                   // _saveProfileChanges(nameController.text, emailController.text);
//                   // Navigator.pop(context);
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: GlobalColors.mainColor,
//                 ),
//                 child: const Text('Save'),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   // void saveProfileChanges(String newName, String newEmail) async {
//   //   final myStorage = GetStorage();
//   //   final apiUrl = 'https://mobileapis.manpits.xyz/api';
//   //   final dio = Dio();

//   //   try {
//   //     final response = await dio.put(
//   //       '$apiUrl/anggota/72',
//   //       data: {
//   //         'nomor_induk': '1',
//   //         'nama': newName,
//   //         'alamat': 'Br. Dajan Peken Blahkiuh',
//   //         'tgl_lahir': '2000-03-31',
//   //         'telepon': '08414124124',
//   //         'status_aktif': '1',
//   //       },
//   //       options: Options(
//   //         headers: {'Authorization': 'Bearer ${myStorage.read('token')}'},
//   //       ),
//   //     );

//   //     print('Response: $response');

//   //     if (response.data['success'] == true) {
//   //       // Data successfully updated
//   //       // You can handle success response here
//   //     } else {
//   //       // Handle error response
//   //       print('Error: ${response.data['message']}');
//   //     }
//   //   } catch (error) {
//   //     print('Error occurred: $error');
//   //     // Handle network error or other errors
//   //   }
//   // }

//   // void _logout() async {
//   //   final myStorage = GetStorage();
//   //   const apiUrl = 'https://mobileapis.manpits.xyz/api';
//   //   final dio = Dio();
//   //   try {
//   //     final response = await dio.get(
//   //       "$apiUrl/logout",
//   //       options: Options(
//   //         headers: {'Authorization': 'Bearer ${myStorage.read('token')}'},
//   //       ),
//   //     );
//   //     print(response.data);
//   //     // myStorage.remove('token');
//   //     // print(myStorage.read('token'));

//   //     if (response.data['success'] == true) {
//   //     Get.offAll(LoginView(key: UniqueKey())); // Navigate ke halaman login
//   //     }
//   //   } on DioException catch (e) {
//   //     print(" Error ${e.response?.statusCode} - ${e.response?.data} ");
//   //   }
//   // }

//   @override
//   Widget build(BuildContext context) {
//     final myStorage = GetStorage();
//     final String username = myStorage.read('name') ?? 'Guest';
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Profile'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const CircleAvatar(
//               backgroundImage: AssetImage('assets/images/profiluser.jpeg'),
//               radius: 50,
//             ),
//             const SizedBox(height: 20),
//             Text(
//               'Hello, $username',
//               style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 _showEditProfileSheet();
//               },
//               style: ElevatedButton.styleFrom(backgroundColor: GlobalColors.mainColor),
//               child: const Text('Edit Profile'),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _logout,
//               style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//               child: const Text('Log out'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _logout() async {
//     final myStorage = GetStorage();
//     const apiUrl = 'https://mobileapis.manpits.xyz/api';
//     final dio = Dio();
//     try {
//       final response = await dio.get(
//         "$apiUrl/logout",
//         options: Options(
//           headers: {'Authorization': 'Bearer ${myStorage.read('token')}'},
//         ),
//       );
//       print(response.data);
//       // myStorage.remove('token');
//       // print(myStorage.read('token'));

//       if (response.data['success'] == true) {
//       Get.offAll(LoginView(key: UniqueKey())); // Navigate ke halaman login
//       }
//     } on DioException catch (e) {
//       print(" Error ${e.response?.statusCode} - ${e.response?.data} ");
//     }
//   }
// }