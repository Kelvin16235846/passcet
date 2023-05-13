import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Word.dart';

class WordListPage extends StatefulWidget {
  const WordListPage({super.key,required this.wzs});

  @override
  State<StatefulWidget> createState() {
   return WordListPageState();
  }
  final List<Word> wzs;
}
class WordListPageState extends State<WordListPage>{
  bool _showMean=false;
  List<bool> _listShowMeans=[];
  @override
  Widget build(BuildContext context) {
     return  Scaffold(
         appBar: AppBar(title: Row(crossAxisAlignment: CrossAxisAlignment.center
           ,children: [
          ElevatedButton(onPressed: (){
             setState(() {
               wzs.shuffle( Random());
             });

           }, child: Text("打乱")
           )
            ,Padding(padding:EdgeInsets.only(left: 5))
             ,Row(children: [
               const Text("释义")
             ,  Checkbox(value: _showMean, onChanged: (val){
               setState(() {
                 _showMean=val!;
                 resetListShowMeans();
               });
             }
             )
             ],
             )


             ,Padding(padding:EdgeInsets.only(left: 5))
             ,ElevatedButton(onPressed: (){
               setState(() {
                  Word.flush();
                  resetListShowMeans();
               });
             }, child: const Text("重置")
             )
         ],
         )
         ),
         body:Scrollbar(
           thumbVisibility:true,
           trackVisibility: true,
       child:  ListView.builder(itemCount: wzs.length,
         itemBuilder: (BuildContext context, int index) {
           var content= Column(
             mainAxisAlignment: MainAxisAlignment.center,
             crossAxisAlignment: CrossAxisAlignment.center,
             children: [Text(wzs[index].eng
           ,style: TextStyle(fontSize: 30),)
             ,Text(_listShowMeans[index]?wzs[index].mean[0]:""
                 ,style: TextStyle(fontSize: 30)),
           ],);
           Widget gest= GestureDetector(
             child:ElevatedButton(onPressed: () {
               setState(() {
                  _listShowMeans[index]=!_listShowMeans[index];
               });
             },
               child:content ,)
             ,onLongPress: (){
               if(wzs.length>1){
                 setState(() {
                   wzs.removeAt(index);
                   _listShowMeans.removeAt(index);
                 });
               }
           },);
           return Padding(padding:EdgeInsets.only(left: 30,right: 30,top: 15)
             ,child: gest,
           );
         }
         ,),
     )
     );
  }
  List<Word> get wzs{
    return widget.wzs;
  }
  @override
  void initState() {
    // TODO: implement initState
    resetListShowMeans();
    super.initState();
  }
  void resetListShowMeans(){
    _listShowMeans.clear();
    _listShowMeans=List.generate(wzs.length, (index) => _showMean);
  }
}