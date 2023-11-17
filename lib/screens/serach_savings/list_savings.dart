
import 'package:flutter/material.dart';

class NextPage extends StatelessWidget {
  final String data;

  const NextPage({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Implementasi tampilan halaman berikutnya menggunakan data yang ditemukan dari API
    return Scaffold(
      appBar: AppBar(
        title: Text('Hasil Pencarian'),
      ),
      body: Center(
        child: Text(data),
      ),
    );
  }
}
