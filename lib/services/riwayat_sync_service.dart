import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;

import '../data/models/riwayat_model.dart';
import '../repository/riwayat_repository.dart';

class RiwayatSyncService {
  final RiwayatRepository _repo = RiwayatRepository();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> syncRiwayat() async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      final items = await _repo.ambilPerluSync(user.uid);

      for (final item in items) {
        try {
          if (item.syncState == 'pending_delete') {
            await _syncDelete(item);
          } else {
            await _syncUpsert(item);
          }
        } catch (e) {
          debugPrint('Sync gagal ${item.localId}: $e');
        }
      }
    } catch (e) {
      debugPrint('Sync riwayat gagal: $e');
    }
  }

  Future<void> restoreRiwayatDariCloud() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final snapshot = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('riwayat_deteksi')
        .where('is_deleted', isEqualTo: 0)
        .get();

    for (final doc in snapshot.docs) {
      final data = doc.data();

      final timestampRaw =
          (data['timestamp'] ?? DateTime.now().toIso8601String()) as String;

      final updatedAtRaw =
          (data['updated_at'] ?? timestampRaw) as String;

      final localId =
          (data['local_id'] ?? doc.id) as String;

      final existingItem =
          await _repo.ambilByLocalId(localId);

      if (existingItem != null &&
          existingItem.syncState == 'pending_delete') {
        continue;
      }

      final item = RiwayatDeteksi(
        localId: localId,
        userId: (data['user_id'] ?? user.uid) as String,
        cloudId: doc.id,
        timestamp: DateTime.parse(timestampRaw),
        updatedAt: DateTime.parse(updatedAtRaw),
        gambar: existingItem?.gambar ?? '',
        label: (data['label'] ?? '-') as String,
        confidence: ((data['confidence'] ?? 0) as num).toDouble(),
        gejala: (data['gejala'] ?? '') as String,
        pengendalian: (data['pengendalian'] ?? '') as String,
        syncState: 'synced',
        isDeleted: ((data['is_deleted'] ?? 0) as num).toInt(),
        storagePath: data['storage_path'] as String?,
        imageBase64: data['image_base64'] as String?,
      );

      await _repo.upsert(item);
    }
  }

  Future<void> _syncUpsert(RiwayatDeteksi item) async {
    try {
      String? imageBase64 = item.imageBase64;

      if ((imageBase64 == null || imageBase64.isEmpty) &&
          item.gambar.isNotEmpty) {
        final imageFile = File(item.gambar);

        if (await imageFile.exists()) {
          imageBase64 = await _imageToCompressedBase64(imageFile);
        }
      }

      final collection = _firestore
          .collection('users')
          .doc(item.userId)
          .collection('riwayat_deteksi');

      final docRef = (item.cloudId != null &&
              item.cloudId!.isNotEmpty)
          ? collection.doc(item.cloudId)
          : collection.doc();

      await docRef.set(
        {
          'local_id': item.localId,
          'user_id': item.userId,
          'timestamp': item.timestamp.toIso8601String(),
          'updated_at': item.updatedAt.toIso8601String(),
          'label': item.label,
          'confidence': item.confidence,
          'gejala': item.gejala,
          'pengendalian': item.pengendalian,
          'sync_state': 'synced',
          'is_deleted': item.isDeleted,
          'storage_path': null,
          'image_base64': imageBase64,
          'created_at_server': FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );

      await _repo.tandaiSudahSync(
        localId: item.localId,
        cloudId: docRef.id,
      );
    } catch (e) {
      debugPrint('Gagal sync upsert riwayat: $e');
    }
  }

  Future<void> _syncDelete(RiwayatDeteksi item) async {
    try {
      if (item.cloudId != null &&
          item.cloudId!.isNotEmpty) {
        await _firestore
            .collection('users')
            .doc(item.userId)
            .collection('riwayat_deteksi')
            .doc(item.cloudId)
            .delete();
      }

      await _repo.hapusPermanen(item.localId);
    } catch (e) {
      debugPrint('Gagal sync delete riwayat: $e');
    }
  }

  Future<String?> _imageToCompressedBase64(File file) async {
    final bytes = await file.readAsBytes();
    final decodedImage = img.decodeImage(bytes);

    if (decodedImage == null) return null;

    final resizedImage = img.copyResize(
      decodedImage,
      width: 512,
    );

    final jpgBytes = img.encodeJpg(
      resizedImage,
      quality: 60,
    );

    return base64Encode(jpgBytes);
  }
}