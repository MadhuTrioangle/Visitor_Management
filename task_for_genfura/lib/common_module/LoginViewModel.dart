import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:task_for_genfura/Host_Module/HostDashboard.dart';
import 'package:task_for_genfura/Utils/AppConstant.dart';
import 'package:task_for_genfura/Security_Module/Register_View.dart';

import '../Amin_Module/AdminDashboard.dart';
import '../Security_Module/SecurityDashboard.dart';

class LoginViewModel extends ChangeNotifier{
  TextEditingController emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;

  Future<void> login() async {
    // setState(() => isLoading = true);
    try {
      // 1. Authenticate with Firebase Auth
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());


      User? user = userCredential.user;

      if (user != null) {
        await saveFcmToken(user.uid);}

      // 2. Fetch User Role from Firestore
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(userCredential.user!.uid)
          .get();

      if (userDoc.exists) {


         if( userDoc['role'] == 'Security'){

        //SUCCESS: Navigate to Security Home
        Navigator.pushReplacement(
          NavigationService.navigatorKey.currentContext!,
          MaterialPageRoute(builder: (context) => SecurityDashboardScreen()),
        );}
         else if(userDoc['role'] == 'Admin'){
           Navigator.pushReplacement(
             NavigationService.navigatorKey.currentContext!,
             MaterialPageRoute(builder: (context) => DashboardScreen()),
           );
         }
         else if(userDoc['role'] == 'Host'){
           Navigator.pushReplacement(
             NavigationService.navigatorKey.currentContext!,
             MaterialPageRoute(builder: (context) => HostDashboard()),
           );
         }
      } else {
        print("Printing else");
        // FAILURE: Wrong Role
        await FirebaseAuth.instance.signOut();
       // _showError("Access Denied: You are not registered as a Security Guard.");
      }
    } on FirebaseAuthException catch (e) {
      print("Printing exception");
    //  _showError(e.message ?? "Login Failed");
    } finally {
      print("Printing finally");
    //  setState(() => _isLoading = false);
    }
  }

  // void _showError(String message) {
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(content: Text(message), backgroundColor: Colors.red),
  //   );
  // }

  Future<void> saveFcmToken(String uid) async {

    // Request permission (important for iOS & Android 13+)
    await FirebaseMessaging.instance.requestPermission();

    // Get token
    String? token = await FirebaseMessaging.instance.getToken();

    print("FCM Token: $token");

    if (token != null) {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(uid)
          .update({
        "fcmToken": token,
      });
    }
  }

}