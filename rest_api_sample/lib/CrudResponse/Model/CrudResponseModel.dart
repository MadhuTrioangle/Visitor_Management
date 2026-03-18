import 'dart:convert';

List<Product> fromRawJson(String str) =>
    List<Product>.from(json.decode(str).map((item) => Product.fromJson(item)));

String processedJson(List<Product> data) =>
    json.encode(List<dynamic>.from(data.map((e) => e.toJson())));

class Product {
  String? id;
  String? name;
  ProductModel? productModel;

  Product({this.id, this.name, this.productModel});

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        name: json["name"],
        productModel:ProductModel.fromJson(json["data"]),
      );

  Map<String,dynamic> toJson() =>
      {"id": id, "name": name, "data": productModel?.toJson()};
}

class ProductModel {
  String? color;
  String? capacity;

  ProductModel({required this.color, required this.capacity});

  factory ProductModel.fromJson(Map<String, dynamic>? json) =>
      ProductModel(color: json?["color"], capacity: json?["capacity"]);

  Map<String, dynamic> toJson() => {"color": color, "capacity": capacity};
}
