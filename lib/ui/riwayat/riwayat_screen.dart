import 'dart:io';
import 'package:flutter/material.dart';
import '../../repository/riwayat_repository.dart';
import '../../data/models/riwayat_model.dart';
import 'detail_riwayat_screen.dart';
import '../dashboard/dashboard_screen.dart';

class RiwayatScreen extends StatefulWidget {
  const RiwayatScreen({super.key});

  @override
  State<RiwayatScreen> createState() => _RiwayatScreenState();
}

class _RiwayatScreenState extends State<RiwayatScreen> {
  final repo = RiwayatRepository();

  static const Color primaryGreen = Color(0xFF163225);
  static const Color cardGreen = Color(0xFFA5D6A7);

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
      backgroundColor: DashboardScreen.green,
      body: SafeArea(
        child: Stack(
          children: [
            const _HeaderTitle(),
            Padding(
              padding: const EdgeInsets.only(top: 78),
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: DashboardScreen.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(26),
                  ),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 18),
                    _buildTopBanner(),
                    const SizedBox(height: 18),
                    Expanded(
                      child: FutureBuilder<List<RiwayatDeteksi>>(
                        future: _futureRiwayat,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(
                                color: primaryGreen,
                              ),
                            );
                          }

                          if (snapshot.hasError) {
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Text(
                                  'Terjadi error: ${snapshot.error}',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: primaryGreen,
                                  ),
                                ),
                              ),
                            );
                          }

                          final data = snapshot.data ?? [];

                          if (data.isEmpty) {
                            return RefreshIndicator(
                              onRefresh: _reload,
                              child: ListView(
                                children: const [
                                  SizedBox(height: 200),
                                  Center(
                                    child: Text(
                                      'Belum ada riwayat deteksi.',
                                      style: TextStyle(
                                        color: primaryGreen,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }

                          return RefreshIndicator(
                            onRefresh: _reload,
                            child: ListView.separated(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
                              itemCount: data.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 12),
                              itemBuilder: (context, i) {
                                final item = data[i];

                                return InkWell(
                                  borderRadius: BorderRadius.circular(18),
                                  onTap: () async {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            DetailRiwayatScreen(item: item),
                                      ),
                                    );
                                    await _reload();
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 14,
                                    ),
                                    decoration: BoxDecoration(
                                      color: cardGreen,
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 56,
                                          height: 56,
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(0.55),
                                            borderRadius:
                                                BorderRadius.circular(14),
                                          ),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(14),
                                            child: Image.file(
                                              File(item.gambar),
                                              fit: BoxFit.cover,
                                              errorBuilder: (_, __, ___) =>
                                                  const Icon(
                                                Icons.image_outlined,
                                                color: DashboardScreen.dark,
                                                size: 28,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 14),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                item.label,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w700,
                                                  color: DashboardScreen.dark,
                                                ),
                                              ),
                                              const SizedBox(height: 6),
                                              Text(
                                                'Confidence: ${(item.confidence * 100).toStringAsFixed(2)}%',
                                                style: const TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600,
                                                  color: DashboardScreen.dark,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                _formatTanggal(item.timestamp),
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  color: DashboardScreen.dark,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () => _delete(item),
                                          icon: const Icon(
                                            Icons.delete_outline_rounded,
                                            color: DashboardScreen.dark,
                                            size: 24,
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
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
        decoration: BoxDecoration(
          color: DashboardScreen.green,
          borderRadius: BorderRadius.circular(22),
        ),
        child: const Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: Colors.white,
              child: Icon(
                Icons.history,
                color: DashboardScreen.dark,
                size: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _formatTanggal(DateTime tanggal) {
    return '${tanggal.day.toString().padLeft(2, '0')}-'
        '${tanggal.month.toString().padLeft(2, '0')}-'
        '${tanggal.year} '
        '${tanggal.hour.toString().padLeft(2, '0')}:'
        '${tanggal.minute.toString().padLeft(2, '0')}';
  }
}

class _HeaderTitle extends StatelessWidget {
  const _HeaderTitle();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(left: 24, top: 16),
      child: Text(
        "Riwayat",
        style: TextStyle(
          fontSize: 34,
          fontWeight: FontWeight.w800,
          color: DashboardScreen.dark,
          height: 1.05,
        ),
      ),
    );
  }
}