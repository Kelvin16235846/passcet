import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart' ;
import 'package:auto_size_text/auto_size_text.dart';
import  'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:perfect_volume_control/perfect_volume_control.dart';
import 'MyModel.dart';
import 'package:audioplayers/audioplayers.dart';
class WordWdget extends StatefulWidget{
  String v;
  WordWdget({super.key, this.v="WORD"});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return WordWidgetState();
  }


}
class WordWidgetState extends State<WordWdget> {
  double _oldVolume=0.07;
  bool msupOnReset=true;
  bool card_onset=false;
  final player = AudioPlayer();
  List<Widget> cards= [ ];
  static const    String cfgPath="WordWidgetState.json";

  String encodeState(){
    Map<String,dynamic> stateMap={"msupOnReset":msupOnReset,
      "_volumeForNextPage":_volumeForNextPage,
    "divide":divide,"meanFirst": meanFirst,"_ListenPatternValue":_ListenPatternValue};
    return jsonEncode(stateMap);
  }
  void decodeStateJson(String jsonstr){
    Map<String,dynamic> mp=jsonDecode(jsonstr);
    msupOnReset=mp["msupOnReset"];
    divide=mp["divide"];
    meanFirst=mp["meanFirst"];
    _ListenPatternValue=mp["_ListenPatternValue"];
    _volumeForNextPage=mp["_volumeForNextPage"];
  }
  void saveStateToFile()async{
    Future(()async{
      String dir="${(await  getApplicationDocumentsDirectory()).path}/$cfgPath";
      File f= File(dir);
      RandomAccessFile fl= await f.open(mode: FileMode.write);
      fl.writeStringSync(encodeState());
      fl.closeSync();

    });
  }


