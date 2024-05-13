import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/utils/global.colors.dart';
import 'package:flutter_application/view/login.view.dart';
import 'package:flutter_application/view/userView/add_anggota.dart';
import 'package:flutter_application/view/userView/list_anggota.dart';
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
  AnggotaDatas? anggotaDatas;

  static const List<Widget> _widgetOptions = <Widget>[
    // HomeListView(),
    AnggotaList(),
    Text('Halaman Pinjaman'),
    TransactionHistoryView(),
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
        anggotaDatas = AnggotaDatas.fromJson(responseData);
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
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.monetization_on), // Icon untuk menu pinjaman
            label: 'Loan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history), // Icon untuk riwayat transaksi
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart), // Icon untuk laporan keuangan
            label: 'Report',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings), // Icon untuk pengaturan
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        unselectedItemColor: Colors.grey,
        selectedItemColor: GlobalColors.mainColor,
        onTap: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            // ignore: prefer_const_constructors
            MaterialPageRoute(builder: (context) => AddAnggota()),
          );
        },
        child: const Icon(Icons.add),
      ),
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

class TransactionHistoryView extends StatelessWidget {
  const TransactionHistoryView({super.key});
 
  @override
  Widget build(BuildContext context) {
    // Dummy transaction list
    final List<Transaction> transactions = [
      Transaction(id: '1', date: '2024-04-28', amount: 500, type: TransactionType.deposit),
      Transaction(id: '2', date: '2024-04-27', amount: 200, type: TransactionType.withdraw),
      Transaction(id: '3', date: '2024-04-26', amount: 1000, type: TransactionType.deposit),
      Transaction(id: '4', date: '2024-04-25', amount: 300, type: TransactionType.withdraw),
    ];

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Menghapus tombol kembali (back)
        title: const Text('Transaction History'),
      ),
      body: ListView.builder(
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          final transaction = transactions[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: transaction.type == TransactionType.deposit ? Colors.green : Colors.red,
              child: Icon(
                transaction.type == TransactionType.deposit ? Icons.arrow_downward : Icons.arrow_upward,
                color: Colors.white,
              ),
            ),
            title: Text('Transaction ID: ${transaction.id}'),
            subtitle: Text('Date: ${transaction.date}'),
            trailing: Text(
              transaction.type == TransactionType.deposit ? '+${transaction.amount}' : '-${transaction.amount}',
              style: TextStyle(
                color: transaction.type == TransactionType.deposit ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        },
      ),
    );
  }
}

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
