import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class FaceFirestoreService {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Convert Face bounding box to Map
  Map<String, dynamic> faceToMap(Face face) {
    return {
      "left": face.boundingBox.left,
      "top": face.boundingBox.top,
      "width": face.boundingBox.width,
      "height": face.boundingBox.height,
    };
  }

  /// Convert Map back to Face-like structure
  Map<String, double> mapToFace(Map data) {
    return {
      "left": data["left"],
      "top": data["top"],
      "width": data["width"],
      "height": data["height"],
    };
  }

  /// Save face data with visitor
  Future<void> saveFace(
      String visitorId,
      Face face,
      ) async {

    await _firestore.collection("Visitors").doc(visitorId).update({
      "faceData": faceToMap(face)
    });
  }

  /// Get face data from firestore
  Future<Map<String, double>?> getFace(String visitorId) async {

    final doc = await _firestore
        .collection("Visitors")
        .doc(visitorId)
        .get();

    if (doc.exists && doc.data()?["faceData"] != null) {
      return mapToFace(doc.data()!["faceData"]);
    }

    return null;
  }

  /// Compare stored face with new face
  bool compareFace(Map<String, double> storedFace, Face newFace) {

    double widthDiff =
    (storedFace["width"]! - newFace.boundingBox.width).abs();

    double heightDiff =
    (storedFace["height"]! - newFace.boundingBox.height).abs();

    return widthDiff < 20 && heightDiff < 20;
  }

  /// Logout visitor if face matches
  Future<bool> logoutVisitor(
      String visitorId,
      Face newFace,
      ) async {

    print("visitoo$visitorId");

    Map<String, double>? storedFace =
    await getFace(visitorId);

    if (storedFace == null) {
      return false;
    }else{
      print("Something");
    }


    bool same = compareFace(storedFace, newFace);

    if (same) {
      print("same da");
      await _firestore.collection("Visitors")
          .doc(visitorId)
          .update({
        "exitTime": Timestamp.now(),
        "status": "Completed"
      });

      return true;
    }

    return false;
  }
}