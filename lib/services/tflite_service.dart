import 'dart:io';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class TfliteResult {
  final String label;
  final double confidence;
  final List<double> scores;
  TfliteResult({required this.label, required this.confidence, required this.scores});
}

class TfliteService {
  Interpreter? _interpreter;
  List<String> _labels = [];

  Future<void> load() async {
    _interpreter ??= await Interpreter.fromAsset('assets/model/model.tflite');

    final labelData = await rootBundle.loadString('assets/model/labels.txt');
    _labels = labelData
        .split('\n')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
  }

  /// NOTE: Ini versi "sementara" tanpa preprocess image beneran.
  /// Untuk uji pipeline, kita return dummy prediksi kalau belum siap preprocess.
  Future<TfliteResult> predictDummy() async {
    await load();
    final rand = Random();
    final idx = rand.nextInt(_labels.length);
    final conf = 0.6 + rand.nextDouble() * 0.35; // 0.60 - 0.95
    final scores = List<double>.filled(_labels.length, 0);
    scores[idx] = conf;
    return TfliteResult(label: _labels[idx], confidence: conf, scores: scores);
  }
}