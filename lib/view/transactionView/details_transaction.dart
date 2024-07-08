// ignore_for_file: library_private_types_in_public_api, avoid_print, no_leading_underscores_for_local_identifiers, use_build_context_synchronously, non_constant_identifier_names

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/view/transactionView/add_transaksi.dart';
import 'package:get_storage/get_storage.dart';

// Transaction Detail Page
class TransactionDetailPage extends StatefulWidget {
  final int anggotaId;

  const TransactionDetailPage({super.key, required this.anggotaId});

  @override
  _TransactionDetailPageState createState() => _TransactionDetailPageState();
}

class _TransactionDetailPageState extends State<TransactionDetailPage> {
  final _dio = Dio();
  final _storage = GetStorage();
  final _apiUrl = 'https://mobileapis.manpits.xyz/api';
  List<Map<String, dynamic>> _transactions = [];
  Map<int, String> _jenisTransaksiMap = {}; // Map to store transaction types
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    getDetails();
  }

  Future<void> getDetails() async {
    try {
      await _loadJenisTransaksi();
      final _response = await _dio.get(
        '$_apiUrl/tabungan/${widget.anggotaId}',
        options: Options(
          headers: {'Authorization': 'Bearer ${_storage.read('token')}'},
        ),
      );
      Map<String, dynamic> responseData = _response.data;

      // Log the entire response data to debug console
      print(responseData);

      if (responseData['success']) {
        setState(() {
          _transactions =
              List<Map<String, dynamic>>.from(responseData['data']['tabungan']);
          _isInitialized = true;
        });
      }
    } on DioException catch (e) {
      if (e.response != null) {
        print('${e.response} - ${e.response!.statusCode}');
      }
    }
  }

  Future<void> _loadJenisTransaksi() async {
    try {
      Response response = await _dio.get(
        '$_apiUrl/jenistransaksi',
        options: Options(
          headers: {'Authorization': 'Bearer ${_storage.read('token')}'},
        ),
      );

      if (response.statusCode == 200) {
        final jenisTransaksi = List<Map<String, dynamic>>.from(response.data['data']['jenistransaksi']);
        setState(() {
          _jenisTransaksiMap = {for (var item in jenisTransaksi) item['id']: item['trx_name']};
        });
      } else {
        print('Gagal memuat jenis transaksi.');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  String _getJenisTransaksi(int trxId) {
    return _jenisTransaksiMap[trxId] ?? 'Unknown';
  }

  @override
  Widget build(BuildContext context) {
    double _saldoAkhir = 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction Detail'),
        actions: [
        IconButton(
          icon: const Icon(Icons.refresh, color: Colors.pink),
          onPressed: () {
            getDetails(); // Panggil fungsi getDetails untuk memuat ulang data transaksi
          },
        ),
        IconButton(
            icon: const Icon(Icons.local_atm_rounded, color: Colors.pink),
            onPressed: () {
              Navigator.pushNamed(context, '/add_bunga'); // Navigates to AddBunga page
            },
          ),
        IconButton(
          icon: const Icon(Icons.list, color: Colors.pink),
          onPressed: () {
            Navigator.pushNamed(context, '/list_bunga'); // Navigates to ListBunga page
          },
          ),
      ],
      ),
      body: _isInitialized
          ? ListView.builder(
              itemCount: _transactions.length,
              itemBuilder: (context, index) {
                final transaction = _transactions[index];

                // Calculate saldo akhir
                _saldoAkhir += transaction['trx_nominal'];

                return ListTile(
                  title: Text('ID: ${transaction['id']}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Tanggal: ${transaction['trx_tanggal']}'),
                      Text('Transaksi ID: ${transaction['trx_id']}'),
                      Text('Jenis Transaksi: ${_getJenisTransaksi(transaction['trx_id'])}'),
                      Text('Nominal: Rp ${transaction['trx_nominal']}'),
                      Text('Saldo Akhir: Rp $_saldoAkhir'),
                    ],
                  ),
                );
              },
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
      floatingActionButton: _buildFloatingButtons(context),
    );
  }

  Widget _buildFloatingButtons(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddTransactionPage(anggotaId: widget.anggotaId)),
            );
          },
          tooltip: 'Tambah Transaksi',
          child: const Icon(Icons.add, color: Colors.pink),
        ),
        const SizedBox(height: 10),
        FloatingActionButton(
          onPressed: () {
            SaldoTabungan(context, widget.anggotaId);
          },
          tooltip: 'Saldo',
          child: const Icon(Icons.account_balance_wallet, color: Colors.pink),
        ),
        const SizedBox(height: 10),
        FloatingActionButton(
          onPressed: () {
            getJenisTransaksi(context);
          },
          tooltip: 'Jenis Transaksi',
          child: const Icon(Icons.list, color: Colors.pink),
        ),
      ],
    );
  }

  void getJenisTransaksi(BuildContext context) async {
    try {
      final _response = await _dio.get(
        '$_apiUrl/jenistransaksi',
        options: Options(
          headers: {'Authorization': 'Bearer ${_storage.read('token')}'},
        ),
      );

      print(_response.data);

      if (_response.statusCode == 200) {
        final jenisTransaksi = _response.data['data']['jenistransaksi'];

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 0.0,
              backgroundColor: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Jenis Transaksi',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: jenisTransaksi.length,
                      itemBuilder: (context, index) {
                        final transaction = jenisTransaksi[index];
                        return ListTile(
                          title: Text(
                            transaction['trx_name'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            'ID: ${transaction['id']}',
                            style: const TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                          trailing: Text(
                            'Multiplier: ${transaction['trx_multiply'] == 1 ? "Debit" : "Credit"}',
                            style: const TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20.0),
                    Align(
                      alignment: Alignment.center,
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          'Tutup',
                          style: TextStyle(
                            color: Colors.pink,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }
    } on DioException catch (e) {
      print('${e.response} - ${e.response?.statusCode}');
    } catch (error) {
      print('Error: $error');
    }
  }
}

// Saldo Tabungan Function
void SaldoTabungan(BuildContext context, int anggotaId) async {
  try {
    // final _dio = Dio();
    final myStorage = GetStorage();
    const _apiUrl = 'https://mobileapis.manpits.xyz/api';
    final _response = await Dio().get(
      '$_apiUrl/saldo/$anggotaId',
      options: Options(
        headers: {'Authorization': 'Bearer ${myStorage.read('token')}'},
      ),
    );

    print(_response.data);

    if (_response.statusCode == 200) {
      final saldo = _response.data['data']['saldo'];

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Saldo Tabungan'),
            content: Text('Saldo Anda sebesar Rp $saldo'),
            actions: <Widget>[
              TextButton(
                child: const Text('Tutup', 
                  style: TextStyle(
                    color: Colors.pink,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  } on DioException catch (e) {
    print('Dio error: $e');
  } catch (error) {
    print('Error: $error');
  }
}
