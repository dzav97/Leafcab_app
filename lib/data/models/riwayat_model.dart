class RiwayatDeteksi {
  final String localId;
  final DateTime timestamp;
  final String gambar;
  final String label;
  final double confidence;
  final String gejala;
  final String pengendalian;
  final String syncState;
  final String? storagePath;

  RiwayatDeteksi({
    required this.localId,
    required this.timestamp,
    required this.gambar,
    required this.label,
    required this.confidence,
    required this.gejala,
    required this.pengendalian,
    this.syncState = 'local_only',
    this.storagePath,
  });

  factory RiwayatDeteksi.fromMap(Map<String, dynamic> map) {
    return RiwayatDeteksi(
      localId: map['local_id'] as String,
      timestamp: DateTime.parse(map['timestamp'] as String),
      gambar: map['gambar'] as String,
      label: map['label'] as String,
      confidence: (map['confidence'] as num).toDouble(),
      gejala: (map['gejala'] ?? '') as String,
      pengendalian: (map['pengendalian'] ?? '') as String,
      syncState: (map['sync_state'] ?? 'local_only') as String,
      storagePath: map['storage_path'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'local_id': localId,
      'timestamp': timestamp.toIso8601String(),
      'gambar': gambar,
      'label': label,
      'confidence': confidence,
      'gejala': gejala,
      'pengendalian': pengendalian,
      'sync_state': syncState,
      'storage_path': storagePath,
    };
  }
}