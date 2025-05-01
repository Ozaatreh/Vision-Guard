import 'package:camera/camera.dart';

class CameraService {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  Future<void> initialize() async {
    final cameras = await availableCameras();
    _controller = CameraController(
      cameras.first,
      ResolutionPreset.medium,
      enableAudio: false,
    );
    _initializeControllerFuture = _controller.initialize();
  }

  CameraController get controller => _controller;
  Future<void> get initializeFuture => _initializeControllerFuture;

  Future<XFile?> takePicture() async {
    try {
      await _initializeControllerFuture;
      return await _controller.takePicture();
    } catch (e) {
      return null;
    }
  }

  void dispose() {
    _controller.dispose();
  }
}