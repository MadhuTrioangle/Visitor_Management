import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_for_genfura/Utils/AppDrawer.dart';

class HostDashboard extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text("Host Dashboard")),
      drawer: AppDrawer(role: "Host",),
      body: Center(child:Text("Host Dashboard")),
    );
  }


}