  //当前显示的单词在MyModel.displayList的索引
  int curIndexOfWz=0;
  @override
  Widget build(BuildContext context) {
    var tc=<Widget>[buidSettingPage()];
    tc.addAll(cards);
    tc.add(const Text("尽头"));
    var contenWedget=GestureDetector(
      child: PageView(

          scrollDirection: Axis.vertical,
          controller: carControl,onPageChanged:(int v){
        if(!card_onset){
          curIndexOfWz=v-1;
          if(v==0) {
            carControl.jumpToPage(tc.length-2);
            curIndexOfWz=tc.length-2-1;
          } else if(v==tc.length-1) {
            carControl.jumpToPage(1);
            curIndexOfWz=0;
          }
          if(_ListenPatternValue){
            playAudio();
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
    PerfectVolumeControl.getVolume().then((value) => _oldVolume=value);
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
  void playAudio({String eng ="_None_",String type ="0"})async{
    // await player.setSource(AssetSource('wz/mp3file/${eng.trim()}_$type.mp3'));
   // await player.setSource(AssetSource('wz/mp3file/abandon_0.mp3'));
 //  await player.setSourceAsset('wz/mp3file/abandon_0.mp3');
    if(eng=="_None_"){
      eng=MyModel.displayList[curIndexOfWz].eng;
      type="${DateTime.now().microsecondsSinceEpoch%2}";
    }

    await player.stop();
   var a= await rootBundle.load('wz/mp3file/${eng.trim()}_$type.mp3');
   await player.setSourceBytes(a.buffer.asUint8List());
     await player.resume();

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
        MyModel.displayList.removeAt(pgc);
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
  static bool _volumeForNextPage=true;
  Widget buidSettingPage() {
    posCtl.text=MyModel.pos.toString();
    ofstCtl.text=MyModel.ofst.toString();
    return ListView(
        children: [
          Padding(padding: EdgeInsets.only(bottom: 10.0,top: 20),
            child: ElevatedButton( onPressed: (){
            actionReset();
            },
              child:const AutoSizeText("重置",presetFontSizes: [50,100,90,80,70,60,50,20,16,10])), ),
          Padding(padding: EdgeInsets.only(bottom: 10.0),
            child: ElevatedButton( onPressed: (){
            messUp();
          },
              child:const AutoSizeText("打乱",presetFontSizes: [50,100,90,80,70,60,50,20,16,10])), ),
          ElevatedButton(onPressed: (){
            nextWordsGroup();

          }, child:const AutoSizeText("下一组",presetFontSizes: [50,100,90,80,70,60,50,20,16,10],),),
          Row(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
            children: [const Text("重置的时候打乱顺序"), Switch(value: msupOnReset, onChanged: (v){
              setState(() {
                msupOnReset=v!;
              });
              saveStateToFile();
            })],),
          Row(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
            children: [const Text("Listen pattern"), Switch(value: _ListenPatternValue, onChanged: (v){
              setState(() {
                _ListenPatternValue=v;
              });

              saveStateToFile();
            })],),
          Row(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
            children: [const Text("重置的时候拆分意思"), Switch(value: divide, onChanged: (v){
              setState(() {
                divide=v!;
              });

              saveStateToFile();
            })],),
          Row(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
            children: [const Text("优先显示中文释义"), Switch(value: meanFirst, onChanged: (v){
              setState(() {
                meanFirst=v!;
                updateCards();
              });

              saveStateToFile();
            })],),
          Row(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
            children: [const Text("使用音量键翻页"), Switch(value: _volumeForNextPage, onChanged: (v){
              setState(() {
                _volumeForNextPage=v!;
              });

              saveStateToFile();
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

  void actionReset()async {
    setState(() {
      MyModel.flush();
      if(divide)MyModel.divideDisplayList();
      updateCards();
      if(msupOnReset){
         messUp();
      }
      card_onset=true;
      carControl.jumpToPage(1);

    });
  }

  void nextWordsGroup() {
     setState(() {
      MyModel.next();
      updateCards();
      card_onset=true;
      carControl.jumpToPage(1);
    });
  }

  void messUp() {
     setState(() {
      MyModel.displayList.shuffle(Random(DateTime.now().millisecondsSinceEpoch));
      MyModel.displayList.shuffle(Random(DateTime.now().millisecondsSinceEpoch));
      MyModel.displayList.shuffle(Random(DateTime.now().millisecondsSinceEpoch));
      updateCards();
      card_onset=true;
      carControl.jumpToPage(1);
      curIndexOfWz=0;
    });
  }
  PageController carControl=PageController(initialPage: 1);
  PageController wControl=PageController(initialPage: 1);
  @override
  void initState() {
    super.initState();
    inialize();
  }
  void inialize()async{
    await readStateFromFile() ;
     actionReset();
    PerfectVolumeControl.stream.listen((volume) {
      if(_volumeForNextPage){
        nextPage();
        PerfectVolumeControl.hideUI=true;
        // print("the volum ==$volume");
        PerfectVolumeControl.setVolume(_oldVolume);
      }

    });
  }
  Future<void> readStateFromFile()async{
    await Future(()async {
      String dir = "${(await getApplicationDocumentsDirectory())
          .path}/$cfgPath";
      File f = File(dir);
      if (f.existsSync()) {
        var dts = f.readAsStringSync();
        decodeStateJson(dts);
      }
    });

  }
  void updateCards(){
    cards=[];

    for(int i=0;i<MyModel.displayList.length;++i){
      cards.addAll(makePageViews(MyModel.displayList[i],tag: "$i"));
    }

  }
  bool wonset=false;
  bool meanFirst=false;
  bool _ListenPatternValue=false;

  List<Widget>   makePageViews(MyModel w,{String tag="#"}){
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

    for(int i=0;i<mns.length;++i){
      var s=mns[i];
      s=s.trim();
      if(s.isNotEmpty){
        var ctent=<Widget>[
          const Center(child:Text("开始")),
          Column(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center
            ,children: [
              _ListenPatternValue?
              ElevatedButton(
                  onPressed: (){
                    playAudio();
                  }, child:   AutoSizeText( "play $tag${(divide&&mns.length>1)?".$i":""}",
                maxLines:1,presetFontSizes: [
                  180,170,160,150,140,130,120,110,100,80,60,50,25,18,12],)
              )
                  :AutoSizeText(  w.eng ,
                maxLines:1,presetFontSizes: const [
                  180,170,160,150,140,130,120,110,100,80,60,50,25,18,12],),
            ],),
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
        },onLongPress: (){alreadMastered();
          if(_ListenPatternValue) playAudio();},
            onTap: (){
            rollPage();
          },
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
                    if(index==1&&_ListenPatternValue){
                      playAudio();
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