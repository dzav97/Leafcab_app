import '../data/dataproviders/database_helper.dart';
import '../data/models/riwayat_model.dart';

class RiwayatRepository {
  final dbHelper = DatabaseHelper.instance;

  // Sesuai diagram: +simpan(riwayat: RiwayatDeteksi)
  Future<void> simpan(RiwayatDeteksi riwayat) async {
    final db = await dbHelper.database;
    
    // Simpan hasil deteksi terlebih dahulu untuk mendapatkan ID
    int hasilId = await db.insert('hasil_deteksi', riwayat.hasil.toMap());
    
    // Simpan riwayat dengan foreign key hasilId
    await db.insert('riwayat_deteksi', {
      'timestamp': riwayat.timestamp.toIso8601String(),
      'gambar': riwayat.gambar,
      'hasil_id': hasilId,
    });
  }

  // Sesuai diagram: +ambilDaftar() : List
  Future<List<RiwayatDeteksi>> ambilDaftar() async {
    final db = await dbHelper.database;
    
    // Join tabel riwayat dan hasil untuk mendapatkan data lengkap
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT r.*, h.label, h.confidence 
      FROM riwayat_deteksi r
      JOIN hasil_deteksi h ON r.hasil_id = h.id
      ORDER BY r.timestamp DESC
    ''');

    return List.generate(maps.length, (i) {
      return RiwayatDeteksi(
        id: maps[i]['id'],
        timestamp: DateTime.parse(maps[i]['timestamp']),
        gambar: maps[i]['gambar'],
        hasil: HasilDeteksi(
          label: maps[i]['label'],
          confidence: maps[i]['confidence'],
        ),
      );
    });
  }
}