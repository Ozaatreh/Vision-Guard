// import 'package:flutter/material.dart';
// import 'package:flutter_hooks/flutter_hooks.dart';
// import 'package:camera/camera.dart';
// import 'package:google_ml_kit/google_ml_kit.dart';
// import 'package:vision_guard/camera_services.dart';
// import 'package:vision_guard/database/face_database.dart';
// import 'package:vision_guard/face_detection.dart';
// import 'package:vision_guard/face_recognizor.dart';


// class FaceDetectionApp extends HookWidget {
//   @override
//   Widget build(BuildContext context) {
//     final cameraService = useMemoized(() => CameraService());
//     final faceDetector = useMemoized(() => FaceDetectorService());
//     final faceRecognizer = useMemoized(() => FaceRecognizer());
//     final faceDatabase = useMemoized(() => FaceDatabase());
    
//     final isInitialized = useState(false);
//     final facesDetected = useState<List<Face>>([]);
//     final recognizedFaces = useState<Map<int, String>>({});

//     useEffect(() {
//       Future<void> init() async {
//         await faceDatabase.init();
//         await cameraService.initialize();
//         isInitialized.value = true;
//       }

//       init();
//       return () {
//         cameraService.dispose();
//         faceDetector.dispose();
//       };
//     }, []);

//     useEffect(() {
//       if (!isInitialized.value) return null;

//       final knownFaces = faceDatabase.getAllFaces();
//       final controller = cameraService.controller;

//    controller.startImageStream((CameraImage image) async {
//   final inputImage = InputImage.fromBytes(
//     bytes: image.planes[0].bytes,
//     inputImageData: InputImageData(
//       size: Size(image.width.toDouble(), image.height.toDouble()),
//       imageRotation: InputImageRotation.rotation0deg,
//       inputImageFormat: InputImageFormat.yuv420,
//       planeData: image.planes.map((plane) {
//         return InputImagePlaneMetadata(
//           bytesPerRow: plane.bytesPerRow,
//           height: plane.height,
//           width: plane.width,
//         );
//       }).toList(),
//     ),
//   );

//   final faces = await faceDetector.detectFacesFromImage(inputImage);
//   facesDetected.value = faces;

//   final newRecognizedFaces = <int, String>{};
//   for (final face in faces) {
//     final dummyEmbedding = faceRecognizer.generateDummyEmbedding();
//     final recognizedName = faceRecognizer.recognizeFace(
//       dummyEmbedding,
//       knownFaces,
//     );
//     if (recognizedName != null) {
//       newRecognizedFaces[face.trackingId ?? face.hashCode] = recognizedName;
//     }
//   }
//   recognizedFaces.value = newRecognizedFaces;
// }); // ✅ <-- this closing parenthesis and semicolon were missing


//       return null;
//     }, [isInitialized.value]);

//     if (!isInitialized.value) {
//       return const Scaffold(
//         body: Center(child: CircularProgressIndicator()),
//       );
//     }

//     return Scaffold(
//       appBar: AppBar(title: const Text('Face Detection & Recognition')),
//       body: Stack(
//         children: [
//           CameraPreview(cameraService.controller),
//           CustomPaint(
//             painter: FacePainter(
//               faces: facesDetected.value,
//               recognizedFaces: recognizedFaces.value,
//               imageSize: Size(
//                 cameraService.controller.value.previewSize?.height ?? 0,
//                 cameraService.controller.value.previewSize?.width ?? 0,
//               ),
//             ),
//           ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         child: const Icon(Icons.add),
//         onPressed: () => _showAddFaceDialog(context, cameraService, faceDatabase),
//       ),
//     );
//   }

//   Future<void> _showAddFaceDialog(
//     BuildContext context,
//     CameraService cameraService,
//     FaceDatabase faceDatabase,
//   ) async {
//     final nameController = TextEditingController();
//     return showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Register New Face'),
//         content: TextField(
//           controller: nameController,
//           decoration: const InputDecoration(hintText: 'Enter name'),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () async {
//               if (nameController.text.isNotEmpty) {
//                 final dummyEmbedding = FaceRecognizer().generateDummyEmbedding();
//                 await faceDatabase.saveFace(nameController.text, dummyEmbedding);
//                 Navigator.pop(context);
//               }
//             },
//             child: const Text('Save'),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class FacePainter extends CustomPainter {
//   final List<Face> faces;
//   final Map<int, String> recognizedFaces;
//   final Size imageSize;

//   FacePainter({
//     required this.faces,
//     required this.recognizedFaces,
//     required this.imageSize,
//   });

//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 2.0
//       ..color = Colors.green;

//     final textPaint = Paint()
//       ..color = Colors.white
//       ..style = PaintingStyle.fill;

//     for (final face in faces) {
//       final rect = Rect.fromLTRB(
//         face.boundingBox.left,
//         face.boundingBox.top,
//         face.boundingBox.right,
//         face.boundingBox.bottom,
//       );

//       final scaleX = size.width / imageSize.height;
//       final scaleY = size.height / imageSize.width;
//       final offsetX = (size.width - imageSize.height * scaleX) / 2;
//       final offsetY = (size.height - imageSize.width * scaleY) / 2;

//       final scaledRect = Rect.fromLTRB(
//         rect.left * scaleX + offsetX,
//         rect.top * scaleY + offsetY,
//         rect.right * scaleX + offsetX,
//         rect.bottom * scaleY + offsetY,
//       );

//       canvas.drawRect(scaledRect, paint);

//       final faceId = face.trackingId ?? face.hashCode;
//       if (recognizedFaces.containsKey(faceId)) {  // This was the problematic line
//         final textSpan = TextSpan(
//           text: recognizedFaces[faceId]!,
//           style: TextStyle(backgroundColor: Colors.black.withOpacity(0.5)),
//         );
//         final textPainter = TextPainter(
//           text: textSpan,
//           textDirection: TextDirection.ltr,
//         );
//         textPainter.layout();
//         textPainter.paint(
//           canvas,
//           Offset(scaledRect.left, scaledRect.top - textPainter.height),
//         );
//       }
//     }
//   }

//   @override
//   bool shouldRepaint(FacePainter oldDelegate) {
//     return oldDelegate.faces != faces || oldDelegate.recognizedFaces != recognizedFaces;
//   }
// }