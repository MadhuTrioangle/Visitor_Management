import 'package:flutter/material.dart';
import 'package:rest_api_sample/AppConstant.dart';

import '../ApiProvider/ApiProvider.dart';
import '../CrudResponse/Model/CrudResponseModel.dart';

class ProductRepository{

read(){
  Future<List<Product>> response = apiProvider.read();
  return response;
}

readWithConditions(){
  Future<dynamic> response = apiProvider.readWithCondition();
  return response;
}

post(String id ,String name)async{
dynamic response = await apiProvider.post(id ,name);
 ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar( SnackBar(content:Text(response.message),));
  return response;
}

delete(String id)async{
 dynamic response  = await apiProvider.delete(id);
ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(SnackBar(content: Text(response.message),));
}

put(){
  apiProvider.put();
}
}
ProductRepository productRepo = ProductRepository();