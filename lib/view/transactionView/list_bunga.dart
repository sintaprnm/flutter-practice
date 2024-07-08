import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class ListBunga extends StatefulWidget {
  const ListBunga({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ListBungaState createState() => _ListBungaState();
}

class _ListBungaState extends State<ListBunga> {
  final _dio = Dio();
  final _storage = GetStorage();
  final _apiUrl = 'https://mobileapis.manpits.xyz/api';

  List<dynamic> _listBunga = [];

  @override
  void initState() {
    super.initState();
    fetchListBunga();
  }

  Future<void> fetchListBunga() async {
    try {
      final response = await _dio.get(
        '$_apiUrl/settingbunga',
        options: Options(
          headers: {'Authorization': 'Bearer ${_storage.read('token')}'},
        ),
      );

      if (response.statusCode == 200) {
        setState(() {
          _listBunga = response.data['data']['settingbunga'];
        });
      } else {
        if (kDebugMode) {
          print('Failed to load list bunga');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Bunga'),
      ),
      body: _listBunga.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: _listBunga.length,
              itemBuilder: (context, index) {
                final bunga = _listBunga[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  elevation: 2.0,
                  child: ListTile(
                    title: Text('ID: ${bunga['id']}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Persen: ${bunga['persen']}'),
                        Text('Status: ${bunga['isaktif'] == '1' ? 'Aktif' : 'Tidak Aktif'}'),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
