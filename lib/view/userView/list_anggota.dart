import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/view/userView/edit_anggota.dart';
import 'package:get_storage/get_storage.dart';

class AnggotaList extends StatefulWidget {
  const AnggotaList({super.key});

  @override
  State<AnggotaList> createState() => _AnggotaListState();
}

class AnggotaDatas {
  final List<Anggota> anggotaDatas;

  AnggotaDatas({required this.anggotaDatas});

  factory AnggotaDatas.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>?;
    final anggota = data?['anggotas'] as List<dynamic>?;

    return AnggotaDatas(
      anggotaDatas: anggota
          ?.map((anggotaData) => Anggota.fromJson(anggotaData as Map<String, dynamic>))
          .toList() ??
          [],
    );
  }
}

class Anggota {
  final int id;
  final int nomor_induk;
  final String nama;
  final String alamat;
  final String tgl_lahir;
  final String telepon;
  final String? image_url;
  final int? status_aktif;

  Anggota({
    required this.id,
    required this.nomor_induk,
    required this.nama,
    required this.alamat,
    required this.tgl_lahir,
    required this.telepon,
    required this.image_url,
    required this.status_aktif,
  });

  factory Anggota.fromJson(Map<String, dynamic> json) {
    return Anggota(
      id: json['id'],
      nomor_induk: json['nomor_induk'],
      nama: json['nama'],
      alamat: json['alamat'],
      tgl_lahir: json['tgl_lahir'],
      telepon: json['telepon'],
      image_url: json['image_url'],
      status_aktif: json['status_aktif'],
    );
  }
}

class _AnggotaListState extends State<AnggotaList> {
  AnggotaDatas? anggotaDatas;
  final _dio = Dio();
  final myStorage = GetStorage();
  final _apiUrl = 'https://mobileapis.manpits.xyz/api';

  Future<void> getAnggota() async {
    try {
      final _response = await _dio.get(
        '${_apiUrl}/anggota',
        options: Options(
          headers: {'Authorization': 'Bearer ${myStorage.read('token')}'},
        ),
      );
      Map<String, dynamic> responseData = _response.data;
      print(responseData);
      setState(() {
        anggotaDatas = AnggotaDatas.fromJson(responseData);
      });
    } on DioError catch (e) {
      print('${e.response} - ${e.response?.statusCode}');
    }
  }

  @override
  void initState() {
    super.initState();
    getAnggota();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ... other Scaffold properties

      body: Stack(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 68),
              child: anggotaDatas == null || anggotaDatas!.anggotaDatas.isEmpty
                  ? Text("Belum ada anggota")
                  : ListView.builder(
                      itemCount: anggotaDatas!.anggotaDatas.length,
                      itemBuilder: (context, index) {
                        final anggota = anggotaDatas!.anggotaDatas[index];
                        return ListTile(
                          title: Text(anggota.nama),
                          subtitle: Row(
                            children: [
                              Icon(Icons.phone, size: 14),
                              SizedBox(width: 6),
                              Text(anggota.telepon),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () {
                                  // Navigate to edit anggota page with anggota ID
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditAnggotaPage(anggotaId: anggota.id),
                                    ),
                                  );
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete_outline),
                                onPressed: () {
                                  _confirmDeleteAnggota(anggota.id);
                                },
                              ),
                            ],
                          ),
                          // leading: const CircleAvatar(
                          //   backgroundImage: AssetImage('assets/images/anggota.jpeg'),
                          // ),
                          leading: Container(
                            width: 50, // Sesuaikan dengan ukuran yang diinginkan
                            height: 50, // Sesuaikan dengan ukuran yang diinginkan
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey, // Ganti dengan warna latar belakang yang diinginkan
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.account_circle,
                                size: 30, // Sesuaikan dengan ukuran yang diinginkan
                                color: Colors.white, // Ganti dengan warna ikon yang diinginkan
                              ),
                            ),
                          ),
                          onTap: () {
                            // Ambil ID anggota yang diklik
                            int anggotaID = anggota.id;

                            // Loop melalui data anggota yang diterima dari server
                            for (var anggotaData in anggotaDatas!.anggotaDatas) {
                              // Cocokkan ID anggota yang diklik dengan ID anggota dalam data
                              if (anggotaData.id == anggotaID) {
                                // Jika cocok, cetak detail anggota
                                print('Detail Anggota:');
                                print('ID: ${anggotaData.id}');
                                print('Nomor Induk: ${anggotaData.nomor_induk}');
                                print('Nama: ${anggotaData.nama}');
                                print('Alamat: ${anggotaData.alamat}');
                                print('Tanggal Lahir: ${anggotaData.tgl_lahir}');
                                print('Telepon: ${anggotaData.telepon}');
                                break; // Keluar dari loop setelah menemukan anggota yang cocok
                              }
                            }
                          },
                        );
                      },
                    ),
            ),
          ),
          // ... other Stack elements if needed
        ],
      ),
    );
  }

  Future<void> _confirmDeleteAnggota(int id) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Konfirmasi"),
          content: const Text("Apakah Anda yakin ingin menghapus anggota ini?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog konfirmasi
              },
              child: const Text("Batal"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog konfirmasi
                _deleteAnggota(id); // Hapus anggota
              },
              child: const Text("Hapus"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteAnggota(int id) async {
    try {
      final response = await _dio.delete(
        '${_apiUrl}/anggota/$id',
        options: Options(
          headers: {'Authorization': 'Bearer ${myStorage.read('token')}'},
        ),
      );

      if (response.statusCode == 200) {
        // Refresh the anggota list after successful deletion
        getAnggota();
        print('Anggota deleted successfully!');
        // Show success dialog or snackbar (optional)
      } else {
        print('Error deleting anggota: ${response.data}');
        // Handle error scenarios as needed (e.g., display error message)
      }
    } on DioError catch (e) {
      // Handle Dio exceptions (e.g., network errors)
      print('${e.response} - ${e.response?.statusCode}');
      // Display error message to the user
    }
  }
}
