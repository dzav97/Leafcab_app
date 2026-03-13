import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

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

    return openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE riwayat_deteksi (
        local_id TEXT PRIMARY KEY,
        timestamp TEXT NOT NULL,
        gambar TEXT NOT NULL,
        label TEXT NOT NULL,
        confidence REAL NOT NULL,
        gejala TEXT NOT NULL,
        pengendalian TEXT NOT NULL,
        sync_state TEXT NOT NULL DEFAULT 'local_only',
        storage_path TEXT
      )
    ''');
  }
}