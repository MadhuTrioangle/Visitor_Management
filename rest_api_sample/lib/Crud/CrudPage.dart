import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rest_api_sample/CrudResponse/view/CrudResponseView.dart';

import '../ProductRepository/ProductRepository.dart';

class CrudPage extends StatefulWidget{

  @override
  State<CrudPage> createState() => CrudPageResponse();
}

class CrudPageResponse extends State<CrudPage>{

  void initState(){

  }
  Widget build(BuildContext context){
    return Scaffold(
        appBar: AppBar(title: Center(child: Text("CRUD With Rest API")),backgroundColor: Colors.grey,),
        body:Padding(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10,),
              GestureDetector(
                onTap: (){
                  // productRepo.read();
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> CrudResponse(type: "Read",)));

                },
                child: Text("READ",style: TextStyle(fontWeight: FontWeight.bold,),textAlign: TextAlign.start,),
              ),
              SizedBox(height: 10,),
              GestureDetector(
                onTap: (){
                  // productRepo.read();
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> CrudResponse(type: "ReadWithConditions",)));

                },
                child: Text("ReadWithConditions",style: TextStyle(fontWeight: FontWeight.bold,),textAlign: TextAlign.start,),
              ),
              SizedBox(height: 10,),
              GestureDetector(
                onTap: (){
                },
                child:Text("WRITE",style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.start),
              ),
              SizedBox(height: 10,),
              GestureDetector(
                onTap: (){
                  productRepo.delete("1");

                },
                child: Text("DELETE",style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.start),
              ),
              SizedBox(height: 10,),
              GestureDetector(
                onTap: (){
                  productRepo.put();

                },
                child: Text("PUT",style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.justify),
              ),
              SizedBox(height: 10,),
              GestureDetector(
                onTap: (){

                },
                child: Text("PATCH",style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.start),
              ),
            ],
          ),
        )

    );
  }


}