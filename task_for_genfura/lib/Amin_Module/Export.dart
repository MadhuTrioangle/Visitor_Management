import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
// import 'package:excel/excel.dart';
// import 'package:path_provider/path_provider.dart';

class AdminExportScreen extends StatelessWidget {
  const AdminExportScreen({super.key});

  /// 🔹 Fetch all visitors
  Future<List<QueryDocumentSnapshot>> fetchVisitors() async {
    QuerySnapshot snapshot =
    await FirebaseFirestore.instance.collection('Visitors').get();
    return snapshot.docs;
  }

  /// 🔹 Export to PDF
  Future<void> exportToPDF(BuildContext context) async {
    final visitors = await fetchVisitors();

    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Table.fromTextArray(
            headers: [
              "Name",
              "Mobile",
              "Purpose",
              "Host",
              "Entry",
              "Exit",
              "Status"
            ],
            data: visitors.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              return [
                data['name'] ?? '',
                data['mobileNumber'] ?? '',
                data['purpose'] ?? '',
                data['hostName'] ?? '',
                data['entryTime']?.toString() ?? '',
                data['exitTime']?.toString() ?? '',
                data['status'] ?? '',
              ];
            }).toList(),
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
    );
  }

//  / 🔹 Export to Excel
//  Future<void> exportToExcel() async {
//    final visitors = await fetchVisitors();
//
//    var excel = Excel.createExcel();
//    Sheet sheet = excel['Visitors'];
//
//    sheet.appendRow([
//      "Name",
//      "Mobile",
//      "Purpose",
//      "Host",
//      "Entry",
//      "Exit",
//      "Status"
//    ]);
//
//    for (var doc in visitors) {
//      final data = doc.data() as Map<String, dynamic>;
//
//      sheet.appendRow([
//        data['name'] ?? '',
//        data['mobileNumber'] ?? '',
//        data['purpose'] ?? '',
//        data['hostName'] ?? '',
//        data['entryTime']?.toString() ?? '',
//        data['exitTime']?.toString() ?? '',
//        data['status'] ?? '',
//      ]);
//    }
//
//    Directory directory = await getApplicationDocumentsDirectory();
//    String filePath = "${directory.path}/visitors.xlsx";
//
//    File(filePath)
//      ..createSync(recursive: true)
//      ..writeAsBytesSync(excel.encode()!);
//
//    print("Excel saved at $filePath");
//  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Export Visitor Data")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            ElevatedButton(
              onPressed: () => exportToPDF(context),
              child: const Text("Export as PDF"),
            ),

            const SizedBox(height: 20),

            // ElevatedButton(
            //   onPressed: exportToExcel,
            //   child: const Text("Export as Excel"),
            // ),
          ],
        ),
      ),
    );
  }
}