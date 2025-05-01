
import 'package:hive_flutter/adapters.dart';

class FaceDatabase {
  static const String _boxName = 'faceDatabase';

  Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox<Map>(_boxName);
  }

  Future<void> saveFace(String name, List<double> embedding) async {
    final box = Hive.box<Map>(_boxName);
    await box.put(name, {'embedding': embedding, 'date': DateTime.now()});
  }

  Map<String, List<double>> getAllFaces() {
    final box = Hive.box<Map>(_boxName);
    final faces = <String, List<double>>{};
    for (var key in box.keys) {
      faces[key] = List<double>.from(box.get(key)?['embedding'] ?? []);
    }
    return faces;
  }

  Future<void> deleteFace(String name) async {
    final box = Hive.box<Map>(_boxName);
    await box.delete(name);
  }
}