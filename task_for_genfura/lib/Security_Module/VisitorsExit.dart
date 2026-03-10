import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image_picker/image_picker.dart';

import 'Face_Detection.dart';
import 'Face_Serviices.dart';

class ApprovedVisitorsScreen extends StatelessWidget {

   ApprovedVisitorsScreen({super.key});

  FaceFirestoreService fireStore =FaceFirestoreService();
   final FaceService _faceService = FaceService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Approved Visitors")),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("Visitors")
            .where("status", isEqualTo: "Approved")
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          var visitors = snapshot.data!.docs;

          return ListView.builder(
            itemCount: visitors.length,
            itemBuilder: (context, index) {
              var visitor = visitors[index];

              return ListTile(
                leading: const Icon(Icons.person),
                title: Text(visitor["name"]),
                subtitle: Text(visitor["purpose"]),
                trailing: const Icon(Icons.exit_to_app),
                onTap: () {

                  captureExit(visitor["visitorId"]);
                  // captureExitFace(context, visitor.id, visitor["faceData"]);
                },
              );
            },
          );
        },
      ),
    );
  }

   Future<void> captureExit(String visitorID) async {
     // if (storedFace == null) {
     //   ScaffoldMessenger.of(context).showSnackBar(
     //     const SnackBar(content: Text("No entry face stored.")),
     //   );
     //   return;
     // }

     File? image = await _faceService.captureFromCamera();

     if (image != null) {
       Face? newFace =
       await _faceService.detectSingleFace(image);

       if (newFace != null) {
         print("logout da");
         fireStore.logoutVisitor(visitorID, newFace);



       }
     }
   }


}