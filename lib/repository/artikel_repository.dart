import '../data/dataproviders/database_helper.dart';
import '../data/models/artikel_model.dart';

class ArtikelRepository {
  final dbHelper = DatabaseHelper.instance;

  // Sesuai diagram: +ambilDaftar() : List
  Future<List<Artikel>> ambilDaftar() async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('artikel');

    return List.generate(maps.length, (i) => Artikel.fromMap(maps[i]));
  }

  // Sesuai diagram: +ambilDetail(id:int) : Artikel
  Future<Artikel?> ambilDetail(int id) async {
    final db = await dbHelper.database;
    final maps = await db.query('artikel', where: 'id = ?', whereArgs: [id]);

    if (maps.isNotEmpty) {
      return Artikel.fromMap(maps.first);
    }
    return null;
  }
}