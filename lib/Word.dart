
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

import 'main.dart';

class Word{
  late List<String> mean;

  late String eng;
  late String phonics;
  late List<String> abouts;
  Word({this.eng="ENGLISH",this.phonics="phonics",this.mean=const ["中文意思"],  this.abouts=const  ["no eg"]});
  static List<Word> displayList=[];
  static List<Word> allOfWord=[];
  static int pos=0;
  static int ofst=20;
  static Future<ByteData?> fileExistsInAssets(String filePath) async {
    try {
      ByteData data = await rootBundle.load(filePath);
      return (data.lengthInBytes != 0)? data:null;
    } catch (e) {
      return null;
    }
  }
  static   final List<double> _settingFontSize=[/*50,100,90,80,70,60,50,20,*/16,10];
  static List<double> get fontSizeOfSetting{return Word._settingFontSize;}
  static void makeDeviceLandscapeScreen(){
    //SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft,DeviceOrientation.landscapeRight]);
  }
  Word coloneMyself(){
    return Word( eng:this.eng, phonics:this.phonics, mean:this.mean,abouts:this.abouts);
  }
  List<Word> divideMeans( ){

    List<Word> ans=[];
    var mean=this.mean[0];
    var mns=<String>[];
      var listA=mean.split(RegExp(";|；"));
      listA=listA.map((e) => e.trim()).toList();
      for(var v in listA){
        mns.addAll(v.split(RegExp("( )+")));
      }
      for(var m in mns){
        var n=this.coloneMyself();
        n.mean= <String>[m];
        ans.add(n);
      }
      return ans;
  }
  static Future<bool> inialize()async{

    allOfWord=[];
    String s=await loadAsset(path:"wz/c4_ECP.txt");
    var lst= s.split("\r\n");
    for(int i=0;i+2<lst.length;i+=3){
      allOfWord.add(Word(eng:lst[i+0].trim(),phonics: lst[i+2].trim() ,mean: [lst[i+1].trim()]));
        var word=allOfWord[allOfWord.length-1];
      fileExistsInAssets("wz/sentenceByWz/${word.eng}.txt").then((val)
        {
          if(val==null){
            word.abouts=["eg is no exist"];
          }
          else {
            final mp= jsonDecode(utf8.decode(val.buffer.asUint8List()));
            word.abouts=[ "${mp["eg"]}"];
          }
        }
        );
    }
    //log("文件加载完成${allOfWord?.length}");

    return true;
  }

  static String encodeState(){
    Map<String,dynamic> stateMap={
      "pos":pos,
      "ofst":ofst,
    };
    return jsonEncode(stateMap);
  }
  static void decodeStateJson(String jsonstr){
    Map<String,dynamic> mp=jsonDecode(jsonstr);
    ofst=mp["ofst"];
    pos=mp["pos"];
     }
  static void saveStateToFile()async{
    Future(()async{
      String dir="${(await  getApplicationDocumentsDirectory()).path}/$cfgPath";
      File f= File(dir);
      RandomAccessFile fl= await f.open(mode: FileMode.write);
      fl.writeStringSync(encodeState());
      fl.closeSync();

    });
  }

  static Future<void> readStateFromFile()async{
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
  static void next(){
    pos+=ofst;
    flush(p:pos, o:ofst);
  }
  static void divideDisplayList(){

    List<Word> ans=[];
    for(var m in displayList){
      ans.addAll(m.divideMeans());
    }
    displayList.clear();
    displayList.addAll(ans);

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
      displayList.clear();
      displayList.addAll(allOfWord.sublist(a,b));
      Future(()async{
        saveStateToFile();
      });
    }


  }

}
