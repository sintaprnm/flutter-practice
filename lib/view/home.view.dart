// ignore_for_file: avoid_print, deprecated_member_use

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/utils/global.colors.dart';
import 'package:flutter_application/view/login.view.dart';
import 'package:flutter_application/view/transactionView/transaksi_anggota.dart' as transaksi;
import 'package:flutter_application/view/userView/list_anggota.dart' as list;
import 'package:flutter_application/view/userView/add_anggota.dart';
// import 'package:flutter_application/view/profile.view.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final myStorage = GetStorage();
  final dio = Dio();
  final apiUrl = 'https://mobileapis.manpits.xyz/api';
  int _selectedIndex = 0;
  late String username;
  late String email;
  list.AnggotaDatas? anggotaDatas;

  static const List<Widget> _widgetOptions = <Widget>[
    // HomeListView(),
    Text('Halaman Beranda'),
    list.AnggotaList(),
    transaksi.TransactionAnggotaList(),
    Text('Halaman Laporan'),
    Text('Halaman Pengaturan'),
  ];

  // @override
  // void initState() {
  //   super.initState();
  //   goUser();
  //   getAnggotaList();
  // }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  AppBar _buildAppBar() {
    username = myStorage.read('name') ?? 'Guest'; // Membaca username dari GetStorage, defaultnya 'Guest' jika tidak ada
    return AppBar(
      leading: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Image.asset(
          'assets/images/logo2.png',
          width: 60,
          height: 60,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
            children: [
              Text(
                username, // Menampilkan username di sini
                style: const TextStyle(
                  color: Colors.pink, 
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 5,),
              GestureDetector(
                onTap: () {
                  goUser();
                },
                child: const CircleAvatar(
                  backgroundImage: AssetImage('assets/images/profiluser.jpeg'),
                ),
              ),
              const SizedBox(width: 5,),
              ElevatedButton(
                onPressed: () {
                  _showLogoutConfirmationDialog(context);
                },
                child: const Icon(Icons.logout, color: Colors.pink),
              )
            ],
          ),
        ),
        //nyambungin ke add anggota
        // Padding(
        //   padding: const EdgeInsets.only(right: 16.0),
        //   child: FloatingActionButton(
        //     onPressed: () {
        //       Navigator.push(
        //         context,
        //         MaterialPageRoute(builder: (context) => AddAnggota()),
        //       );
        //     },
        //     child: const Icon(Icons.add),
        //   ),
        // ),
      ],
    );
  }

  Future<void> getAnggotaList() async {
    try {
      final response = await dio.get(
        '$apiUrl/anggota',
        options: Options(
          headers: {'Authorization': 'Bearer ${myStorage.read('token')}'},
        ),
      );
      Map<String, dynamic> responseData = response.data;
      print(responseData);
      setState(() {
        anggotaDatas = list.AnggotaDatas.fromJson(responseData);
      });
    } on DioError catch (e) {
      if (kDebugMode) {
        print('Error fetching anggota list: ${e.response?.statusCode} - ${e.response?.data}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const   <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.manage_accounts), // Icon untuk menu pinjaman
            label: 'Anggota',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.monetization_on), // Icon untuk riwayat transaksi
            label: 'Transaksi Anggota',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart), // Icon untuk laporan keuangan
            label: 'Laporan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings), // Icon untuk pengaturan
            label: 'Pengaturan',
          ),
        ],
        currentIndex: _selectedIndex,
        unselectedItemColor: Colors.grey,
        selectedItemColor: GlobalColors.mainColor,
        onTap: _onItemTapped,
      ),
        floatingActionButton: _selectedIndex == 1
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddAnggota()),
                );
              },
              child: const Icon(Icons.add, color: Colors.pink),
            )
          : null,
    );
  }

  void _logout() async {
    final myStorage = GetStorage();
    const apiUrl = 'https://mobileapis.manpits.xyz/api';
    final dio = Dio();
    try {
      final response = await dio.get(
        "$apiUrl/logout",
        options: Options(
          headers: {'Authorization': 'Bearer ${myStorage.read('token')}'},
        ),
      );
      if (kDebugMode) {
        print(response.data);
      }
      if (response.data['success'] == true) {
        // Hapus token dari penyimpanan lokal
        myStorage.remove('token');
        // Kembali ke halaman login
        Get.offAll(LoginView(key: UniqueKey()));
      }
    } on DioError catch (e) {
      if (kDebugMode) {
        print(" Error ${e.response?.statusCode} - ${e.response?.data} ");
      }
    }
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Logout"),
          content: const Text("Are you sure to logout??"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Tutup dialog
              },
              child: const Text("No"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Tutup dialog
                _logout(); // Lakukan logout
              },
              child: const Text("Yes"),
            ),
          ],
        );
      },
    );
  }

  void goUser() async {
    try {
      final response = await dio.get(
        "$apiUrl/user",
        options: Options(
          headers: {'Authorization': 'Bearer ${myStorage.read('token')}'},
        ),
      );
      // Perbarui nilai username dengan data yang diperoleh dari respons API
      // setState(() {
      //   username = response.data['name'] ?? 'Guest';
      // });
      print(response.data);
    } on DioError catch (e) {
      if (kDebugMode) {
        print(" Error ${e.response?.statusCode} - ${e.response?.data} ");
      }
    }
  }
}

// class TransactionHistoryView extends StatelessWidget {
//   const TransactionHistoryView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false, // Menghapus tombol kembali (back)
//         title: const Text('Transaksi Anggota'),
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 ElevatedButton(
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => const AnggotaList()),
//                     );
//                   },
//                   child: const Text('Transaksi Baru'),
//                 ),
//                 ElevatedButton(
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => const AnggotaList()),
//                     );
//                   },
//                   child: const Text('Jenis Transaksi'),
//                 ),
//               ],
//             ),
//           ),
//           const Expanded(
//             child: Center(
//               child: Text('No Transactions'),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// Model for Transaction
enum TransactionType { deposit, withdraw }

class Transaction {
  final String id;
  final String date;
  final double amount;
  final TransactionType type;

  Transaction({
    required this.id,
    required this.date,
    required this.amount,
    required this.type,
  });
}
