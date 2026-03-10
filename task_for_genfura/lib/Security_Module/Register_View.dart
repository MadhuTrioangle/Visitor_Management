import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

import 'Face_Detection.dart';
import 'Face_Serviices.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as auth;


class RegisterVisitorScreen extends StatefulWidget {
  const RegisterVisitorScreen({Key? key}) : super(key: key);

  @override
  State<RegisterVisitorScreen> createState() =>
      _RegisterVisitorScreenState();
}

class _RegisterVisitorScreenState
    extends State<RegisterVisitorScreen> {
  final _formKey = GlobalKey<FormState>();
   final FaceService _faceService = FaceService();
  final FaceFirestoreService fireStoreFace = FaceFirestoreService();
  final TextEditingController nameController =
  TextEditingController();
  final TextEditingController mobileController =
  TextEditingController();
  final TextEditingController purposeController =
  TextEditingController();
  final TextEditingController hostController =
  TextEditingController();

  String status = "Pending";

  DateTime? entryTime;
  DateTime? exitTime;

  File? entryImage;
   Face? storedFace;

  //📷 Capture Entry Face
  Future<void> captureEntry() async {
    File? image = await _faceService.captureFromCamera();

    if (image != null) {
      Face? face = await _faceService.detectSingleFace(image);

      if (face != null) {
        setState(() {
          entryImage = image;
          storedFace = face;
          entryTime = DateTime.now();
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Face detected. Entry marked.")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No face detected.")),
        );
      }
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register Visitor")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [

              TextFormField(
                controller: nameController,
                decoration:
                const InputDecoration(labelText: "Name"),
              ),

              TextFormField(
                controller: mobileController,
                decoration: const InputDecoration(
                    labelText: "Mobile Number"),
              ),

              TextFormField(
                controller: purposeController,
                decoration:
                const InputDecoration(labelText: "Purpose"),
              ),

              TextFormField(
                controller: hostController,
                decoration:
                const InputDecoration(labelText: "Host Name"),
              ),

              const SizedBox(height: 10),

              DropdownButtonFormField<String>(
                value: status,
                items: const [
                  DropdownMenuItem(
                      value: "Pending",
                      child: Text("Pending")),
                  DropdownMenuItem(
                      value: "Approved",
                      child: Text("Approved")),
                  DropdownMenuItem(
                      value: "Rejected",
                      child: Text("Rejected")),
                  DropdownMenuItem(
                      value: "Completed",
                      child: Text("Completed")),
                ],
                onChanged: (value) {
                  setState(() {
                    status = value!;
                  });
                },
                decoration:
                const InputDecoration(labelText: "Status"),
              ),

              const SizedBox(height: 20),

              if (entryTime != null)
                Text("Entry Time: $entryTime"),

              if (exitTime != null)
                Text("Exit Time: $exitTime"),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed:
                captureEntry,
                child: const Text("Capture Entry Face"),
              ),

              const SizedBox(height: 10),

              // ElevatedButton(
              //   onPressed: captureExit,
              //   child: const Text("Capture Exit Face"),
              // ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await registerVisitor();

                    // ScaffoldMessenger.of(context).showSnackBar(
                    //   const SnackBar(
                    //     content: Text("Visitor Registered & Request Sent to Host"),
                    //   ),
                    // );
                  }
                },
                child: const Text("Submit & Send Request"),
              ),

              if (entryImage != null)
                Image.file(entryImage!, height: 150),

            ],
          ),
        ),
      ),
    );
  }

  Future<void> registerVisitor() async {
    var hostDoc = await FirebaseFirestore.instance
        .collection("Users")
        .where("name", isEqualTo: hostController.text)
        .get();
    print("host${hostDoc.docs}");

    if (hostDoc.docs.isNotEmpty) {
      String hostToken = hostDoc.docs.first["fcmToken"];

      // 2. Save Visitor Data to Firestore
      DocumentReference visitorRef = await FirebaseFirestore.instance.collection("Visitors").add({
        "name": nameController.text,
        "mobileNumber": mobileController.text,
        "purpose": purposeController.text,
        "hostName": hostController.text,
        "status": status,
        "entryTime": entryTime != null ? Timestamp.fromDate(entryTime!) : null,
        "exitTime": exitTime != null ? Timestamp.fromDate(exitTime!) : null,

      });
      await visitorRef.update({
        "visitorId": visitorRef.id,
      });
      fireStoreFace.saveFace(visitorRef.id, storedFace!);

      await sendNotificationToHost(hostToken);
    }
  }


  // Future<void> sendNotificationToHost(String deviceToken) async {
  //   // 1. Your Service Account Details (from the JSON file you downloaded)
  //   final serviceAccount = {
  //     "project_id": "visitor-management-ba141",
  //     "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQC2u3wb8ppGYvz0\ncQ8kKWZry5VtzErRflEDh3K2Scwt08N4g4OX9Q9WopnRk5DjlL0zstG5m6mHyTTn\napXBJaNjnB/10dHJ+pYuULba09g6NYiWNW4oUMFumSZBlw2/5iMnuCrTAqCHW2Ex\nIrHO5HZ6tyNDw0ZEaClYQ1ZuYUhLxD+LLn+J9YugPcsJ+M7BayOSv7tMnDqlN48e\neVia5sWzprboNM2UByt8mG2hO/fnsTBRa8QtKnE7e9chZ0VGIdQQO2TmV3Hj9gBa\nd706rA5ijxUXUtuerbI6CEXo/wcLmMPofwIzxWgWYHLQeBv5osfp350CPCP9SU0m\nesY641aRAgMBAAECggEAC+xzzAK6heVvgkd+rdpPZFvNCknbx6FBieR/UVKYnT9A\nS0obnra0iO+ZxWbmvARIjJ8lF8KG9K+7Vm6/oFzuH9xqv83bQwh+tGglvRA4lQ3J\nYJx9GGoyll6tyXcLmY4bv6ZWZwf4xR8ARSZG1MxWyH768QZE53GmNwFH2nKEdusW\nYg1aEQDZsN0LN2bdr/kvkaOj8kxBFid8tStW4zkuiUrQHShw3I4xo5TZjaNmBU1F\nwJzj7bfXnwoUp6EN3OGSLMHUmTMnEqW7MhVELY+4DLGVuUkaPhxNopWtEGu8hksb\nLEkCNI3HqL37s/pqyTi+qaRGTSEUkzt/3aoVceGbxQKBgQDYrSNyQLnz0srJtlEf\nlGSJSrEbY1uDUYPVAFluQM+8odqQEgCeEmxgB2lUlq8g6A/OjhDyTdfuz5Oqnpi2\nit/xIKxSVYcMY9yjs3J/LFV0bS+RrLge9xEydeNU+s7EPOf2/C4YHX1ysz6aaT9N\n1MvUHwXyJ3uavhQfKkMACgzUxQKBgQDX5UwpN0df2PqTWfIZUB+Jw8RRvlQu/nZh\nZ/Arzv5hlXSltWP67ThtiS3QCzJSeCmRQu3++k8zn6lbE7QGDsP4iWbpt5r3m8cP\nNeVxxKchds3kHPy7NxnF6FpXFg8zJXl2xYD9eBBDVnj8B3QamIsc0MFqjqSjOpBZ\ns1PUGeCPXQKBgQC359SDH+70xUA7jtQyEph2cv/5uA4vWlujyWUekEIB3/qLd8ww\nXoC/zOqY0kCYlH7+GVTG5E1Xs7WpBm2l2h+TIOFCDLfQS141T5Tp3e42IIpUgZ3R\nInDlPGwUb8BZjTxxRL+21ijo1rxXAOerHudWBnLcgqiFwbmAbjVp7h3P5QKBgBFy\nRiVOgkYMkrM1oYrKHsJTP5obd1IU3hwg+heQMp5QJYz+i4XLhbPUUg9t2DMx4qoK\nbpEcSSoyzMy/WtzidJOxBs/8NlmsDPn9sPzwl1Ds+NZmQUYfvcVwcVx4O+I2NQqU\nC0hwW2AVrNExCQDdMuCxPfAOdt957BBTnYKWVL9BAoGBANipiFXmYYNAvg3RTrfP\n/eXx115RkPXNMJ+vV8E1KxPjfyXXEtMckruWRxCXtrzq/65ZCb6JmgFhSoVTIu0W\n5GV62twmVuGGUvJBW7B659KF6HvbUfAc8MW1KlaMTIP6x/hoA1rkQ2bkbsNPLChx\nmMor0MGUTaw+FlaiVFbzsDjJ\n-----END PRIVATE KEY-----\n",
  //     "client_email": "firebase-adminsdk-fbsvc@visitor-management-ba141.iam.gserviceaccount.com",
  //   };
  //
  //   // 2. Generate the OAuth 2.0 Access Token
  //   final auth = GAuth.fromMap(serviceAccount);
  //   final token = await auth.getAccessToken(['https://www.googleapis.com/auth/firebase.messaging']);
  //
  //   // 3. Construct the FCM HTTP v1 URL
  //   final String url = 'https://fcm.googleapis.com/v1/projects/${serviceAccount['project_id']}/messages:send';
  //
  //   // 4. Create the Notification Payload
  //   final Map<String, dynamic> payload = {
  //     'message': {
  //       'token': deviceToken, // The FCM token of the HOST device
  //       'notification': {
  //         'title': 'Hello Host!',
  //         'body': 'This message came directly from the Flutter app.',
  //       },
  //       'data': {
  //         'click_action': 'FLUTTER_NOTIFICATION_CLICK',
  //         'status': 'done',
  //       }
  //     }
  //   };
  //
  //   // 5. Send the Request
  //   final response = await http.post(
  //     Uri.parse(url),
  //     headers: {
  //       'Content-Type': 'application/json',
  //       'Authorization': 'Bearer $token',
  //     },
  //     body: jsonEncode(payload),
  //   );
  //
  //   if (response.statusCode == 200) {
  //     print('Notification Sent Successfully: ${response.body}');
  //   } else {
  //     print('Failed to send notification: ${response.statusCode}');
  //     print('Error: ${response.body}');
  //   }
  // }





  Future<void> sendNotificationToHost(String deviceToken) async {
    print("sent it ri8");
    // 1. These come from your JSON file
    // final serviceAccount = {
    //   "type": "service_account",
    //   "project_id": "visitor-management-ba141",
    //   "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQC2u3wb8ppGYvz0\ncQ8kKWZry5VtzErRflEDh3K2Scwt08N4g4OX9Q9WopnRk5DjlL0zstG5m6mHyTTn\napXBJaNjnB/10dHJ+pYuULba09g6NYiWNW4oUMFumSZBlw2/5iMnuCrTAqCHW2Ex\nIrHO5HZ6tyNDw0ZEaClYQ1ZuYUhLxD+LLn+J9YugPcsJ+M7BayOSv7tMnDqlN48e\neVia5sWzprboNM2UByt8mG2hO/fnsTBRa8QtKnE7e9chZ0VGIdQQO2TmV3Hj9gBa\nd706rA5ijxUXUtuerbI6CEXo/wcLmMPofwIzxWgWYHLQeBv5osfp350CPCP9SU0m\nesY641aRAgMBAAECggEAC+xzzAK6heVvgkd+rdpPZFvNCknbx6FBieR/UVKYnT9A\nS0obnra0iO+ZxWbmvARIjJ8lF8KG9K+7Vm6/oFzuH9xqv83bQwh+tGglvRA4lQ3J\nYJx9GGoyll6tyXcLmY4bv6ZWZwf4xR8ARSZG1MxWyH768QZE53GmNwFH2nKEdusW\nYg1aEQDZsN0LN2bdr/kvkaOj8kxBFid8tStW4zkuiUrQHShw3I4xo5TZjaNmBU1F\nwJzj7bfXnwoUp6EN3OGSLMHUmTMnEqW7MhVELY+4DLGVuUkaPhxNopWtEGu8hksb\nLEkCNI3HqL37s/pqyTi+qaRGTSEUkzt/3aoVceGbxQKBgQDYrSNyQLnz0srJtlEf\nlGSJSrEbY1uDUYPVAFluQM+8odqQEgCeEmxgB2lUlq8g6A/OjhDyTdfuz5Oqnpi2\nit/xIKxSVYcMY9yjs3J/LFV0bS+RrLge9xEydeNU+s7EPOf2/C4YHX1ysz6aaT9N\n1MvUHwXyJ3uavhQfKkMACgzUxQKBgQDX5UwpN0df2PqTWfIZUB+Jw8RRvlQu/nZh\nZ/Arzv5hlXSltWP67ThtiS3QCzJSeCmRQu3++k8zn6lbE7QGDsP4iWbpt5r3m8cP\nNeVxxKchds3kHPy7NxnF6FpXFg8zJXl2xYD9eBBDVnj8B3QamIsc0MFqjqSjOpBZ\ns1PUGeCPXQKBgQC359SDH+70xUA7jtQyEph2cv/5uA4vWlujyWUekEIB3/qLd8ww\nXoC/zOqY0kCYlH7+GVTG5E1Xs7WpBm2l2h+TIOFCDLfQS141T5Tp3e42IIpUgZ3R\nInDlPGwUb8BZjTxxRL+21ijo1rxXAOerHudWBnLcgqiFwbmAbjVp7h3P5QKBgBFy\nRiVOgkYMkrM1oYrKHsJTP5obd1IU3hwg+heQMp5QJYz+i4XLhbPUUg9t2DMx4qoK\nbpEcSSoyzMy/WtzidJOxBs/8NlmsDPn9sPzwl1Ds+NZmQUYfvcVwcVx4O+I2NQqU\nC0hwW2AVrNExCQDdMuCxPfAOdt957BBTnYKWVL9BAoGBANipiFXmYYNAvg3RTrfP\n/eXx115RkPXNMJ+vV8E1KxPjfyXXEtMckruWRxCXtrzq/65ZCb6JmgFhSoVTIu0W\n5GV62twmVuGGUvJBW7B659KF6HvbUfAc8MW1KlaMTIP6x/hoA1rkQ2bkbsNPLChx\nmMor0MGUTaw+FlaiVFbzsDjJ\n-----END PRIVATE KEY-----\n",
    //   "client_email": "firebase-adminsdk-fbsvc@visitor-management-ba141.iam.gserviceaccount.com",
    // };


    final String response = await rootBundle.loadString('Assets/Service-Account.json');

    final data = await json.decode(response);
    // 2. This creates the "GAuth" handshake
    final credentials = auth.ServiceAccountCredentials.fromJson(data);
    final client = await auth.clientViaServiceAccount(
        credentials,
        ['https://www.googleapis.com/auth/firebase.messaging']
    );

    // 3. The new V1 URL
    final String url = 'https://fcm.googleapis.com/v1/projects/${data['project_id']}/messages:send';

    try {
      print("try da");
      final response = await client.post(
        Uri.parse(url),
        body: jsonEncode({
          'message': {
            'token': deviceToken,
            'notification': {
              'title': 'New Visitor Request',
              'body': '${nameController.text} is waiting at the door!',
            },
          }
        }),
      );

      if (response.statusCode == 200) {
        print('Sent Successfully!');
      } else {
        print('Failed: ${response.body}');
      }
    } finally {
      client.close();
    }
  }
}

