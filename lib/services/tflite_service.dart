import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

class TfliteResult {
  final String label;
  final double confidence;
  final List<double> scores;

  TfliteResult({
    required this.label,
    required this.confidence,
    required this.scores,
  });
}

class TfliteService {
  Interpreter? _interpreter;
  List<String> _labels = [];
  int _inputSize = 224;

  Future<void> load() async {
    _interpreter ??= await Interpreter.fromAsset('assets/model/model.tflite');

    final labelData = await rootBundle.loadString('assets/model/labels.txt');
    _labels = labelData
        .split('\n')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    _inputSize = 224;
  }

  Future<TfliteResult> predictImage(File imageFile) async {
    await load();

    final imageBytes = await imageFile.readAsBytes();
    final originalImage = img.decodeImage(imageBytes);

    if (originalImage == null) {
      throw Exception('Gagal membaca gambar.');
    }

    final resizedImage = img.copyResize(
      originalImage,
      width: _inputSize,
      height: _inputSize,
    );

    final input = _imageToInputTensor(resizedImage);

    final output = List.generate(
      1,
      (_) => List.filled(_labels.length, 0.0),
    );

    _interpreter!.run(input, output);

    final scores = List<double>.from(output[0]);
    final confidence = scores.reduce(math.max);
    final predictedIndex = scores.indexOf(confidence);

    final label = _labels[predictedIndex];

    return TfliteResult(
      label: label,
      confidence: confidence,
      scores: scores,
    );
  }

  List<List<List<List<double>>>> _imageToInputTensor(img.Image image) {
    return [
      List.generate(_inputSize, (y) {
        return List.generate(_inputSize, (x) {
          final pixel = image.getPixel(x, y);

          final r = (pixel.r.toDouble() / 127.5) - 1.0;
          final g = (pixel.g.toDouble() / 127.5) - 1.0;
          final b = (pixel.b.toDouble() / 127.5) - 1.0;

          return [r, g, b];
        });
      }),
    ];
  }

  void close() {
    _interpreter?.close();
    _interpreter = null;
  }
}