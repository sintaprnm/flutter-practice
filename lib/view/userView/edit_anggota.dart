// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names, no_leading_underscores_for_local_identifiers, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_application/utils/global.colors.dart';
import 'package:flutter_application/view/home.view.dart';
// import 'package:flutter_application/utils/global.colors.dart';
import 'package:get_storage/get_storage.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

class EditAnggotaPage extends StatefulWidget {
  final int anggotaId;

  const EditAnggotaPage({super.key, required this.anggotaId});

  @override
  State<EditAnggotaPage> createState() => _EditAnggotaPageState();
}

class _EditAnggotaPageState extends State<EditAnggotaPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nomorIndukController = TextEditingController();
  TextEditingController namaController = TextEditingController();
  TextEditingController alamatController = TextEditingController();
  TextEditingController tglLahirController = TextEditingController();
  TextEditingController noTeleponController = TextEditingController();

  Anggota? anggota;
  final dio = Dio();
  final myStorage = GetStorage();
  final _apiUrl = 'https://mobileapis.manpits.xyz/api';
  DateTime? _tglLahir;

  @override
  void initState() {
    super.initState();
    getDetail();
  }

  Future<void> getDetail() async {
    try {
      final _response = await dio.get(
        '$_apiUrl/anggota/${widget.anggotaId}',
        options: Options(
          headers: {'Authorization': 'Bearer ${myStorage.read('token')}'},
        ),
      );
      Map<String, dynamic> responseData = _response.data;
      print(responseData);
      setState(() {
        anggota = Anggota.fromJson(responseData);
        nomorIndukController.text = anggota?.nomor_induk.toString() ?? '';
        namaController.text = anggota?.nama.toString() ?? '';
        alamatController.text = anggota?.alamat.toString() ?? '';
        tglLahirController.text = anggota?.tgl_lahir.toString() ?? '';
        noTeleponController.text = anggota?.telepon.toString() ?? '';
        _tglLahir = DateFormat("yyyy-MM-dd").parse(tglLahirController.text);
      });
    } on DioException catch (e) {
      print('${e.response} - ${e.response?.statusCode}');
    }
  }

  void goEditUser() async {
    try {
      final _response = await dio.put(
        '$_apiUrl/anggota/${widget.anggotaId}',
        data: {
          'nomor_induk': nomorIndukController.text,
          'nama': namaController.text,
          'alamat': alamatController.text,
          'tgl_lahir': tglLahirController.text,
          'telepon': noTeleponController.text,
          'status_aktif': anggota?.status_aktif
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${myStorage.read('token')}',
          },
        ),
      );
      print(_response.data);
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Anggota berhasil diedit!"),
              content: const Text('Yeay!'),
              actions: <Widget>[
                TextButton(
                  child: const Text("OK"),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeView()));
                  },
                ),
              ],
            );
          });
    } on DioException catch (e) {
      print('${e.response} - ${e.response?.statusCode}');
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Oops!"),
              content: Text(e.response?.data['message'] ?? 'An error occurred'),
              actions: <Widget>[
                TextButton(
                  child: const Text("OK"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          });
    }
  }

  Future<void> _selectDate() async {
    DateTime? _picked = await showDatePicker(
      context: context,
      initialDate: _tglLahir!,
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
        title: const Text('Edit Anggota'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(children: [
          const SizedBox(height: 10),
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  controller: nomorIndukController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Tolong masukkan nomor induk.';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Nomor Induk',
                    hintText: 'Masukkan nomor induk',
                    prefixIcon: Icon(Icons.perm_identity, color: Colors.pink),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: namaController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Tolong masukkan nama.';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Nama',
                    hintText: 'Masukkan nama',
                    prefixIcon: Icon(Icons.face, color: Colors.pink),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: alamatController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Tolong masukkan alamat.';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Alamat',
                    hintText: 'Masukkan alamat',
                    prefixIcon: Icon(Icons.house, color: Colors.pink),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: tglLahirController,
                  decoration: const InputDecoration(
                    labelText: 'Tanggal Lahir',
                    hintText: 'Masukkan tanggal lahir',
                    prefixIcon: Icon(Icons.calendar_today, color: Colors.pink),
                  ),
                  readOnly: true,
                  onTap: _selectDate,
                  validator: (value) {
                    if (_tglLahir == null) {
                      return 'Tolong masukkan tanggal lahir';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: noTeleponController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Tolong masukkan nomor telepon.';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Nomor Telepon',
                    hintText: 'Masukkan nomor telepon',
                    prefixIcon: Icon(Icons.phone, color: Colors.pink),
                  ),
                ),
                const SizedBox(height: 70),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState?.save();
                            goEditUser();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: GlobalColors.mainColor,
                          elevation: 1,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                        child: const Text(
                          'Edit Anggota',
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
        ]),
      ),
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
    this.image_url,
    this.status_aktif,
  });

  factory Anggota.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>?;

    if (data != null) {
      final anggotaData = data['anggota'] as Map<String, dynamic>?;

      if (anggotaData != null) {
        return Anggota(
          id: anggotaData['id'],
          nomor_induk: anggotaData['nomor_induk'],
          nama: anggotaData['nama'],
          alamat: anggotaData['alamat'],
          tgl_lahir: anggotaData['tgl_lahir'],
          telepon: anggotaData['telepon'],
          image_url: anggotaData['image_url'],
          status_aktif: anggotaData['status_aktif'],
        );
      }
    }

    throw Exception('Failed to parse Anggota from JSON');
  }
}