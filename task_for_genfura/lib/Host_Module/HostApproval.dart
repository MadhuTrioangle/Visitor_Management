import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HostApprovalScreen extends StatefulWidget {
  const HostApprovalScreen({super.key});

  @override
  State<HostApprovalScreen> createState() => _HostApprovalScreenState();
}

class _HostApprovalScreenState extends State<HostApprovalScreen> {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final User? currentUser = FirebaseAuth.instance.currentUser;

  /// 🔹 Approve Visitor
  Future<void> approveVisitor(String visitorId) async {
    await _firestore.collection('Visitors').doc(visitorId).update({
      "status": "Approved",
      "entryTime": FieldValue.serverTimestamp(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Visitor Approved")),
    );
  }

  /// 🔹 Reject Visitor
  Future<void> rejectVisitor(String visitorId) async {
    await _firestore.collection('Visitors').doc(visitorId).update({
      "status": "Rejected",
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Visitor Rejected")),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text("Visitor Approval Requests")),

      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('Visitors')
            .where('status', isEqualTo: "Pending")
            .snapshots(),

        builder: (context, snapshot) {

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          var visitors = snapshot.data!.docs;

          if (visitors.isEmpty) {
            return const Center(child: Text("No Pending Requests"));
          }

          return ListView.builder(
            itemCount: visitors.length,
            itemBuilder: (context, index) {

              var visitor = visitors[index];
              var data = visitor.data() as Map<String, dynamic>;

              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  title: Text(data['name'] ?? ''),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Mobile: ${data['mobileNumber']}"),
                      Text("Purpose: ${data['purpose']}"),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      IconButton(
                        icon: const Icon(Icons.check, color: Colors.green),
                        onPressed: () => approveVisitor(visitor.id),
                      ),

                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.red),
                        onPressed: () => rejectVisitor(visitor.id),
                      ),
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