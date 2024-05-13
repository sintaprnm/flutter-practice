import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class EditAnggotaPage extends StatefulWidget {
  final int anggotaId;

  const EditAnggotaPage({Key? key, required this.anggotaId}) : super(key: key);

  @override
  _EditAnggotaPageState createState() => _EditAnggotaPageState();
}

class _EditAnggotaPageState extends State<EditAnggotaPage> {
  final dio = Dio();
  final myStorage = GetStorage();
  final myApiUrl = 'https://mobileapis.manpits.xyz/api';
  final myFormKey = GlobalKey<FormState>();

  late TextEditingController namaController;
  late TextEditingController alamatController;
  late TextEditingController tglLahirController;
  late TextEditingController teleponController;

  Map<String, dynamic>? anggotaData;

  @override
  void initState() {
    super.initState();
    // Initialize controllers
    namaController = TextEditingController();
    alamatController = TextEditingController();
    tglLahirController = TextEditingController();
    teleponController = TextEditingController();
    // Fetch and display anggota data
    _getAnggotaData();
  }

  @override
  void dispose() {
    // Dispose controllers
    namaController.dispose();
    alamatController.dispose();
    tglLahirController.dispose();
    teleponController.dispose();
    super.dispose();
  }

  Future<void> _getAnggotaData() async {
    try {
      final response = await dio.get(
        '$myApiUrl/anggota/${widget.anggotaId}',
        options: Options(
          headers: {'Authorization': 'Bearer ${myStorage.read('token')}'},
        ),
      );
      setState(() {
        anggotaData = response.data['data'];
        // Set initial values for form fields
        namaController.text = anggotaData?['nama'] ?? '';
        alamatController.text = anggotaData?['alamat'] ?? '';
        tglLahirController.text = anggotaData?['tgl_lahir'] ?? '';
        teleponController.text = anggotaData?['telepon'] ?? '';
      });
    } catch (e) {
      print('Error retrieving anggota data: $e');
    }
  }

  Future<void> _updateAnggotaData() async {
    try {
      final response = await dio.put(
        '$myApiUrl/anggota/${widget.anggotaId}',
        data: {
          'nama': namaController.text,
          'alamat': alamatController.text,
          'tgl_lahir': tglLahirController.text,
          'telepon': teleponController.text,
        },
        options: Options(
          headers: {'Authorization': 'Bearer ${myStorage.read('token')}'},
        ),
      );
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Anggota berhasil diperbarui')),
        );
        Navigator.pop(context); // Kembali ke halaman sebelumnya setelah berhasil memperbarui
      } else {
        print('Error updating anggota: ${response.data}');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal memperbarui anggota')),
        );
      }
    } catch (e) {
      print('Error updating anggota: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal memperbarui anggota')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Anggota'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: anggotaData != null
            ? Form(
                key: myFormKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: namaController,
                      decoration: InputDecoration(
                        labelText: 'Nama',
                        hintText: anggotaData?['nama'] ?? '',
                      ),
                    ),
                    TextFormField(
                      controller: alamatController,
                      decoration: InputDecoration(
                        labelText: 'Alamat',
                        hintText: anggotaData?['alamat'] ?? '',
                      ),
                    ),
                    TextFormField(
                      controller: tglLahirController,
                      decoration: InputDecoration(
                        labelText: 'Tanggal lahir',
                        hintText: anggotaData?['tgl_lahir'] ?? '',
                      ),
                    ),
                    TextFormField(
                      controller: teleponController,
                      decoration: InputDecoration(
                        labelText: 'Telepon',
                        hintText: anggotaData?['telepon'] ?? '',
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _updateAnggotaData,
                      child: const Text('Perbarui'),
                    ),
                  ],
                ),
              )
            : const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
