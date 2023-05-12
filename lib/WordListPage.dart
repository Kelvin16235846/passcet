import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'MyModel.dart';

class WordListPage extends StatefulWidget {
  const WordListPage({super.key,required this.wzs});

  @override
  State<StatefulWidget> createState() {
   return WordListPageState();
  }
  final List<MyModel> wzs;
}
class WordListPageState extends State<WordListPage>{
  @override
  Widget build(BuildContext context) {
     return  Scaffold(
         appBar: AppBar(title: Text("总数${wzs.length}") ,actions: [
           ElevatedButton(onPressed: (){
             setState(() {
              wzs.shuffle( Random());
             });

           }, child: Text("打乱"))
         ],),
         body:Scrollbar(
           thumbVisibility:true,
           trackVisibility: true,
       child:  ListView.builder(itemCount: wzs.length,
         itemBuilder: (BuildContext context, int index) {
           var content= Column(children: [Text(wzs[index].eng)
             ,Text(wzs[index].mean[0]),
           ],);
           return GestureDetector(
             child:ElevatedButton(onPressed: () {  },
               child:content ,)
             ,onLongPress: (){
               if(wzs.length>1){
                 setState(() {
                   wzs.removeAt(index);
                 });
               }
           },);
         }
         ,),
     )
     );
  }
  List<MyModel> get wzs{
    return widget.wzs;
  }

}