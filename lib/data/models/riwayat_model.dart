class RiwayatDeteksi {
  final String localId;
  final String userId;
  final String? cloudId;
  final DateTime timestamp;
  final DateTime updatedAt;
  final String gambar;
  final String label;
  final double confidence;
  final String gejala;
  final String pengendalian;
  final String syncState;
  final int isDeleted;
  final String? storagePath;

  RiwayatDeteksi({
    required this.localId,
    required this.userId,
    this.cloudId,
    required this.timestamp,
    required this.updatedAt,
    required this.gambar,
    required this.label,
    required this.confidence,
    required this.gejala,
    required this.pengendalian,
    this.syncState = 'local_only',
    this.isDeleted = 0,
    this.storagePath,
  });

  factory RiwayatDeteksi.fromMap(Map<String, dynamic> map) {
    final timestampRaw = map['timestamp'] as String;
    final updatedAtRaw = map['updated_at'] as String?;

    return RiwayatDeteksi(
      localId: map['local_id'] as String,
      userId: (map['user_id'] ?? '') as String,
      cloudId: map['cloud_id'] as String?,
      timestamp: DateTime.parse(timestampRaw),
      updatedAt: (updatedAtRaw != null && updatedAtRaw.isNotEmpty)
          ? DateTime.parse(updatedAtRaw)
          : DateTime.parse(timestampRaw),
      gambar: map['gambar'] as String,
      label: map['label'] as String,
      confidence: (map['confidence'] as num).toDouble(),
      gejala: (map['gejala'] ?? '') as String,
      pengendalian: (map['pengendalian'] ?? '') as String,
      syncState: (map['sync_state'] ?? 'local_only') as String,
      isDeleted: ((map['is_deleted'] ?? 0) as num).toInt(),
      storagePath: map['storage_path'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'local_id': localId,
      'user_id': userId,
      'cloud_id': cloudId,
      'timestamp': timestamp.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'gambar': gambar,
      'label': label,
      'confidence': confidence,
      'gejala': gejala,
      'pengendalian': pengendalian,
      'sync_state': syncState,
      'is_deleted': isDeleted,
      'storage_path': storagePath,
    };
  }

  RiwayatDeteksi copyWith({
    String? localId,
    String? userId,
    String? cloudId,
    DateTime? timestamp,
    DateTime? updatedAt,
    String? gambar,
    String? label,
    double? confidence,
    String? gejala,
    String? pengendalian,
    String? syncState,
    int? isDeleted,
    String? storagePath,
  }) {
    return RiwayatDeteksi(
      localId: localId ?? this.localId,
      userId: userId ?? this.userId,
      cloudId: cloudId ?? this.cloudId,
      timestamp: timestamp ?? this.timestamp,
      updatedAt: updatedAt ?? this.updatedAt,
      gambar: gambar ?? this.gambar,
      label: label ?? this.label,
      confidence: confidence ?? this.confidence,
      gejala: gejala ?? this.gejala,
      pengendalian: pengendalian ?? this.pengendalian,
      syncState: syncState ?? this.syncState,
      isDeleted: isDeleted ?? this.isDeleted,
      storagePath: storagePath ?? this.storagePath,
    );
  }
}