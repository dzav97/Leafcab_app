import 'dart:io';
import 'package:sqflite/sqflite.dart';
import '../../data/dataproviders/database_helper.dart';
import '../../data/models/riwayat_model.dart';

class RiwayatRepository {
  final dbHelper = DatabaseHelper.instance;

  Future<void> simpan(RiwayatDeteksi riwayat) async {
    final db = await dbHelper.database;

    print("MENYIMPAN DATA KE DATABASE:");
    print(riwayat.toMap());

    await db.insert(
      'riwayat_deteksi',
      riwayat.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    print("DATA BERHASIL DISIMPAN");
  }

  Future<List<RiwayatDeteksi>> ambilDaftar() async {
    final db = await dbHelper.database;
    final maps = await db.query(
      'riwayat_deteksi',
      orderBy: 'timestamp DESC',
    );

    return maps.map((m) => RiwayatDeteksi.fromMap(m)).toList();
  }

  Future<void> hapus(String localId) async {
    final db = await dbHelper.database;

    // ambil path file dulu
    final rows = await db.query(
      'riwayat_deteksi',
      columns: ['gambar'],
      where: 'local_id = ?',
      whereArgs: [localId],
      limit: 1,
    );

    if (rows.isNotEmpty) {
      final path = rows.first['gambar'] as String;
      final f = File(path);
      if (await f.exists()) {
        await f.delete();
      }
    }

    // hapus row DB
    await db.delete(
      'riwayat_deteksi',
      where: 'local_id = ?',
      whereArgs: [localId],
    );
  }
}