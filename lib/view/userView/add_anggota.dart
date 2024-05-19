import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/utils/global.colors.dart';
import 'package:flutter_application/view/home.view.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

class AddAnggota extends StatefulWidget {
  const AddAnggota({super.key});

  @override
  State<AddAnggota> createState() => _AddAnggotaState();
}

class _AddAnggotaState extends State<AddAnggota> {
  final _formKey = GlobalKey<FormState>();
  final Dio dio = Dio();
  final myStorage = GetStorage();
  final apiUrl = 'https://mobileapis.manpits.xyz/api/anggota';

  // Form fields
  final nomorIndukController = TextEditingController();
  final namaController = TextEditingController();
  final alamatController = TextEditingController();
  final tglLahirController = TextEditingController();
  final teleponController = TextEditingController();
  DateTime? _tglLahir;

  Future<void> _selectDate() async {
    DateTime? _picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (_picked != null) {
      setState(() {
        _tglLahir = _picked;
        tglLahirController.text = DateFormat('yyyy-MM-dd').format(_picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Anggota'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              const SizedBox(height: 10),
              TextFormField(
                controller: nomorIndukController,
                decoration: const InputDecoration(
                  labelText: 'Nomor Induk',
                  hintText: 'Masukkan nomor induk',
                  prefixIcon: Icon(Icons.perm_identity, color: Colors.pink),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nomor Induk wajib diisi';
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: namaController,
                decoration: const InputDecoration(
                  labelText: 'Nama',
                  hintText: 'Masukkan nama',
                  prefixIcon: Icon(Icons.face, color: Colors.pink),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: alamatController,
                decoration: const InputDecoration(
                  labelText: 'Alamat',
                  hintText: 'Masukkan alamat',
                  prefixIcon: Icon(Icons.house, color: Colors.pink),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Alamat wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: tglLahirController,
                decoration: const InputDecoration(
                  labelText: 'Tanggal Lahir (YYYY-MM-DD)',
                  hintText: 'Masukkan tanggal lahir',
                  prefixIcon: Icon(Icons.calendar_today, color: Colors.pink),
                ),
                readOnly: true,
                onTap: _selectDate,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Tanggal Lahir wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: teleponController,
                decoration: const InputDecoration(
                  labelText: 'Telepon',
                  hintText: 'Masukkan nomor telepon',
                  prefixIcon: Icon(Icons.phone, color: Colors.pink),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Telepon wajib diisi';
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _addAnggota();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: GlobalColors.mainColor,
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 10),
                ),
                child: const Text(
                  'Tambah',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _addAnggota() async {
    try {
      print('nomorIndukController.text: ${nomorIndukController.text}');

      final formData = FormData.fromMap({
        'nomor_induk': nomorIndukController.text,
        'nama': namaController.text,
        'alamat': alamatController.text,
        'tgl_lahir': tglLahirController.text,
        'telepon': teleponController.text,
      });

      final response = await dio.post(
        apiUrl,
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${myStorage.read('token')}',
          },
        ),
      );

      print(response.data); // Print the response for debugging

      if (response.statusCode == 200) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Anggota berhasil ditambahkan!"),
              content: const Text('Yeay!'),
              actions: <Widget>[
                TextButton(
                  child: const Text("OK"),
                  onPressed: () {
                    // Bersihkan nilai pada controller teks
                    nomorIndukController.clear();
                    namaController.clear();
                    alamatController.clear();
                    tglLahirController.clear();
                    teleponController.clear();
                    Navigator.pop(context); // Close the dialog
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeView()));
                  },
                ),
              ],
            );
          },
        );
      } else {
        // Handle non-200 status codes (e.g., display error message)
        print('Error adding anggota: ${response.data}');
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Oops!"),
              content: Text(response.data['message'] ?? 'An error occurred'),
              actions: <Widget>[
                TextButton(
                  child: const Text("OK"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          },
        );
      }
    } on DioError catch (e) {
      // Handle Dio exceptions (e.g., network errors)
      print('${e.response} - ${e.response?.statusCode}');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Oops!"),
            content: const Text('An error occurred. Please check your network connection or try again later.'),
            actions: <Widget>[
              TextButton(
                child: const Text("OK"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    }
  }
}
