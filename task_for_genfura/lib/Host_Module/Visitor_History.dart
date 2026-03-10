import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class VisitorHistoryPage extends StatelessWidget {
  const VisitorHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Visitor History")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Visitors')
            .where('status', isEqualTo: 'Completed')
            .snapshots(),
        builder: (context, snapshot) {

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          var visitors = snapshot.data!.docs;

          return ListView.builder(
            itemCount: visitors.length,
            itemBuilder: (context, index) {

              var doc = visitors[index];

              return ListTile(
                // leading: CircleAvatar(
                //   backgroundImage: NetworkImage(doc['photoUrl']),
                // ),
                title: Text(doc['name']),
                subtitle: Text(doc['purpose']),
                onTap: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (_) => VisitorDetailsPage(doc: doc),
                  //   ),
                  // );
                },
              );
            },
          );
        },
      ),
    );
  }
}