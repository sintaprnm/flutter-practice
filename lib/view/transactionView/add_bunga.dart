// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class AddBunga extends StatefulWidget {
  const AddBunga({super.key});

  @override
  State<AddBunga> createState() => _AddBungaState();
}

class _AddBungaState extends State<AddBunga> {
  String _selectedStatus = 'Aktif';
  final TextEditingController _percentageController = TextEditingController();
  final _dio = Dio();
  final _storage = GetStorage();

  final _apiUrl = 'https://mobileapis.manpits.xyz/api';

  void goTambahTransaksi(String percent, int isActive) async {
    try {
      final response = await _dio.post(
        '$_apiUrl/addsettingbunga',
        data: {
          'persen': percent,
          'isaktif': isActive,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${_storage.read('token')}',
          },
        ),
      );

      if (kDebugMode) {
        print(response.data);
      }

      if (response.data["success"] == true) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Tambah Bunga"),
              content: const Text('Tambah Bunga Berhasil ditambahkan.'),
              actions: <Widget>[
                TextButton(
                  child: const Text("OK"),
                  onPressed: () {
                    // Navigator.pop(context); // Close dialog
                    Navigator.pushReplacementNamed(context, '/listBunga');
                  },
                ),
              ],
            );
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Error"),
              content: Text('${response.data["message"]}'),
              actions: <Widget>[
                TextButton(
                  child: const Text("OK"),
                  onPressed: () => Navigator.pop(context), // Close dialog
                ),
              ],
            );
          },
        );
      }
    } on DioException catch (e) {
      if (kDebugMode) {
        print('Dio Error: $e');
      }
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Error"),
            content: const Text('Failed to add bunga. Please try again later.'),
            actions: <Widget>[
              TextButton(
                child: const Text("OK"),
                onPressed: () => Navigator.pop(context), // Close dialog
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2C2C2C),
      appBar: AppBar(
        title: const Text("Tambah Bunga"),
      ),
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.all(32.0),
          padding: const EdgeInsets.all(32.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(32.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Status Bunga",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  Radio(
                    value: 'Aktif',
                    groupValue: _selectedStatus,
                    onChanged: (value) {
                      setState(() {
                        _selectedStatus = value.toString();
                      });
                    },
                  ),
                  const Text('Aktif'),
                  Radio(
                    value: 'Tidak Aktif',
                    groupValue: _selectedStatus,
                    onChanged: (value) {
                      setState(() {
                        _selectedStatus = value.toString();
                      });
                    },
                  ),
                  const Text('Tidak Aktif'),
                ],
              ),
              const SizedBox(height: 16.0),
              const Text(
                "Persentasi Bunga",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextFormField(
                controller: _percentageController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: 'Masukkan persentase bunga',
                ),
              ),
              const SizedBox(height: 32.0),
              Center(
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      var isActive = _selectedStatus == 'Aktif' ? 1 : 0;
                      goTambahTransaksi(_percentageController.text, isActive);
                    },
                    child: const Text('Simpan'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

