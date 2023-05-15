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
  void chooseFile(String path){
  Word.setPathOfWzFile(path);
  Navigator.push(context,MaterialPageRoute(builder: (context){
    return const Scaffold(body: Center(child: Text("请重启程序",style: TextStyle(fontSize: 30),),),);
  }));
  }
  @override
  Widget build(BuildContext context) {
   return Scaffold(body: Column(
   mainAxisAlignment: MainAxisAlignment.center,
   crossAxisAlignment: CrossAxisAlignment.center,
   children: [
   Padding(padding: EdgeInsets.all(20), child: ElevatedButton(onPressed: (){
    chooseFile("out_六百个高频词.txt");

    }, child:  Text("600高频词",style: TextStyle(fontSize: 30),))
    ),
    Padding(padding: EdgeInsets.all(20), child: ElevatedButton(onPressed: (){
    chooseFile("out_json_c4_ECP.txt");

    }, child:  Text("考纲词",style: TextStyle(fontSize: 30))
    )
    ),
    Padding(padding: EdgeInsets.all(20), child:ElevatedButton(onPressed: (){
    chooseFile("out_1500wzimwztxt_out.txt");

    }, child:  Text("1500核心词",style: TextStyle(fontSize: 30),))
    ),

    ],)
   );
  }

}