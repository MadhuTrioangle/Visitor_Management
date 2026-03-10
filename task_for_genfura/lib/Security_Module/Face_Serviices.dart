import 'dart:io';
 import 'package:image_picker/image_picker.dart';
 import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class FaceService {
  final ImagePicker _picker = ImagePicker();

  Future<File?> captureFromCamera() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );

    if (image != null) {
      return File(image.path);
    }
    return null;
  }

  Future<Face?> detectSingleFace(File file) async {
    final inputImage = InputImage.fromFile(file);
    final faceDetector = FaceDetector(
      options: FaceDetectorOptions(
        enableClassification: true,
        enableContours: true,
      ),
    );

    final faces = await faceDetector.processImage(inputImage);

    if (faces.isNotEmpty) {
      return faces.first;
    }
    return null;
  }

  // // Simple comparison (based on bounding box size & position)
  // bool isSameFace(Face face1, Face face2) {
  //   return (face1.boundingBox.width - face2.boundingBox.width).abs() < 20 &&
  //       (face1.boundingBox.height - face2.boundingBox.height).abs() < 20;
  // }
}