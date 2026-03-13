import 'dart:io';
import 'package:flutter/material.dart';
import '../../repository/riwayat_repository.dart';
import '../../data/models/riwayat_model.dart';
import 'detail_riwayat_screen.dart';

class RiwayatScreen extends StatefulWidget {
  const RiwayatScreen({super.key});

  @override
  State<RiwayatScreen> createState() => _RiwayatScreenState();
}

class _RiwayatScreenState extends State<RiwayatScreen> {
  final repo = RiwayatRepository();

  static const Color primaryGreen = Color(0xFF163225);
  static const Color cardGreen = Color(0xFFA5D6A7);
  static const Color bgGreen = Color(0xFFCDE4C5);

  late Future<List<RiwayatDeteksi>> _futureRiwayat;

  @override
  void initState() {
    super.initState();
    _futureRiwayat = repo.ambilDaftar();
  }

  Future<void> _reload() async {
    setState(() {
      _futureRiwayat = repo.ambilDaftar();
    });
  }

  Future<void> _delete(RiwayatDeteksi item) async {
    await repo.hapus(item.localId);
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Riwayat dihapus')),
    );

    await _reload();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgGreen,
      appBar: AppBar(
        title: const Text(
          'Riwayat',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: primaryGreen,
      ),
      body: FutureBuilder<List<RiwayatDeteksi>>(
        future: _futureRiwayat,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Terjadi error: ${snapshot.error}'),
            );
          }

          final data = snapshot.data ?? [];

          if (data.isEmpty) {
            return RefreshIndicator(
              onRefresh: _reload,
              child: ListView(
                children: const [
                  SizedBox(height: 200),
                  Center(child: Text('Belum ada riwayat deteksi.')),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _reload,
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: data.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, i) {
                final item = data[i];

                return InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetailRiwayatScreen(item: item),
                      ),
                    );
                    await _reload();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: cardGreen,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              File(item.gambar),
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => const Icon(
                                Icons.image_outlined,
                                color: primaryGreen,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.label,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: primaryGreen,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                item.timestamp.toLocal().toString().substring(0, 16),
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: primaryGreen,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () => _delete(item),
                          icon: const Icon(
                            Icons.delete_outline,
                            color: primaryGreen,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}