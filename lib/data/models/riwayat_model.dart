class HasilDeteksi {
  final int? id;
  final String label;
  final double confidence;

  HasilDeteksi({this.id, required this.label, required this.confidence});

  factory HasilDeteksi.fromMap(Map<String, dynamic> map) {
    return HasilDeteksi(
      id: map['id'],
      label: map['label'],
      confidence: map['confidence'].toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'label': label,
      'confidence': confidence,
    };
  }
}

class RiwayatDeteksi {
  final int? id;
  final DateTime timestamp;
  final String gambar; // Path lokasi file gambar yang disimpan di HP
  final HasilDeteksi hasil; // Relasi ke HasilDeteksi

  RiwayatDeteksi({
    this.id,
    required this.timestamp,
    required this.gambar,
    required this.hasil,
  });

  factory RiwayatDeteksi.fromMap(Map<String, dynamic> map, HasilDeteksi hasilObj) {
    return RiwayatDeteksi(
      id: map['id'],
      timestamp: DateTime.parse(map['timestamp']),
      gambar: map['gambar'],
      hasil: hasilObj,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'timestamp': timestamp.toIso8601String(),
      'gambar': gambar,
      // Biasanya ID hasil disimpan sebagai foreign key di tabel riwayat
      'hasil_id': hasil.id, 
    };
  }
}