import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' ;
import 'package:auto_size_text/auto_size_text.dart';
import  'package:flutter/services.dart';
import 'MyModel.dart';
import 'main.dart';
class WordWdget extends StatefulWidget{
  String v;
  WordWdget({super.key, this.v="WORD"});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return WordWdgetState();
  }


}
class WordWdgetState extends State<WordWdget>{
  bool msupOnReset=true;
  bool card_onset=false;
  List<Widget> cards= [ ];
  @override
  Widget build(BuildContext context) {
    var tc=<Widget>[buidCarSetPage()];
    tc.addAll(cards);
    tc.add(const Text("尽头"));
    var contenWedget=GestureDetector(
      child: PageView(scrollDirection: Axis.vertical, controller: carControl,onPageChanged:(int v){
        if(!card_onset){
          if(v==0) {
            carControl.jumpToPage(tc.length-2);
          } else if(v==tc.length-1) {
            carControl.jumpToPage(1);
          }
        }
        else {
          card_onset=false;
        }




      }, children: tc),
    );
    return  Scaffold(
      body:contenWedget ,
    );


  }

  void entrySettingPage() {
    card_onset=true;
    carControl.jumpToPage(0);
  }

  void nextPage() {
    final int? pg=carControl.page?.round();
    carControl.jumpToPage(pg!+1);
  }

  void rollPage() {
    final int? pg=wControl.page?.round();
    wControl.jumpToPage(pg!+1);
  }

  void alreadMastered() {
    int pgn=1;
    final page = carControl.page;
    if(page!=null){
      pgn=page.toInt() ;
    }
    int pgc=pgn-1;
    if(cards.length>1){
      setState(() {
        cards.removeAt(pgc);
        if(pgn==cards.length+1){
          pgc=0;
        }
        this.card_onset=true;
        wControl.jumpToPage(1);
        carControl.jumpToPage(pgc+1);
      });
    }
  }
  FocusNode f=FocusNode();
  TextEditingController posCtl=TextEditingController();
  TextEditingController ofstCtl=TextEditingController();
  static bool divide=false;
  Widget buidCarSetPage() {
    posCtl.text=MyModel.pos.toString();
    ofstCtl.text=MyModel.ofst.toString();
    return ListView(
        children: [
          Padding(padding: EdgeInsets.only(bottom: 10.0,top: 20),child: ElevatedButton( onPressed: (){
            setState(() {
              updateCards();
              if(msupOnReset){
                cards.shuffle();
                cards.shuffle();
                cards.shuffle();
              }
              card_onset=true;
              carControl.jumpToPage(1);
            });},
              child:const AutoSizeText("重置",presetFontSizes: [50,100,90,80,70,60,50,20,16,10])), ),
          Padding(padding: EdgeInsets.only(bottom: 10.0),child: ElevatedButton( onPressed: (){
            setState(() {
              cards.shuffle();
              cards.shuffle();
              cards.shuffle();
              card_onset=true;
              carControl.jumpToPage(1);
            });
          },
              child:const AutoSizeText("打乱",presetFontSizes: [50,100,90,80,70,60,50,20,16,10])), ),
          ElevatedButton(onPressed: (){
            setState(() {
              MyModel.next();
              updateCards();
              card_onset=true;
              carControl.jumpToPage(1);
            });

          }, child:const AutoSizeText("下一组",presetFontSizes: [50,100,90,80,70,60,50,20,16,10],),),
          Row(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
            children: [const Text("重置的时候打乱顺序"), Switch(value: msupOnReset, onChanged: (v){
              setState(() {
                msupOnReset=v!;
              });
            })],),
          Row(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
            children: [const Text("重置的时候拆分意思"), Switch(value: divide, onChanged: (v){
              setState(() {
                divide=v!;
              });
            })],),
          Row(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
            children: [const Text("优先显示中文释义"), Switch(value: meanFirst, onChanged: (v){
              setState(() {
                meanFirst=v!;
                updateCards();
              });
            })],),
          TextField(
            onChanged: (String v){
              int? tn=int.tryParse(v);
              if(tn!=null){
                int b=MyModel.ofst+tn;
                if(b>=0&&b<MyModel.allOfWord.length&&tn>=0&&tn<MyModel.allOfWord.length&&b!=tn){
                  MyModel.pos=tn;
                  MyModel.flush();
                }
              }

            },
            keyboardType: TextInputType.number,
            maxLength: 4,
            textAlign: TextAlign.center,
            autofocus:false,
            controller:posCtl ,
            decoration: const InputDecoration(
                labelText: "指针",
                hintText: "第一个单词或最后一个单词的位置"
            ),
          ),
          TextField(
            onChanged: (String v){
              int? tn=int.tryParse(v);
              if(tn!=null){
                int testPos=tn+MyModel.pos;
                if(testPos>=0&&testPos<MyModel.allOfWord.length){
                  MyModel.ofst=tn;
                  MyModel.flush();
                }
              }
            },
            maxLength: 4,
            textAlign: TextAlign.center,
            controller: ofstCtl,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: "偏移量",
              hintText: "可正可负,绝对值是单词的数量",

            ),

          ),

        ]);
  }
  PageController carControl=PageController(initialPage: 1);
  PageController wControl=PageController(initialPage: 1);
  @override
  void initState() {
    super.initState();
    MyModel.flush();
    updateCards();
  }
  void updateCards(){
    cards=[];
    for (var element in MyModel.displayList) {
      cards.addAll(makePageViews(element));
    }
  }
  bool wonset=false;
  bool meanFirst=false;

  List<Widget>   makePageViews(MyModel w){
    String mean=w.mean[0];
    List<Widget> ans=[];
    var mns=<String>[];
    if(divide){
      var listA=mean.split(RegExp(";|；"));
      listA=listA.map((e) => e.trim()).toList();
      for(var v in listA){
        mns.addAll(v.split(RegExp("( )+")));
      }
    }
    else{
      mns.add(mean);
    }

    for(var s in mns){
      s=s.trim();
      if(s.isNotEmpty){
        var ctent=<Widget>[
          const Center(child:Text("开始")),
          Center(child: AutoSizeText(w.eng ,
            maxLines:1,presetFontSizes: const [
              180,170,160,150,140,130,120,110,100,80,60,50,25,18,12],),
          ),
          Column(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center
            ,children: [
              AutoSizeText(w.eng , maxLines:1,presetFontSizes: const [ 100,80,60,50,25,16,12],),
              AutoSizeText(w.phonics,maxLines:1,presetFontSizes: const [25,16,12]),
              AutoSizeText(s,maxLines:1,presetFontSizes: const [180,160,140,120,100,80,60,50,25,16,12]),

            ],),
          const Center(child: Text("结束"),)
        ];
        if(meanFirst){
          var t=ctent[1];
          ctent[1]=ctent[2];
          ctent[2]=t;
        }
        ans.add( GestureDetector(onDoubleTap:(){
          entrySettingPage();
        },onLongPress: (){alreadMastered();},
            onTap: (){rollPage();},
            child: PageView(
                scrollDirection: Axis.horizontal,
                controller: this.wControl,
                onPageChanged: (int index){
                  if(!wonset){
                    if(index==0) {
                      wControl.jumpToPage(2);
                    } else if(index==3) {
                      wControl.jumpToPage(1);
                    }
                  }
                  else {
                    wonset=false;
                  }
                },
                children: ctent
            )));
      }

    }
    return ans;




  }

}