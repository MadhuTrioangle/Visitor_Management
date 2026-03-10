import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import '../Utils/AppDrawer.dart';

class DashboardScreen extends StatefulWidget {
  @override
  State<DashboardScreen> createState() => Dashboard();
}

class Dashboard extends State<DashboardScreen>{

  @override
  void initState(){
    super.initState();

    // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    //   print("Foreground message received");
    //
    //   if (message.notification != null) {
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       SnackBar(
    //         content: Text(
    //           "${message.notification!.title} - ${message.notification!.body}",
    //         ),
    //       ),
    //     );
    //   }
    // });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Dashboard")),
      drawer: AppDrawer(role:"Admin"),
      body: Center(
        child: Text("Welcome to Admin Dashboard",
            style: TextStyle(fontSize: 18)),
      ),
    );
  }
}