import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../data/models/riwayat_model.dart';
import '../../repository/riwayat_repository.dart';
import '../../services/riwayat_sync_service.dart';
import '../dashboard/dashboard_screen.dart';
import 'detail_riwayat_screen.dart';

class RiwayatScreen extends StatefulWidget {
  const RiwayatScreen({super.key});

  @override
  State<RiwayatScreen> createState() => _RiwayatScreenState();
}

class _RiwayatScreenState extends State<RiwayatScreen> {
  final RiwayatRepository repo = RiwayatRepository();
  final RiwayatSyncService syncService = RiwayatSyncService();

  late Future<List<RiwayatDeteksi>> _futureRiwayat;

  String? get _userId => FirebaseAuth.instance.currentUser?.uid;

  @override
  void initState() {
    super.initState();
    _futureRiwayat = _initRiwayat();
  }

  Future<List<RiwayatDeteksi>> _initRiwayat() async {
    final userId = _userId;
    if (userId == null) return [];

    await syncService.restoreRiwayatDariCloud();
    await syncService.syncRiwayat();

    return repo.ambilDaftar(userId);
  }

  Future<void> _reload() async {
    setState(() {
      _futureRiwayat = _initRiwayat();
    });
  }

  Future<void> _delete(RiwayatDeteksi item) async {
    await repo.hapus(item);
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Riwayat dihapus')),
    );

    await _reload();
  }

  Future<void> _confirmDelete(RiwayatDeteksi item) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Hapus Riwayat'),
        content: const Text('Yakin ingin menghapus riwayat ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text(
              'Hapus',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _delete(item);
    }
  }

  Widget _buildThumbnail(RiwayatDeteksi item) {
    if (item.gambar.isEmpty) {
      return const Icon(
        Icons.image_outlined,
        color: DashboardScreen.dark,
        size: 28,
      );
    }

    return Image.file(
      File(item.gambar),
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => const Icon(
        Icons.image_outlined,
        color: DashboardScreen.dark,
        size: 28,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DashboardScreen.green,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const _HeaderTitle(),
            Expanded(
              child: Container(
                width: double.infinity,
                color: const Color(0xFFF3F3F3),
                child: FutureBuilder<List<RiwayatDeteksi>>(
                  future: _futureRiwayat,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: DashboardScreen.dark,
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
                              color: DashboardScreen.dark,
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
                          padding: const EdgeInsets.fromLTRB(20, 40, 20, 120),
                          children: const [
                            SizedBox(height: 180),
                            Center(
                              child: Text(
                                'Belum ada riwayat deteksi.',
                                style: TextStyle(
                                  color: DashboardScreen.dark,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
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
                        padding: const EdgeInsets.fromLTRB(18, 22, 18, 120),
                        itemCount: data.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 14),
                        itemBuilder: (context, i) {
                          final item = data[i];

                          return _RiwayatCard(
                            item: item,
                            thumbnail: _buildThumbnail(item),
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => DetailRiwayatScreen(item: item),
                                ),
                              );
                              await _reload();
                            },
                            onDelete: () => _confirmDelete(item),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderTitle extends StatelessWidget {
  const _HeaderTitle();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: DashboardScreen.green,
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 16),
      child: const Text(
        "Riwayat",
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w800,
          color: DashboardScreen.dark,
          height: 1.05,
        ),
      ),
    );
  }
}

class _RiwayatCard extends StatelessWidget {
  const _RiwayatCard({
    required this.item,
    required this.thumbnail,
    required this.onTap,
    required this.onDelete,
  });

  final RiwayatDeteksi item;
  final Widget thumbnail;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        height: 86,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: DashboardScreen.green,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: DashboardScreen.border,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.35),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: thumbnail,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _RiwayatInfo(item: item),
            ),
            const SizedBox(width: 10),
            IconButton(
              onPressed: onDelete,
              splashRadius: 20,
              icon: const Icon(
                Icons.delete_outline_rounded,
                size: 28,
                color: DashboardScreen.dark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RiwayatInfo extends StatelessWidget {
  const _RiwayatInfo({required this.item});

  final RiwayatDeteksi item;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item.label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: Color(0xFF36563C),
            height: 1.1,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _formatTanggal(item.timestamp),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 12,
            color: DashboardScreen.softText,
            fontStyle: FontStyle.italic,
            height: 1.1,
          ),
        ),
      ],
    );
  }

  static String _formatTanggal(DateTime tanggal) {
    return '${tanggal.day.toString().padLeft(2, '0')}-'
        '${tanggal.month.toString().padLeft(2, '0')}-'
        '${tanggal.year}';
  }
}