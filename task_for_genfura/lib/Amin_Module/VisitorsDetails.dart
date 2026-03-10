import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VisitorsScreen extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("All Visitors")),

      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('Visitors').snapshots(),
        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No Visitors Found"));
          }

          var visitors = snapshot.data!.docs;

          return ListView.builder(
            itemCount: visitors.length,
            itemBuilder: (context, index) {
              var visitor = visitors[index];

              return Card(
                margin: EdgeInsets.all(10),
                child: ListTile(
                  title: Text(visitor["name"] ?? "No Name"),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Mobile: ${visitor["mobileNumber"] ?? ""}"),
                      Text("Host: ${visitor["hostName"] ?? ""}"),
                      Text("Purpose: ${visitor["purpose"] ?? ""}"),
                      Text("Entry: ${visitor["entryTime"] ?? ""}"),
                      Text("Exit: ${visitor["exitTime"] ?? ""}"),
                      Text("Status: ${visitor["status"] ?? ""}"),
                    ],
                  ),
                  trailing: Icon(Icons.person),
                ),
              );
            },
          );
        },
      ),
    );
  }
}