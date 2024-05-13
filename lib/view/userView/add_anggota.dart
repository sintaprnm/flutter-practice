import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/view/home.view.dart';
import 'package:get_storage/get_storage.dart';

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
          child: Column(
            children: [
              TextFormField(
                controller: nomorIndukController,
                decoration: const InputDecoration(
                  labelText: 'Nomor Induk',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nomor Induk wajib diisi';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: namaController,
                decoration: const InputDecoration(
                  labelText: 'Nama',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama wajib diisi';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: alamatController,
                decoration: const InputDecoration(
                  labelText: 'Alamat',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Alamat wajib diisi';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: tglLahirController,
                decoration: const InputDecoration(
                  labelText: 'Tanggal Lahir (YYYY-MM-DD)',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Tanggal Lahir wajib diisi';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: teleponController,
                decoration: const InputDecoration(
                  labelText: 'Telepon',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Telepon wajib diisi';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Add Anggota API call
                    _addAnggota(
                      // nomorInduk: nomorIndukController.text,
                      // nama: namaController.text,
                      // alamat: alamatController.text,
                      // tglLahir: tglLahirController.text,
                      // telepon: teleponController.text,
                    );
                  }
                  const SizedBox(height: 10);
                },
                child: const Text('Tambah'),
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
            'Content-Type': 'application/json', // Assuming JSON is expected
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
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeView()));
                    // Potentially navigate to anggota list here (optional)
                    // Navigator.pushNamed(context, '/anggota');
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