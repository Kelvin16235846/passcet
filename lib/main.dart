import 'dart:developer';
import 'package:flutter/material.dart' ;
import 'dart:math' as math;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:simple_gesture_detector/simple_gesture_detector.dart';
import 'dart:async';
import  'package:flutter/services.dart';
import 'package:flutter/services.dart' show rootBundle;

Future<String> loadAsset({required String path}) async {
  var a = await rootBundle.loadString(path);
  return a;
}
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
     await Word.inialize();
     await Future(()async{
         String dir="${(await  getApplicationDocumentsDirectory()).path}/${Word.cfgPath}";
         File f= File(dir);
         if(f.existsSync()){
            var dts=f.readAsLinesSync();
            Word.pos= int.parse(dts[0]);
            Word.ofst=int.parse(dts[1]);
         }



     });
  SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft,DeviceOrientation.landscapeRight]);
  runApp(  MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MaterialApp的title',
      theme: ThemeData( 
        primarySwatch: Colors.blue
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title}); 
  final String title;
  @override
  State<MyHomePage> createState() {
    return _MyHomePageState();
  }
}

class _MyHomePageState extends State<MyHomePage> {


  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
         return  WordWdget();
   }
   @override
    void initState()  {
      super.initState();
      Word.flush();
  }
}


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
      child: PageView( controller: carControl,onPageChanged:(int v){
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
    var fsz=<double>[70,60,50];
    var scfd= Scaffold(
         /* appBar: AppBar(title: Text("单词总数:${Word.allOfWord.length} 指针: ${Word.pos}  偏移量:${Word.ofst}  卡片剩余:${cards.length}"),),*/
            body:contenWedget ,
         /* bottomSheet: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [ElevatedButton(onPressed: (){
              rollPage();
            }, child: AutoSizeText("翻滚(Z)",presetFontSizes:fsz ,)),
              Padding(padding: EdgeInsets.only(left: 10.0),child: ElevatedButton(onPressed: (){
                nextPage();
              }, child: AutoSizeText("下一页(X)",presetFontSizes: fsz,)), ),
            Padding(padding: EdgeInsets.only(left: 10.0),child:ElevatedButton(onPressed: (){
            entrySettingPage();
            }, child: AutoSizeText("设置(C)",presetFontSizes: fsz,)), ),
    Padding(padding: EdgeInsets.only(left: 10.0),child:

    ElevatedButton( onPressed: (){
                alreadMastered();
              }, child: AutoSizeText( "已掌握(V)",presetFontSizes: fsz,))),
            ],)*/
        );
    return   scfd ;


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
    posCtl.text=Word.pos.toString();
    ofstCtl.text=Word.ofst.toString();
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
          Word.next();
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
  }
  PageController carControl=PageController(initialPage: 1);
  PageController wControl=PageController(initialPage: 1);
  @override
  void initState() {
    super.initState();
    Word.flush();
    updateCards();
  }
  void updateCards(){
    cards=[];
    for (var element in Word.displayList) {
      cards.addAll(makePageViews(element));
    }
  }
  bool wonset=false;
  bool meanFirst=false;

  List<Widget>   makePageViews(Word w){
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
            onTap: (){nextPage();},
            child: PageView(
          scrollDirection: Axis.vertical,
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
class Word{
  late List<String> mean;
  late String eng;
  late String phonics;

  late List<String> abouts;
  Word({this.eng="ENGLISH",this.phonics="phonics",this.mean=const ["中文意思"]});
  static List<Word> displayList=[];
  static List<Word> allOfWord=[];
  static int pos=0;
  static int ofst=5;
   static Future<bool> inialize()async{
     allOfWord=[];
     String s=await loadAsset(path:"wz/c4_ECP.txt");
       var lst= s.split("\r\n");
       for(int i=0;i+2<lst.length;i+=3){
         allOfWord?.add(Word(eng:lst[i+0].trim(),phonics: lst[i+2].trim() ,mean: [lst[i+1].trim()]));
       }
       log("文件加载完成${allOfWord?.length}");
       return true;
   }
   static void next(){
       pos+=ofst;
       flush(p:pos, o:ofst);
   }

 static String  cfgPath="cfg0.txt";
  static void   flush({int p=-1,int o=-1}){
    if(p==-1){
      p=Word.pos;
      o=Word.ofst;
    }
     int a=p;
     int b=p+o;
     if(a>b){
       int t=a;
       a=b;
       b=t;
     }
     if(a>=0&& a<b&&b<=allOfWord.length) {
       displayList=allOfWord.sublist(a,b);
        Future(()async{
          String dir="${(await  getApplicationDocumentsDirectory()).path}/${Word.cfgPath}";
          File f= File(dir);
          RandomAccessFile fl= await f.open(mode: FileMode.write);
          fl.writeStringSync("${Word.pos}\n");
          fl.writeStringSync("${Word.ofst}\n");
          fl.closeSync();

      });
     }


  }

}


