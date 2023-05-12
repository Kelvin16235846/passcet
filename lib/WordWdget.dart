import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart' ;
import 'package:auto_size_text/auto_size_text.dart';
import  'package:flutter/services.dart';
import 'package:fsfsfsf/WordListPage.dart';
import 'package:fsfsfsf/myDropdownButton.dart';
import 'package:path_provider/path_provider.dart';
import 'package:perfect_volume_control/perfect_volume_control.dart';
import 'Word.dart';
import 'package:audioplayers/audioplayers.dart';
class WordWidget extends StatefulWidget{
  const WordWidget({super.key});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return WordWidgetState();
  }


}
class WordWidgetState extends State<WordWidget> {
  bool msupOnReset=true;
  final player = AudioPlayer();
  static const    String cfgPath="WordWidgetState1.json";
  bool _reviewPattern=true;
  String encodeState(){
    Map<String,dynamic> stateMap={
      "msupOnReset":msupOnReset,
      "_showRemainWzCnt":_showRemainWzCnt,
      "_reviewPattern":_reviewPattern,
      "backPage":backPage,
      "frontpage":frontpage,
      "divide":divide,
      "_playAudioAfterNewCard":_playAudioAfterNewCard,
    };
    return jsonEncode(stateMap);
  }
  void decodeStateJson(String jsonstr){
    Map<String,dynamic> mp=jsonDecode(jsonstr);
    msupOnReset=mp["msupOnReset"];
    divide=mp["divide"];
    if (mp.containsKey("_showRemainWzCnt"))_showRemainWzCnt=mp["_showRemainWzCnt"];
    if(mp.containsKey("_reviewPattern"))_reviewPattern=mp["_reviewPattern"];
    if(mp.containsKey("backPage"))backPage=mp["backPage"];
    if(mp.containsKey("frontpage"))frontpage=mp["frontpage"];
    if(mp.containsKey("_playAudioAfterNewCard"))_playAudioAfterNewCard=mp["_playAudioAfterNewCard"];

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
    var content=_builderOfPage.builder(context);
    Widget scfd=content;
    if(_showRemainWzCnt) {
      scfd= Scaffold(
        body: content
        , floatingActionButton: FloatingActionButton(
        mini: true
        , onPressed: () {},
        child: Text("${wzs.length}"),
      ),
      );
    }
    else {
      scfd= Scaffold(body: content,);
    }
    // Color.fromRGBO(255, 235, 205, 1.0);
    return Container(child: scfd,color: Colors.grey,);
  }
  late Builder _builderOfPage;

