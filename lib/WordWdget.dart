import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart' ;
import 'package:auto_size_text/auto_size_text.dart';
import  'package:flutter/services.dart';
import 'package:fsfsfsf/myDropdownButton.dart';
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
  bool _reviewPattern=true;

  String encodeState(){
    Map<String,dynamic> stateMap={"msupOnReset":msupOnReset,
      "_volumeForNextPage":_volumeForNextPage,
      "_showRemainWzCnt":_showRemainWzCnt,
      "_reviewPattern":_reviewPattern,
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
     if (mp.containsKey("_showRemainWzCnt"))_showRemainWzCnt=mp["_showRemainWzCnt"];
     if(mp.containsKey("_reviewPattern"))_reviewPattern=mp["_reviewPattern"];
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
  bool _showRemainWzCnt=true;


  //当前显示的单词在MyModel.displayList的索引
  int curIndexOfWz=0;
  @override
  Widget build(BuildContext context) {
     return   _builderOfPage.builder(context);
  }
  late Builder _builderOfPage;

  void entrySettingPage() {
    PerfectVolumeControl.getVolume().then((value) => _oldVolume=value);
    card_onset=true;
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
    if(wzs.length>1) {
      wzs.removeAt(curIndexOfWz);
    }
    if(curIndexOfWz>=wzs.length) {
      curIndexOfWz=0;
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
            children: [const Text("重置的时候拆分意思"), Switch(value: divide, onChanged: (v){
              setState(() {
                divide=v!;
              });

              saveStateToFile();
            })],),
          Row(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
            children: [const Text("优先显示释义"), Switch(value: meanFirst, onChanged: (v){
              setState(() {
                meanFirst=v!;
              });
              saveStateToFile();
            })],),
          Row(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
            children: [const Text("正面")
              ,MyDropdownButton(value: frontpage, items: cardTypes.entries.map<DropdownMenuItem<String>>((e){
                return DropdownMenuItem<String>(
                  value:  e.key,
                  child: Text(e.key),
                );
              }).toList(), onchange: (val){
                frontpage=val;
              })],),
          Row(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
            children: [const Text("复习模式"), Switch(value: _reviewPattern, onChanged: (v){
              setState(() {
                _reviewPattern=v;
                actionReset();
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
            children: [const Text("显示剩余卡片数"), Switch(value: _showRemainWzCnt, onChanged: (v){
              setState(() {
                _showRemainWzCnt=v!;
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


  void actionReset()  {
      if(_reviewPattern){
        MyModel.flush(p:0,o:MyModel.pos);
      }
      else {
        MyModel.flush();
      }

      if(divide)MyModel.divideDisplayList();
      if(msupOnReset){
         messUp();
      }
      card_onset=true;
  }

  void nextWordsGroup() {
     setState(() {
      MyModel.next();
      card_onset=true;
    });
  }
  void nextWz(){
    curIndexOfWz=(curIndexOfWz+1)%wzs.length;
  }

  void messUp() {
       var sd=Random(DateTime.now().millisecondsSinceEpoch);
       for(int i=0;i<100;++i){
         MyModel.displayList.shuffle(sd);
       }
      card_onset=true;
      curIndexOfWz=0;
  }
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
        PerfectVolumeControl.hideUI=true;
        // print("the volum ==$volume");
        PerfectVolumeControl.setVolume(_oldVolume);
      }

    });
    iniPatterns();
    iniCardTypes();
    showFrontPage();
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

   int curPattern=0;
  List<List<Builder>> patterns=[];
  List<void  Function()> _roll=[];
  List<void  Function()> _washFunc=[];

  void washcard(){
    _washFunc[curPattern]();
  }
  void rollcard(){
    _roll[curPattern]();
  }
  int _indexOfRoll=0;
  Map<String,Builder> cardTypes={};
  void iniCardTypes(){
    cardTypes={"英文":Builder(builder: (context){
      return buildEnglishPage(wzs[curIndexOfWz].eng, context);
    })
      ,"中文释义":Builder(builder: (context){
        return  buildChinesePage(wzs[curIndexOfWz],  context);
      })};
  }
  String frontpage="英文";
  String backPage="中文释义";
  void showFrontPage( ){
    showPage(Builder(builder: (context){
       return GestureDetector(child:cardTypes[frontpage]?.build(context),
         onVerticalDragEnd: (details){
        nextWz();
        showFrontPage();
      },onHorizontalDragEnd: (details){
         showBackPage();
      },onLongPress: (){
           alreadMastered();
           showFrontPage();
         }
         ,
       );
    }));
  }
  void showBackPage(){
    showPage(Builder(builder: (context){
      return GestureDetector(child: cardTypes[backPage]?.build(context)
        ,onVerticalDragEnd: (details){
         nextWz();
         showFrontPage();
      },onHorizontalDragEnd: (details){
        showFrontPage();
        }
      ,onLongPress: (){
        alreadMastered();
        showFrontPage();
        },);
    }));
  }
  void iniPatterns(){
    patterns.add([Builder(builder: (context){
      return buildEnglishPage(wzs[curIndexOfWz].eng, context);
    }),Builder(builder: (context){
      return  buildChinesePage(wzs[curIndexOfWz],  context);
    }), ]);
    _roll.add(() {_indexOfRoll=(_indexOfRoll+1)%patterns[curPattern].length; });
    _washFunc.add(() { _indexOfRoll=0;});
  }
  bool wonset=false;
  bool meanFirst=false;
  bool _ListenPatternValue=false;
  List<MyModel> get wzs {return MyModel.displayList;}
  Widget buildChinesePage(MyModel w,BuildContext context) {
    var content=Column(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center
          ,children: [
            AutoSizeText(w.eng , maxLines:1,presetFontSizes: const [ 100,80,60,50,25,16,12],),
            AutoSizeText(w.phonics,maxLines:1,presetFontSizes: const [25,16,12]),
            AutoSizeText(w.mean[0],maxLines:1,presetFontSizes: const [
              180,170,160,150,140,
              130,120,110,100,90,80,70,60,50,40,25,16,12]),

          ],);
    var scf=Scaffold(
      drawer: buidSettingPage(),
      body: content,);
    return scf;
  }
  void showPage(Builder builder){
    setState(() {
       _builderOfPage=builder;
    });
  }

  void update(){
    showPage(patterns[curPattern][_indexOfRoll]);
  }

  Widget buildEnglishPage(String eng,BuildContext context) {
     var content= Center(
       child: AutoSizeText(eng ,
         maxLines:1,presetFontSizes: const [
           180,170,160,150,140,130,120,110,100,80,60,50,25,18,12],),
       );
     var scfd= Scaffold(body: content,);
     return  scfd;
  }

  void commonHorizontalDragAction() {
    rollcard();
    update();
  }

  void commonVerticalDragAction() {
      nextWz();
    washcard();
    showPage(patterns[curPattern][0]);
  }

  ElevatedButton buildAudioPage({String tag=""}) {
    return ElevatedButton(
              onPressed: (){
                playAudio();
              }, child:   AutoSizeText( "play $tag",
            maxLines:1,presetFontSizes: const [
              180,170,160,150,140,130,120,110,100,80,60,50,25,18,12],)
          );
  }

}