import 'package:flutter/material.dart';
import 'face_detection_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: FaceDetectionView(),
      debugShowCheckedModeBanner: false,
    );
  }
}























// import 'dart:async';
// import 'dart:io';
// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:path/path.dart' as path;
// import 'package:permission_handler/permission_handler.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   runApp(const CameraApp());
// }

// class CameraApp extends StatefulWidget {
//   const CameraApp({Key? key}) : super(key: key);

//   @override
//   State<CameraApp> createState() => _CameraAppState();
// }

// class _CameraAppState extends State<CameraApp> {
//   bool _hasPermission = false;
//   CameraController? _controller;
//   List<CameraDescription>? _cameras;
//   String? _imagePath;
//   int _selectedCameraIndex = 0;
//   bool _isRearCameraSelected = true;

//   @override
//   void initState() {
//     super.initState();
//     _checkPermissions();
//   }

//   Future<void> _checkPermissions() async {
//     final status = await Permission.camera.request();
//     if (status.isGranted) {
//       setState(() => _hasPermission = true);
//       _initializeCamera();
//     } else {
//       setState(() => _hasPermission = false);
//     }
//   }

//   Future<void> _initializeCamera() async {
//     _cameras = await availableCameras();
//     if (_cameras!.isNotEmpty) {
//       _setCameraController(_selectedCameraIndex);
//     }
//   }

//   Future<void> _setCameraController(int index) async {
//     if (_controller != null) {
//       await _controller!.dispose();
//     }
    
//     _controller = CameraController(
//       _cameras![index],
//       ResolutionPreset.medium,
//     );
    
//     _controller!.addListener(() {
//       if (mounted) setState(() {});
//     });
    
//     try {
//       await _controller!.initialize();
//     } catch (e) {
//       debugPrint('Error initializing camera: $e');
//     }
    
//     if (mounted) {
//       setState(() {
//         _selectedCameraIndex = index;
//         _isRearCameraSelected = _cameras![index].lensDirection == CameraLensDirection.back;
//       });
//     }
//   }

//   Future<void> _switchCamera() async {
//     if (_cameras == null || _cameras!.length < 2) return;
    
//     final newIndex = _selectedCameraIndex == 0 ? 1 : 0;
//     await _setCameraController(newIndex);
//   }

//   Future<void> _takePicture() async {
//     if (_controller == null || !_controller!.value.isInitialized) {
//       return;
//     }

//     try {
//       final Directory extDir = await getApplicationDocumentsDirectory();
//       final String dirPath = '${extDir.path}/Pictures/flutter_camera';
//       await Directory(dirPath).create(recursive: true);
//       final String filePath = path.join(
//         dirPath,
//         '${DateTime.now().millisecondsSinceEpoch}.jpg',
//       );

//       final XFile picture = await _controller!.takePicture();
//       await File(picture.path).copy(filePath);
      
//       setState(() {
//         _imagePath = filePath;
//       });
//     } catch (e) {
//       debugPrint('Error taking picture: $e');
//     }
//   }

//   @override
//   void dispose() {
//     _controller?.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//         appBar: AppBar(
//           centerTitle: true,
//           title: const Text('Camera App'),
//           actions: [
//             if (!_hasPermission)
//               IconButton(
//                 icon: const Icon(Icons.settings),
//                 onPressed: () => openAppSettings(),
//               ),
//           ],
//         ),
//         body: _buildBody(),
//         floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
//         floatingActionButton: _hasPermission && _controller != null && _controller!.value.isInitialized
//             ? Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   FloatingActionButton(
//                     onPressed: _switchCamera,
//                     heroTag: 'switchCamera',
//                     child: Icon(
//                       _isRearCameraSelected 
//                           ? Icons.camera_front 
//                           : Icons.camera_rear,
//                     ),
//                   ),
//                   FloatingActionButton(
//                     onPressed: _takePicture,
//                     child: const Icon(Icons.camera),
//                     heroTag: 'takePicture',
//                   ),
//                 ],
//               )
//             : null,
//       ),
//     );
//   }

//   Widget _buildBody() {
//     if (!_hasPermission) {
//       return const Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(Icons.motion_photos_off_rounded, size: 64),
//             SizedBox(height: 16),
//             Text('Camera permission denied'),
//             Text('Please enable camera access in settings'),
//           ],
//         ),
//       );
//     }

//     if (_controller == null || !_controller!.value.isInitialized) {
//       return const Center(child: CircularProgressIndicator());
//     }

//     return Column(
//       children: [
//         Expanded(
//           child: AspectRatio(
//             aspectRatio: _controller!.value.aspectRatio,
//             child: CameraPreview(_controller!),
//           ),
//         ),
//         if (_imagePath != null)
//           Expanded(
//             child: Image.file(File(_imagePath!)),
//           ),
//       ],
//     );
//   }
// }