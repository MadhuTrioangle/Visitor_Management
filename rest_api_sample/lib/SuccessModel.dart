import 'dart:convert';

SuccessModel fromPostRawJson(String str) => SuccessModel.fromJson(json.decode(str));

class SuccessModel{
  String message;
  SuccessModel({required this.message});

  factory SuccessModel.fromJson(Map<String,dynamic> json)=>SuccessModel(message:json["message"]);

}