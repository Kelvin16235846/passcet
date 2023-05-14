import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fsfsfsf/Word.dart';

class ChooseWzFile extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
     return ChooseWzFileState();
  }

}
class ChooseWzFileState extends State<ChooseWzFile>{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '过四级!!!',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue)
      ),
      home: Scaffold(body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
           ElevatedButton(onPressed: (){
             Word.setPathOfWzFile("out_六百个高频词.txt");

           }, child:  Text("600高频词",style: TextStyle(fontSize: 30),)),SizedBox(width: 10,height: 10,),
        ElevatedButton(onPressed: (){
          Word.setPathOfWzFile("out_json_c4_ECP.txt");

        }, child:  Text("考纲词",style: TextStyle(fontSize: 30))),SizedBox(width: 10,height: 10,),
        ElevatedButton(onPressed: (){
          Word.setPathOfWzFile("out_1500wzimwztxt_out.txt");

        }, child:  Text("1500核心词",style: TextStyle(fontSize: 30),)),SizedBox(width: 10,height: 10,),
      ],),),
    );
  }

}