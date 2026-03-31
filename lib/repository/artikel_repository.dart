import '../core/artikel_data.dart';
import '../data/models/artikel_model.dart';

class ArtikelRepository {
  Future<List<Artikel>> ambilDaftar() async {
    return artikelData;
  }

  Future<Artikel?> ambilDetail(int id) async {
    try {
      return artikelData.firstWhere((artikel) => artikel.id == id);
    } catch (_) {
      return null;
    }
  }
}