import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReportsScreen extends StatefulWidget {
  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String selectedReport = "Daily";

  // ================= DATE CALCULATIONS =================

  DateTime getStartOfDay() {
    final now = DateTime.now();
    print("nowday$now");
    return DateTime(now.year, now.month, now.day);
  }

  DateTime getStartOfWeek() {
    final now = DateTime.now();
    print("now$now");
    return now.subtract(Duration(days: now.weekday - 1));
  }

  DateTime getStartOfMonth() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, 1);
  }

  // ================= GET REPORT STREAM =================

  Stream<QuerySnapshot> getReportStream() {
    DateTime startDate;

    if (selectedReport == "Weekly") {
      startDate = getStartOfWeek();
    } else if (selectedReport == "Monthly") {
      startDate = getStartOfMonth();
    } else {
      startDate = getStartOfDay();
    }

    return _firestore
        .collection('Visitors')
        .where('EntryTime', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
        .orderBy('EntryTime', descending: true)
        .snapshots();
  }

  // ================= UI =================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Visitor Reports"),
        centerTitle: true,
      ),

      body: Column(
        children: [

          SizedBox(height: 15),

          // 🔽 Dropdown for report type
          DropdownButton<String>(
            value: selectedReport,
            items: ["Daily", "Weekly", "Monthly"]
                .map((e) => DropdownMenuItem(
              value: e,
              child: Text(e),
            ))
                .toList(),
            onChanged: (value) {
              setState(() {
                selectedReport = value!;
              });
            },
          ),

          SizedBox(height: 10),

          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: getReportStream(),
              builder: (context, snapshot) {

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text("No Visitors Found"));
                }

                var visitors = snapshot.data!.docs;

                return Column(
                  children: [

                    // 🔢 Total Count
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        "Total Visitors: ${visitors.length}",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),

                    Expanded(
                      child: ListView.builder(
                        itemCount: visitors.length,
                        itemBuilder: (context, index) {

                          var data = visitors[index];

                          Timestamp? entryTimestamp = data["EntryTime"];
                          DateTime? entryDate =
                          entryTimestamp?.toDate();

                          return Card(
                            margin: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: ListTile(
                              title: Text(data["name"] ?? ""),
                              subtitle: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text("Mobile: ${data["mobileNumber"] ?? ""}"),
                                  Text("Host: ${data["hostName"] ?? ""}"),
                                  Text("Purpose: ${data["purpose"] ?? ""}"),
                                  Text("Entry: ${entryDate.toString()}"),
                                  Text("Status: ${data["status"] ?? ""}"),
                                ],
                              ),
                              leading: Icon(Icons.person),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}