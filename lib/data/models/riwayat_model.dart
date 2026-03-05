class RiwayatDeteksi {
  final String localId; // UUID, kunci global (penting untuk sync)
  final DateTime timestamp;
  final String gambar; // local image path
  final String label;
  final double confidence;
  final String description;

  // untuk nanti sync (v2)
  final String syncState; // local_only | pending_upload | synced | pending_delete
  final String? storagePath; // path di Firebase Storage nanti

  RiwayatDeteksi({
    required this.localId,
    required this.timestamp,
    required this.gambar,
    required this.label,
    required this.confidence,
    required this.description,
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
      description: (map['description'] ?? '') as String,
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
      'description': description,
      'sync_state': syncState,
      'storage_path': storagePath,
    };
  }
}