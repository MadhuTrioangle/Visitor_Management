import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  int totalVisitors = 0;
  int pending = 0;
  int approved = 0;
  int rejected = 0;
  int todayVisitors = 0;

  @override
  void initState() {
    super.initState();
    fetchAnalytics();
  }

  Future<void> fetchAnalytics() async {
    QuerySnapshot snapshot =
    await _firestore.collection('Visitors').get();

    int t = snapshot.docs.length;
    int p = 0, a = 0, r = 0, today = 0;

    DateTime now = DateTime.now();

    for (var doc in snapshot.docs) {
      var data = doc.data() as Map<String, dynamic>;

      if (data['status'] == "Pending") p++;
      if (data['status'] == "Approved") a++;
      if (data['status'] == "Rejected") r++;

      if (data['entryTime'] != null) {
        DateTime entry =
        (data['entryTime'] as Timestamp).toDate();

        if (entry.year == now.year &&
            entry.month == now.month &&
            entry.day == now.day) {
          today++;
        }
      }
    }

    setState(() {
      totalVisitors = t;
      pending = p;
      approved = a;
      rejected = r;
      todayVisitors = today;
    });
  }

  Widget statCard(String title, int value, Color color) {
    return Card(
      elevation: 4,
      child: Container(
        width: 160,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(title,
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text(value.toString(),
                style: TextStyle(
                    fontSize: 22,
                    color: color,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget pieChart() {
    return PieChart(
      PieChartData(
        sections: [
          PieChartSectionData(
              value: pending.toDouble(),
              color: Colors.orange,
              title: "Pending"),
          PieChartSectionData(
              value: approved.toDouble(),
              color: Colors.green,
              title: "Approved"),
          PieChartSectionData(
              value: rejected.toDouble(),
              color: Colors.red,
              title: "Rejected"),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Admin Analytics Dashboard")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                statCard("Total Visitors", totalVisitors, Colors.blue),
                statCard("Today Visitors", todayVisitors, Colors.purple),
                statCard("Pending", pending, Colors.orange),
                statCard("Approved", approved, Colors.green),
                statCard("Rejected", rejected, Colors.red),
              ],
            ),

            const SizedBox(height: 30),

            const Text(
              "Visitor Status Overview",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            SizedBox(height: 250, child: pieChart()),
          ],
        ),
      ),
    );
  }
}