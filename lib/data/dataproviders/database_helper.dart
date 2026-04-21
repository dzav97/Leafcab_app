import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('leafcab.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);

    print('DB PATH: $path');

    return openDatabase(
      path,
      version: 3,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    print('onCreate jalan');

    await db.execute('''
      CREATE TABLE riwayat_deteksi (
        local_id TEXT PRIMARY KEY,
        user_id TEXT NOT NULL,
        cloud_id TEXT,
        timestamp TEXT NOT NULL,
        updated_at TEXT,
        gambar TEXT NOT NULL,
        label TEXT NOT NULL,
        confidence REAL NOT NULL,
        gejala TEXT NOT NULL,
        pengendalian TEXT NOT NULL,
        sync_state TEXT NOT NULL DEFAULT 'local_only',
        is_deleted INTEGER NOT NULL DEFAULT 0,
        storage_path TEXT
      )
    ''');

    await db.execute(
      'CREATE INDEX idx_riwayat_user_timestamp ON riwayat_deteksi(user_id, timestamp DESC)',
    );

    await db.execute(
      'CREATE INDEX idx_riwayat_sync_state ON riwayat_deteksi(user_id, sync_state)',
    );
  }

  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    print('Upgrade DB dari v$oldVersion ke v$newVersion');

    if (oldVersion < 3) {
      await db.execute(
        "ALTER TABLE riwayat_deteksi ADD COLUMN user_id TEXT NOT NULL DEFAULT ''",
      );
      await db.execute(
        "ALTER TABLE riwayat_deteksi ADD COLUMN cloud_id TEXT",
      );
      await db.execute(
        "ALTER TABLE riwayat_deteksi ADD COLUMN updated_at TEXT",
      );
      await db.execute(
        "ALTER TABLE riwayat_deteksi ADD COLUMN is_deleted INTEGER NOT NULL DEFAULT 0",
      );

      await db.execute("""
        UPDATE riwayat_deteksi
        SET updated_at = timestamp
        WHERE updated_at IS NULL
      """);

      await db.execute(
        'CREATE INDEX IF NOT EXISTS idx_riwayat_user_timestamp ON riwayat_deteksi(user_id, timestamp DESC)',
      );

      await db.execute(
        'CREATE INDEX IF NOT EXISTS idx_riwayat_sync_state ON riwayat_deteksi(user_id, sync_state)',
      );
    }
  }
}