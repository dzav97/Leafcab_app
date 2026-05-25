import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/foundation.dart';

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

    debugPrint('DB PATH: $path');

    return openDatabase(
      path,
      version: 4,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    debugPrint('onCreate jalan');

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
        storage_path TEXT,
        image_base64 TEXT
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
    debugPrint('Upgrade DB dari v$oldVersion ke v$newVersion');

    if (oldVersion < 3) {
      await _addColumnIfNotExists(
        db,
        tableName: 'riwayat_deteksi',
        columnName: 'user_id',
        alterSql:
            "ALTER TABLE riwayat_deteksi ADD COLUMN user_id TEXT NOT NULL DEFAULT ''",
      );

      await _addColumnIfNotExists(
        db,
        tableName: 'riwayat_deteksi',
        columnName: 'cloud_id',
        alterSql: "ALTER TABLE riwayat_deteksi ADD COLUMN cloud_id TEXT",
      );

      await _addColumnIfNotExists(
        db,
        tableName: 'riwayat_deteksi',
        columnName: 'updated_at',
        alterSql: "ALTER TABLE riwayat_deteksi ADD COLUMN updated_at TEXT",
      );

      await _addColumnIfNotExists(
        db,
        tableName: 'riwayat_deteksi',
        columnName: 'is_deleted',
        alterSql:
            "ALTER TABLE riwayat_deteksi ADD COLUMN is_deleted INTEGER NOT NULL DEFAULT 0",
      );

      await db.execute("""
        UPDATE riwayat_deteksi
        SET updated_at = timestamp
        WHERE updated_at IS NULL
      """);
    }

    if (oldVersion < 4) {
      await _addColumnIfNotExists(
        db,
        tableName: 'riwayat_deteksi',
        columnName: 'image_base64',
        alterSql: "ALTER TABLE riwayat_deteksi ADD COLUMN image_base64 TEXT",
      );
    }

    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_riwayat_user_timestamp ON riwayat_deteksi(user_id, timestamp DESC)',
    );

    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_riwayat_sync_state ON riwayat_deteksi(user_id, sync_state)',
    );
  }

  Future<void> _addColumnIfNotExists(
    Database db, {
    required String tableName,
    required String columnName,
    required String alterSql,
  }) async {
    final columns = await db.rawQuery('PRAGMA table_info($tableName)');

    final exists = columns.any((column) => column['name'] == columnName);

    if (!exists) {
      await db.execute(alterSql);
    }
  }
}