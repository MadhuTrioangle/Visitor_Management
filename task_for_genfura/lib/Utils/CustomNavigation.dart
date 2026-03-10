import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../common_module/Login.dart';



moveToLoginPage(BuildContext context){
Navigator.push(context, MaterialPageRoute(builder: (context)=>Login()));
}