import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TodayVisitorsList extends StatelessWidget {
  const TodayVisitorsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Visitors"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Visitors')
            .snapshots(),
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

              return ListTile(
                // leading: CircleAvatar(
                //   backgroundImage: NetworkImage(doc['photoUrl']),
                // ),
                title: Text(doc['name']),
                subtitle: Text("Status: ${doc['status']}"),
                trailing: doc['status'] == 'Approved'
                    ? IconButton(
                  icon: const Icon(Icons.exit_to_app, color: Colors.red),
                  onPressed: () {
                    // doc.reference.update({
                    //   'exitStatus': true,
                    //   'exitTime': FieldValue.serverTimestamp(),
                    // });
                  },
                )
                    : const Icon(Icons.hourglass_empty),
              );
            },
          );
        },
      ),
    );
  }
}