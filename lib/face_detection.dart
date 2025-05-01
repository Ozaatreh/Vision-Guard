// import 'package:google_ml_kit/google_ml_kit.dart';

// class FaceDetectorService {
//   final FaceDetector _faceDetector = GoogleMlKit.vision.faceDetector(
//     FaceDetectorOptions(
//       enableTracking: true,
//       enableContours: true,
//       enableClassification: true,
//     ),
//   );

//   Future<List<Face>> detectFacesFromImage(InputImage inputImage) async {
//     return await _faceDetector.processImage(inputImage);
//   }

//   void dispose() {
//     _faceDetector.close();
//   }
// }