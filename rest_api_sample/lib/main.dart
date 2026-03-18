import 'package:flutter/material.dart';
import 'package:rest_api_sample/AppConstant.dart';
import 'package:rest_api_sample/ProductRepository/ProductRepository.dart';

import 'Crud/CrudPage.dart';
import 'CrudResponse/view/CrudResponseView.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget with WidgetsBindingObserver{
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();

}

class _MyAppState extends State<MyApp> {

  @override
  void initState(){

  }

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title:"Rest Api",
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      home: CrudPage()
    );
  }
}

