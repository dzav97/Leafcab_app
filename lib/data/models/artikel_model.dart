class Artikel {
  final int? id;
  final String judul;
  final String isi;
  final String gambar;

  Artikel({
    this.id,
    required this.judul,
    required this.isi,
    required this.gambar,
  });

  // Mengubah Map dari SQLite menjadi Object Artikel
  factory Artikel.fromMap(Map<String, dynamic> map) {
    return Artikel(
      id: map['id'],
      judul: map['judul'],
      isi: map['isi'],
      gambar: map['gambar'],
    );
  }

  // Mengubah Object Artikel menjadi Map untuk disimpan ke SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'judul': judul,
      'isi': isi,
      'gambar': gambar,
    };
  }
}