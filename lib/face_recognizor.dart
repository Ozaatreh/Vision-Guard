import 'dart:math';

class FaceRecognizer {
  double _calculateDistance(List<double> a, List<double> b) {
    double sum = 0;
    for (int i = 0; i < a.length; i++) {
      sum += pow(a[i] - b[i], 2);
    }
    return sqrt(sum);
  }

  String? recognizeFace(
    List<double> embedding,
    Map<String, List<double>> knownFaces, {
    double threshold = 0.6,
  }) {
    String? recognizedName;
    double minDistance = double.infinity;

    knownFaces.forEach((name, knownEmbedding) {
      final distance = _calculateDistance(embedding, knownEmbedding);
      if (distance < threshold && distance < minDistance) {
        minDistance = distance;
        recognizedName = name;
      }
    });

    return recognizedName;
  }

  List<double> generateDummyEmbedding() {
    // In a real app, you would use a proper face embedding model
    return List.generate(128, (index) => Random().nextDouble());
  }
}