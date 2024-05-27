// ignore_for_file: library_private_types_in_public_api, avoid_print, use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class AddTransactionPage extends StatelessWidget {
  final int? anggotaId;

  const AddTransactionPage({super.key, this.anggotaId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Transaksi'),
      ),
      body: AddTransactionForm(anggotaId: anggotaId),
    );
  }
}

class AddTransactionForm extends StatefulWidget {
  final int? anggotaId;

  const AddTransactionForm({super.key, this.anggotaId});

  @override
  _AddTransactionFormState createState() => _AddTransactionFormState();
}

class _AddTransactionFormState extends State<AddTransactionForm> {
  final _storage = GetStorage();
  late List<Map<String, dynamic>> _jenisTransaksi = [];
  int _selectedTransactionIndex = 0;
  late TextEditingController _nominalController;
  int MULTIPLIER_DEBIT = 1;
  int MULTIPLIER_CREDIT = -1;


  @override
  void initState() {
    super.initState();
    _loadJenisTransaksi();
    _nominalController = TextEditingController();
  }

  Future<void> _loadJenisTransaksi() async {
    try {
      Response response = await Dio().get(
        'https://mobileapis.manpits.xyz/api/jenistransaksi',
        options: Options(
          headers: {'Authorization': 'Bearer ${_storage.read('token')}'},
          contentType: 'application/x-www-form-urlencoded',
        ),
      );

      if (response.statusCode == 200) {
        setState(() {
          _jenisTransaksi =
              List<Map<String, dynamic>>.from(response.data['data']['jenistransaksi']);
        });
      } else {
        print('Gagal memuat jenis transaksi.');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          DropdownButtonFormField<int>(
            value: _selectedTransactionIndex,
            items: List.generate(
              _jenisTransaksi.length,
              (index) => DropdownMenuItem<int>(
                value: index,
                child: Text(
                  _jenisTransaksi[index]['trx_name'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            onChanged: (value) {
              setState(() {
                _selectedTransactionIndex = value!;
              });
            },
          ),
          TextFormField(
            controller: _nominalController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Nominal',
            ),
          ),
          const SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () async {
                  try {
                    Response postResponse = await Dio().post(
                      'https://mobileapis.manpits.xyz/api/tabungan',
                      data: {
                        'anggota_id': widget.anggotaId,
                        'trx_id': _jenisTransaksi[_selectedTransactionIndex]['id'],
                        'trx_nominal': double.parse(_nominalController.text),
                        'trx_multiply': _jenisTransaksi[_selectedTransactionIndex]['trx_multiply'] == MULTIPLIER_DEBIT ? MULTIPLIER_DEBIT : MULTIPLIER_CREDIT,
                      },
                      options: Options(
                        headers: {'Authorization': 'Bearer ${_storage.read('token')}'},
                      ),
                    );

                    if (postResponse.statusCode == 200) {
                      print('Transaksi berhasil ditambahkan');
                      print('Detail Transaksi Baru: ${postResponse.data['data']['tabungan']}');
                    } else {
                      print('Gagal menambahkan transaksi');
                    }
                  } catch (error) {
                    print('Error: $error');
                  }
                  Navigator.of(context).pop();
                },
                child: const Text('Simpan'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}