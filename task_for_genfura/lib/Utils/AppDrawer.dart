import 'package:flutter/material.dart';
import 'package:task_for_genfura/Security_Module/SecurityDashboard.dart';

import '../Amin_Module/AdminApprovalScreen.dart';
import '../Amin_Module/Analytics.dart';
import '../Amin_Module/Export.dart';
import '../Amin_Module/GuardsScreen.dart';
import '../Amin_Module/Reports.dart';
import '../Amin_Module/VisitorsDetails.dart';
import '../Host_Module/HostApproval.dart';
import '../Host_Module/Visitor_Details.dart';
import '../Host_Module/Visitor_History.dart';
import '../Security_Module/Register_View.dart';
import '../Security_Module/Today_Visitors_List.dart';
import '../Security_Module/VisitorsExit.dart';


class AppDrawer extends StatelessWidget {
  final String role;
  const AppDrawer({required this.role,super.key});
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: role == "Admin"?
      ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text("Admin Panel",
                style: TextStyle(color: Colors.white, fontSize: 22)),
          ),

          ListTile(
            leading: Icon(Icons.security),
            title: Text("Add / Edit / Delete Security Guards"),
            onTap: () => Navigator.push(
                context, MaterialPageRoute(builder: (_) => GuardsScreen())),
          ),

          ListTile(
            leading: Icon(Icons.people),
            title: Text("View All Visitors"),
            onTap: () => Navigator.push(
                context, MaterialPageRoute(builder: (_) => VisitorsScreen())),
          ),

          ListTile(
            leading: Icon(Icons.report),
            title: Text("Generate Reports (Daily / Weekly / Monthly)"),
            onTap: () => Navigator.push(
                context, MaterialPageRoute(builder: (_) => ReportsScreen())),
          ),

          ListTile(
            leading: Icon(Icons.approval),
            title: Text("Approve / Reject Visitor Requests"),
            onTap: () => Navigator.push(
                context, MaterialPageRoute(builder: (_) => AdminApprovalScreen())),
          ),

          ListTile(
            leading: Icon(Icons.file_download),
            title: Text("Export Visitor Data (PDF / Excel)"),
            onTap: () => Navigator.push(
                context, MaterialPageRoute(builder: (_) => AdminExportScreen())),
          ),

          ListTile(
            leading: Icon(Icons.analytics),
            title: Text("View Analytics Dashboard"),
            onTap: () => Navigator.push(
                context, MaterialPageRoute(builder: (_) => AdminDashboard())),
          ),
        ],
      ): role == "Security"?ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text("Security Panel",
                style: TextStyle(color: Colors.white, fontSize: 22)),
          ),

          ListTile(
            leading: Icon(Icons.security),
            title: Text("Register Visitors"),
            onTap: () => Navigator.push(
                context, MaterialPageRoute(builder: (_) => RegisterVisitorScreen())),
          ),

          ListTile(
            leading: Icon(Icons.people),
            title: Text("Mark Visitor Exit"),
            onTap: () => Navigator.push(
                context, MaterialPageRoute(builder: (_) => ApprovedVisitorsScreen())),
          ),


          ListTile(
            leading: Icon(Icons.analytics),
            title: Text("Visitors List"),
            onTap: () => Navigator.push(
                context, MaterialPageRoute(builder: (_) => TodayVisitorsList())),
          ),
        ],
      ):ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text("Host Panel",
                style: TextStyle(color: Colors.white, fontSize: 22)),
          ),

          ListTile(
            leading: Icon(Icons.security),
            title: Text("Approve/Reject Request"),
            onTap: () => Navigator.push(
                context, MaterialPageRoute(builder: (_) => HostApprovalScreen())),
          ),

          ListTile(
            leading: Icon(Icons.people),
            title: Text("Visitor History"),
            onTap: () => Navigator.push(
                context, MaterialPageRoute(builder: (_) => VisitorHistoryPage())),
          ),


          ListTile(
            leading: Icon(Icons.analytics),
            title: Text("Visitors Details"),
            onTap: () => Navigator.push(
                context, MaterialPageRoute(builder: (_) => VisitorDetailsPage())),
          ),
        ],
      )
    );
  }
}