  void entrySettingPage() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    showPage(Builder(builder: (context){
      return buildSettingPage();
    }));
  }


  void playAudio({String eng ="_None_",String type ="0"})async{
     if(eng=="_None_"){
      eng=Word.displayList[curIndexOfWz].eng;
      type="${DateTime.now().microsecondsSinceEpoch%2}";
    }

    await player.stop();
    var a= await rootBundle.load('wz/mp3file/${eng.trim()}_$type.mp3');
    await player.setSourceBytes(a.buffer.asUint8List());
    await player.resume();

  }
  void alreadyMastered() {
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
  Widget buildSettingPage() {
    posCtl.text=Word.pos.toString();
    ofstCtl.text=Word.ofst.toString();
    Widget ctc= ListView(
        children: [
          Padding(padding: EdgeInsets.only(bottom: 10.0,top: 10,left: 30,right: 30),
            child: ElevatedButton( onPressed: (){
              actionReset();
              exitSettingPage();
            },
                child:const AutoSizeText("重置",presetFontSizes:
                [50,100,90,80,70,60,50,20,16,10])), ),
          Padding(padding:  EdgeInsets.only(bottom: 10.0,top: 10,left: 30,right: 30),
            child: ElevatedButton( onPressed: (){
              messUp();
              exitSettingPage();
            },
                child:const AutoSizeText("打乱",
                    presetFontSizes: [50,100,90,80,70,60,50,20,16,10])),
          ),
          Padding(padding:  EdgeInsets.only(bottom: 10.0,top: 10,left: 30,right: 30),
            child:
            ElevatedButton(onPressed: (){
              nextWordsGroup();
              exitSettingPage();

            }, child:const AutoSizeText("下一组"
              ,presetFontSizes: [50,100,90,80,70,60,50,20,16,10],),
            )
            ,
          ),
          Padding(padding:  EdgeInsets.only(bottom: 10.0,top: 10,left: 30,right: 30),
            child:
            ElevatedButton(onPressed: (){
              Navigator.push(context,MaterialPageRoute(builder: (ct){
                return WordListPage(wzs: wzs);
              })).then((value){
                setState(() {
                  nextWz();
                });
              });

            }, child:const AutoSizeText("全部卡片"
              ,presetFontSizes: [50,100,90,80,70,60,50,20,16,10],),
            )
            ,
          ),

          Row(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
            children: [const Text("重置后打乱顺序"), Switch(value: msupOnReset, onChanged: (v){
              setState(() {
                msupOnReset=v!;
              });
              saveStateToFile();
            })],),
          Row(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
            children: [const Text("重置后拆分意思"), Switch(value: divide, onChanged: (v){
              setState(() {
                divide=v!;
              });

              saveStateToFile();
            })],),

          Row(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
            children: [const Text("正面: ")
              ,MyDropdownButton(value: frontpage, items: cardTypes.entries.map<DropdownMenuItem<String>>((e){
                return DropdownMenuItem<String>(
                  value:  e.key,
                  child: Text(e.key),
                );
              }).toList(), onchange: (val){
                frontpage=val;
              })],),
          Row(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
            children: [const Text("背面: ")
              ,MyDropdownButton(value: backPage, items: cardTypes.entries.map<DropdownMenuItem<String>>((e){
                return DropdownMenuItem<String>(
                  value:  e.key,
                  child: Text(e.key),
                );
              }).toList(), onchange: (val){
                backPage=val;
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
            children: [const Text("显示新卡片后播放音频"), Switch(value: _playAudioAfterNewCard, onChanged: (v){
              setState(() {
                _playAudioAfterNewCard=v!;
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

          TextField(
            onChanged: (String v){
              int? tn=int.tryParse(v);
              if(tn!=null){
                int b=Word.ofst+tn;
                if(b>=0&&b<Word.allOfWord.length&&tn>=0&&tn<Word.allOfWord.length&&b!=tn){
                  Word.pos=tn;
                  Word.flush();
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
                int testPos=tn+Word.pos;
                if(testPos>=0&&testPos<Word.allOfWord.length){
                  Word.ofst=tn;
                  Word.flush();
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
    ctc=Scrollbar(
      thumbVisibility: true,
      trackVisibility: true,
      child:ctc,
    );
    return GestureDetector(child:Scaffold(
      appBar: AppBar(
          centerTitle:true,
        title: ElevatedButton(child: Text("退出"),
      onPressed: (){exitSettingPage();},),),
      body: ctc,) ,onDoubleTap: (){exitSettingPage();},) ;
  }
  bool _playAudioAfterNewCard=true;

  void exitSettingPage() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    showFrontPage();
  }


  void actionReset()  {
    if(_reviewPattern){
      Word.flush(p:0,o:Word.pos);
    }
    else {
      Word.flush();
    }

    if(divide)Word.divideDisplayList();
    if(msupOnReset){
      messUp();
    }
  }

  void nextWordsGroup() {
    Word.next();
    curIndexOfWz=0;
  }
  void nextWz(){
    curIndexOfWz=(curIndexOfWz+1)%wzs.length;
  }

  void messUp() {
    var sd=Random(DateTime.now().millisecondsSinceEpoch);
    for(int i=0;i<100;++i){
      Word.displayList.shuffle(sd);
    }
    curIndexOfWz=0;
  }
  @override
  void initState() {
    inialize();
    super.initState();
  }
  void inialize()async{
    await readStateFromFile() ;
    actionReset();
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
  Map<String,Builder> cardTypes={};
  void iniCardTypes(){
    cardTypes={"英文":Builder(builder: (context){
      return buildEnglishPage(wzs[curIndexOfWz].eng, context);
    })
      ,"中文释义":Builder(builder: (context){
        return  buildChinesePage(wzs[curIndexOfWz],  context);
      })
      ,"例句":Builder(builder: (context){
        return  buildSentencePage();
      })
      ,"音频播放":Builder(builder: (context){
        return  buildAudioPage(tag: "${DateTime.now().second}");
      })
    };
  }
  String frontpage="音频播放";
  String backPage="中文释义";
  Widget wrapBaseAction(Widget wgt){
    Widget gst= GestureDetector(child: wgt
        , onVerticalDragEnd: (details){
          nextWz();
          if(_playAudioAfterNewCard)playAudio();
          showFrontPage();
        },onLongPress: (){
          alreadyMastered();
          if(_playAudioAfterNewCard)playAudio();
          showFrontPage();
        }
        ,onDoubleTap: (){
          entrySettingPage();
        });
    return gst;
  }
  void showFrontPage( ){
    showPage(Builder(builder: (context){
      return wrapBaseAction(
          GestureDetector(
            child:cardTypes[frontpage]?.build(context)
            ,onHorizontalDragEnd: (details){showBackPage();}
            ,onTap: (){showBackPage();},
          )) ;
    }));
  }
  void showBackPage(){
    showPage(Builder(builder: (context){
      return wrapBaseAction(GestureDetector(
        child: cardTypes[backPage]?.build(context)
        ,onTap: (){showFrontPage();}
        ,onHorizontalDragEnd: (details){
        showFrontPage();
      },
      ));
    }));
  }
  List<Word> get wzs {return Word.displayList;}
  Widget buildChinesePage(Word w,BuildContext context) {
    var eng=AutoSizeText(w.eng , maxLines:1,presetFontSizes: const [ 100,80,60,50,25,16,12],);
    var pho=AutoSizeText(w.phonics,maxLines:1,presetFontSizes: const [25,16,12]);
    var mean=AutoSizeText(w.mean[0],maxLines:1,presetFontSizes: const [
      180,170,160,150,140,
      130,120,110,100,90,80,70,60,50,40,25,16,12]);

    Widget content=Column(mainAxisAlignment: MainAxisAlignment.center
      ,crossAxisAlignment: CrossAxisAlignment.center
      ,children: [
        Align(child: eng,)
        ,
        Align(child: pho,)
        ,
        Align(child: mean,)

      ],);

    return  Scaffold(body:content ,);
  }
  void showPage(Builder builder){
    setState(() {
      _builderOfPage=builder;
    });
  }

  Widget buildEnglishPage(String eng,BuildContext context) {
    var content= Center(
      child: AutoSizeText(eng ,
        maxLines:1,presetFontSizes: const [
          180,170,160,150,140,130,120,110,100,80,60,50,25,18,12],),
    );
    var scf= Scaffold(
      body: content,);

    return  scf;
  }
  Widget buildSentencePage({str=""}){
   /* str="abandon"
    "\n1. The family had to abandon their home due to the impending flood."
    "\n2. After repeatedly failing to win, the athlete decided to abandon "
        "their dream of becoming an Olympic champion."
   " \n3. The company had to abandon their plans for expansion "
    "due to a lack of funding.";
    */
    if(str==""){
      str=wzs[curIndexOfWz].abouts[0];
    }

    Widget wgt=Center(child:
     AutoSizeText(str
      ,presetFontSizes:const [
        180,170,160,150,140,
        130,120,110,100,90,80,70,60,50,40,25,16,12],
    ),
    );
    return Scaffold(
      appBar: AppBar(title:Text(wzs[curIndexOfWz].eng,
      style: TextStyle(fontSize: 30,color: Colors.black),)
      ,centerTitle: true
        , backgroundColor:Colors.white
      ),
      body: Padding(padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
      child:wgt ,) ,);
  }

  Widget buildAudioPage({String tag=""}) {
    var bt= ElevatedButton(
        onPressed: (){
          playAudio();
        }, child:   AutoSizeText( "play $tag",
      maxLines:1,presetFontSizes: const [
        180,170,160,150,140,130,120,110,100,80,60,50,25,18,12],)
    );
    return Scaffold(body:Center(child: Container(width:200*2 ,height: 50*3, child: bt,) ,),);
  }

}