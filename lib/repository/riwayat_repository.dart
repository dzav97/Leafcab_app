import 'dart:io';
import 'package:sqflite/sqflite.dart';
import '../../data/dataproviders/database_helper.dart';
import '../../data/models/riwayat_model.dart';

class RiwayatRepository {
  final dbHelper = DatabaseHelper.instance;

  Future<void> simpan(RiwayatDeteksi riwayat) async {
    final db = await dbHelper.database;

    await db.insert(
      'riwayat_deteksi',
      riwayat.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> upsert(RiwayatDeteksi riwayat) async {
    final db = await dbHelper.database;

    await db.insert(
      'riwayat_deteksi',
      riwayat.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<RiwayatDeteksi>> ambilDaftar(String userId) async {
    final db = await dbHelper.database;

    final maps = await db.query(
      'riwayat_deteksi',
      where: 'user_id = ? AND is_deleted = 0',
      whereArgs: [userId],
      orderBy: 'timestamp DESC',
    );

    return maps.map((m) => RiwayatDeteksi.fromMap(m)).toList();
  }

  Future<RiwayatDeteksi?> ambilByLocalId(String localId) async {
    final db = await dbHelper.database;

    final maps = await db.query(
      'riwayat_deteksi',
      where: 'local_id = ?',
      whereArgs: [localId],
      limit: 1,
    );

    if (maps.isEmpty) return null;
    return RiwayatDeteksi.fromMap(maps.first);
  }

  Future<List<RiwayatDeteksi>> ambilPerluSync(String userId) async {
    final db = await dbHelper.database;

    final maps = await db.query(
      'riwayat_deteksi',
      where: '''
        user_id = ?
        AND (
          sync_state != ?
          OR (
            (storage_path IS NULL OR storage_path = '')
            AND gambar != ''
          )
        )
      ''',
      whereArgs: [userId, 'synced'],
      orderBy: 'updated_at ASC',
    );

    return maps.map((m) => RiwayatDeteksi.fromMap(m)).toList();
  }

  Future<void> tandaiSudahSync({
    required String localId,
    required String cloudId,
    String? storagePath,
  }) async {
    final db = await dbHelper.database;

    final data = <String, Object?>{
      'cloud_id': cloudId,
      'sync_state': 'synced',
      'updated_at': DateTime.now().toIso8601String(),
    };

    if (storagePath != null && storagePath.isNotEmpty) {
      data['storage_path'] = storagePath;
    }

    await db.update(
      'riwayat_deteksi',
      data,
      where: 'local_id = ?',
      whereArgs: [localId],
    );
  }

  Future<void> hapus(RiwayatDeteksi item) async {
    final db = await dbHelper.database;

    if (item.syncState == 'local_only') {
      final f = File(item.gambar);
      if (await f.exists()) {
        await f.delete();
      }

      await db.delete(
        'riwayat_deteksi',
        where: 'local_id = ?',
        whereArgs: [item.localId],
      );
      return;
    }

    await db.update(
      'riwayat_deteksi',
      {
        'is_deleted': 1,
        'sync_state': 'pending_delete',
        'updated_at': DateTime.now().toIso8601String(),
      },
      where: 'local_id = ?',
      whereArgs: [item.localId],
    );
  }

  Future<void> hapusPermanen(String localId) async {
    final db = await dbHelper.database;

    final rows = await db.query(
      'riwayat_deteksi',
      columns: ['gambar'],
      where: 'local_id = ?',
      whereArgs: [localId],
      limit: 1,
    );

    if (rows.isNotEmpty) {
      final path = rows.first['gambar'] as String?;
      if (path != null && path.isNotEmpty) {
        final f = File(path);
        if (await f.exists()) {
          await f.delete();
        }
      }
    }

    await db.delete(
      'riwayat_deteksi',
      where: 'local_id = ?',
      whereArgs: [localId],
    );
  }
}