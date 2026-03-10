import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class VisitorDetailsPage extends StatelessWidget {
  const VisitorDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Visitor List"),
      ),

      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection('Visitors')
            .get(),

        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No Visitors Found"));
          }

          var visitors = snapshot.data!.docs;

          return ListView.builder(
            itemCount: visitors.length,
            itemBuilder: (context, index) {

              var doc = visitors[index];
              Timestamp entryTime = doc['entryTime'];

              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  // leading: CircleAvatar(
                  //   backgroundImage: NetworkImage(doc['photoUrl']),
                  // ),

                  title: Text(doc['name']),

                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Purpose: ${doc['purpose']}"),
                      Text("Status: ${doc['status']}"),
                      Text("Entry: ${entryTime.toDate()}"),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}