import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rest_api_sample/ProductRepository/ProductRepository.dart';

import '../Model/CrudResponseModel.dart';

class CrudResponse extends StatefulWidget{
  String type;

  CrudResponse({super.key,required this.type});

  @override
  State<CrudResponse> createState() => _CrudResponse();
}

class _CrudResponse extends State<CrudResponse>{

    List<Product>? prod ;

   void initState(){

   getData();
     super.initState();
   }


  @override
  Widget build(BuildContext context){
    return Scaffold(

      appBar: AppBar(title: Text("Read Rey"),),
      body: ListView.builder(
        itemCount: prod?.length,
          itemBuilder: (context,index){
        return ListTile(title: Text(prod?[index].id.toString()??"45"),
        subtitle: Text(prod?[index].name??"phone"),);
      }),
      floatingActionButton: IconButton(icon:Icon(Icons.add), onPressed: () {
        showInputDialog();
      },
      color: Colors.blue,tooltip: "POST",),

    );

  }

  Future<void> getData() async {
    if( widget.type =="Read") prod = await productRepo.read();
    else prod = await productRepo.readWithConditions();
    setState(() {
    });
  }

  showInputDialog(){

     TextEditingController id = TextEditingController();
     TextEditingController name = TextEditingController();
     showDialog(context: context, builder: (context){
return AlertDialog(
  title:Text("POSTING"),
  content: Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("ID:",style:TextStyle(fontWeight: FontWeight.bold,)),
      SizedBox(height: 2,),
      TextField(
        controller: id,
        decoration: InputDecoration(labelText: "ID"),
      ),
      SizedBox(height: 30,),
      Text("NAME",style: TextStyle(fontWeight: FontWeight.bold),),
      SizedBox(height: 2,),
      TextFormField(
        controller: name,
        decoration: InputDecoration(labelText: "Name"),

      ),
    SizedBox(height: 10,),
      ElevatedButton(onPressed: (){
      productRepo.post(id.text,name.text);
      Navigator.pop(context);
      }
      , child: Text("submit"))
    ],
  ),
);
     });

}}