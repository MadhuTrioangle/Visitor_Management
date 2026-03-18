import 'dart:convert';

import 'package:http/http.dart';
import 'package:rest_api_sample/CrudResponse/Model/CrudResponseModel.dart';

import '../HttpService/HttpService.dart';
import 'package:http/http.dart' as http;

import '../SuccessModel.dart';

class ApiProvider {
  //Mutationwithparam,withoutparam,
  Future<List<Product>> read() async {
    //read with param no becoz mention
    Response response = await http.get(Uri.parse(httpServe.baseUrl));
    Response finalResponse = await handleResponse(response);
    return fromRawJson(finalResponse.body);
  }

  readWithCondition() async {
    Response response = await http.get(
        Uri.parse(httpServe.baseUrl + "?id=3&id=5&id=10"));
    Response finalResponse = await handleResponse(response);
    return fromRawJson(finalResponse.body);
  }

  Future<SuccessModel> post(String id, String name) async {
    Response response = await http.post(Uri.parse(httpServe.baseUrl),
        headers: {
          "Content-Type": "application/json"
        },
        body: json.encode({
          "id": id,
          "name": name,
          "data": {"color": "black", "capacity": "Love u"
          }
        })
    );
    print(response.body);
    print(response.statusCode);
    Response finalResponse = await handleResponse(response);
    return fromPostRawJson('{"message":"Successfully Added"}');
  }

  postWithoutParam() {

  }

  delete(String id)async {
  Response response  = await http.delete(Uri.parse(httpServe.baseUrl+"/$id"));
  print(response.body);
  print(response.statusCode);
Response finalRespo = handleResponse(response);

return fromPostRawJson('{"message":"Successfully Deleted"}');

  }

  put()async {
Response response = await http.put(Uri.parse(httpServe.baseUrl+"/1"),
headers: {
  "Content-Type":"application/json"
},
body: json.encode({
  "name": "Vijay"
})
);
print(response.statusCode);
print(response.body);

  }

  patch() {

  }

  handleResponse(Response response) {
    switch (response.statusCode) {
      case 200:
        print(response.body.runtimeType);
        print(response.body);
        return response;
      case 400:
        break;
      default:
        throw Exception("Failed to Load Data");
    }
  }
}

ApiProvider apiProvider = ApiProvider();
