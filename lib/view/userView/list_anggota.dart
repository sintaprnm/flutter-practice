// ignore_for_file: non_constant_identifier_names, no_leading_underscores_for_local_identifiers, unnecessary_brace_in_string_interps, avoid_print

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/utils/global.colors.dart';
import 'package:flutter_application/view/transactionView/details_transaction.dart';
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
    } on DioException catch (e) {
      print('${e.response} - ${e.response?.statusCode}');
    }
  }

  Future<void> _toggleStatus(int id, int currentStatus) async {
    try {
      final response = await _dio.put(
        '$_apiUrl/anggota/$id',
        data: {'status_aktif': currentStatus == 1 ? 0 : 1},
        options: Options(
          headers: {'Authorization': 'Bearer ${myStorage.read('token')}'},
        ),
      );

      if (response.statusCode == 200) {
        // Refresh the anggota list after successful toggle
        getAnggota();
        print('Status anggota berhasil diubah!');
      } else {
        print('Gagal mengubah status anggota: ${response.data}');
        // Handle error scenarios as needed (e.g., display error message)
      }
    } on DioException catch (e) {
      // Handle Dio exceptions (e.g., network errors)
      print('${e.response} - ${e.response?.statusCode}');
      // Display error message to the user
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
      body: Stack(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 68),
              child: anggotaDatas == null || anggotaDatas!.anggotaDatas.isEmpty
                  ? const Text("Belum ada anggota")
                  : ListView.builder(
                      itemCount: anggotaDatas!.anggotaDatas.length,
                      itemBuilder: (context, index) {
                        final anggota = anggotaDatas!.anggotaDatas[index];
                        return ListTile(
                          title: Text(anggota.nama),
                          subtitle: Row(
                            children: [
                              const Icon(Icons.phone, size: 14),
                              const SizedBox(width: 6),
                              Text(anggota.telepon),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // IconButton(
                              //   icon: const Icon(Icons.edit, color: Colors.pink,),
                              //   onPressed: () {
                              //     // Navigate to edit anggota page with anggota ID
                              //     Navigator.push(
                              //       context,
                              //       MaterialPageRoute(
                              //         builder: (context) => EditAnggotaPage(anggotaId: anggota.id),
                              //       ),
                              //     );
                              //   },
                              // ),
                              IconButton(
                                icon: Icon(anggota.status_aktif == 1 ? Icons.toggle_on : Icons.toggle_off, color: anggota.status_aktif == 1 ? Colors.pink : Colors.grey,),
                                onPressed: () {
                                  _toggleStatus(anggota.id, anggota.status_aktif ?? 0);
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline, color: Colors.pink,),
                                onPressed: () {
                                  _confirmDeleteAnggota(anggota.id);
                                },
                              ),
                            ],
                          ),
                          leading: Container(
                            width: 50, 
                            height: 50, 
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey, 
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.account_circle,
                                size: 30, 
                                color: Colors.white, 
                              ),
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailAnggotaPage(anggota: anggota),
                              ),
                            );
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
    } on DioException catch (e) {
      // Handle Dio exceptions (e.g., network errors)
      print('${e.response} - ${e.response?.statusCode}');
      // Display error message to the user
    }
  }
}

class DetailAnggotaPage extends StatelessWidget {
  final Anggota anggota;

  const DetailAnggotaPage({super.key, required this.anggota});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(anggota.nama),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow('ID', anggota.id.toString()),
            _buildInfoRow('Nomor Induk', anggota.nomor_induk.toString()),
            _buildInfoRow('Nama', anggota.nama),
            _buildInfoRow('Alamat', anggota.alamat),
            _buildInfoRow('Tanggal Lahir', anggota.tgl_lahir),
            _buildInfoRow('Telepon', anggota.telepon),
            if (anggota.image_url != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Image.network(anggota.image_url!),
              ),
            _buildInfoRow('Status Aktif', anggota.status_aktif == 1 ? "Aktif" : "Tidak Aktif"),
            const SizedBox(height: 20),
            Column(
              children: [
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditAnggotaPage(anggotaId: anggota.id),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: GlobalColors.mainColor,
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                    ),
                    child: const Text(
                      'Edit Profile User',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TransactionDetailPage(anggotaId: anggota.id),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: GlobalColors.mainColor,
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                    ),
                    child: const Text(
                      'Transaksi User',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold))),
          Expanded(flex: 3, child: Text(value)),
        ],
      ),
    );
  }
}