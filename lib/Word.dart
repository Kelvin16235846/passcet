
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

Map<String,dynamic > glb={};
String path_wzfile="wz/out_1500wzimwztxt_out.txt";
String docPath="null";
class Word{
  late String chinese="";
  late String english="";
  late String phonics="";
  late String  eg_eng="";
  late String  eg_chi="";
  late String  eg_ori="";
  late String id="";
  static Word fromMap(Map mp){
    Word w=Word();
    if(mp.containsKey("eg_eng")) w.eg_eng=mp["eg_eng"] as  String;
    if(mp.containsKey("eg_chi"))w.eg_chi=mp["eg_chi"]as  String;
    if(mp.containsKey("eg_ori"))w.eg_ori=mp["eg_ori"]as  String;
    if(mp.containsKey("english"))w.english=mp["english"]as  String;
    if(mp.containsKey("phonics"))w.phonics= mp["phonics"]  as  String;
    if(mp.containsKey("chinese"))w.chinese=mp["chinese"]as  String;
    if(mp.containsKey("id"))w.id=mp["id"] as  String;
    return w;
  }
  Map  toMap(){
    Map  mp={};
    Word w= this;
    mp["eg_eng"] =w.eg_eng;
    mp["eg_chi"] =w.eg_chi;
    mp["eg_ori"] =w.eg_ori;
    mp["english"] =w.english;
    mp["phonics"] =w.phonics;
    mp["chinese"] =w.chinese;
    mp["id"] =w.id;
    return mp;
  }
  static List<Word> displayList=[];
  static List<Word> allOfWord=[];
  static int pos=0;
  static int ofst=20;


  static String wordbook="json_1500";

  static bool isAlive(String id) {

    var f=File("$docPath/$id");
    if(f.existsSync()){
      DateTime dt= DateTime.parse(f.readAsStringSync().trim());
      var now=DateTime.now();
      bool isal=dt.isBefore(now);
      return isal;
    }
    return true;
  }
  static void makeSleep(String id,Duration duration) {

    var f=File("$docPath/$id");
    if(!f.existsSync()){
      f.createSync(recursive: true);
    }
    DateTime now=DateTime.now();
    now=now.add(duration);
    f.writeAsStringSync(now.toIso8601String(),flush: true);

  }
  static void makeAlive(String id) {
    Duration duration=Duration(minutes: 100);
    var f=File("$docPath/$id");
    if(!f.existsSync()){
      f.createSync(recursive: true);
    }

    DateTime dt=DateTime.now();
    dt=dt.subtract(duration);
    DateTime now=DateTime.now();
    bool rs=dt.isBefore(now);
    f.writeAsStringSync(dt.toIso8601String(),flush: true);


  }
  static void mvResourceToDocmentPath(List<Word> wds,String fileName){

    String jsonString = jsonEncode(wds.map((word) {
      return word.toMap();
    }

    ).toList()
    );
    String docPath=glb["docPath"]+"/$fileName";
    File f=File(docPath);
    f.createSync();
    f.writeAsStringSync(jsonString);

  }
  static Future<ByteData?> fileExistsInAssets(String filePath) async {
    try {
      ByteData data = await rootBundle.load(filePath);
      return (data.lengthInBytes != 0)? data:null;
    } catch (e) {
      return null;
    }
  }
  static void loadAllWord(){
    File f=File(docPath+"/"+wordbook);
    List<dynamic> decodedList =jsonDecode(f.readAsStringSync());
    List<Word> wds = decodedList.map((item) => Word.fromMap(item)).toList();
    allOfWord.clear();
    allOfWord.addAll(wds);
  }
  static Future<List<Word>> readJsonWzFile(String path_res)async{
    // 从资源文件中读取
    ByteData data = await rootBundle.load(path_res);
    List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    // 使用Utf8Decoder和LineSplitter逐行读取
    Stream<String> lines = utf8.decoder.bind(Stream.fromIterable(
        bytes.map((e) => [e]))).transform(const LineSplitter());
    List<Word> ans=[];
    try {
      // 处理每一行
      await for (String line in lines) {
         Map mp= jsonDecode(line);
         Word w=Word();

         w=Word.fromMap(mp);
         ans.add(w);

      }
      return  ans;

    } catch (e) {
      print('Error: $e');
    }
    return  ans;


  }


  static String encodeState(){
    Map<String,dynamic> stateMap={
      "pos":pos,
      "ofst":ofst,
      "wordbook":wordbook,
    };
    return jsonEncode(stateMap);
  }
  static void decodeStateJson(String jsonstr){
    Map<String,dynamic> mp=jsonDecode(jsonstr);
    ofst=mp["ofst"];
    pos=mp["pos"];
    wordbook=mp["wordbook"];
     }
  static void saveStateToFile() {
      String dir="${glb["docPath"]}/$cfgPath";
      File f= File(dir);
      f.writeAsStringSync(encodeState());
  }

  static void readStateFromFile() {
      String dir = "${glb["docPath"]}/$cfgPath";
      File f = File(dir);
      var dts = f.readAsStringSync();
      decodeStateJson(dts);
  }
  static void next(){
    pos+=ofst;
    flush(p:pos, o:ofst);
  }
  static String  cfgPath="cfg0.txt";
  static void   flushExtend({int p=-1,int o=-1}) {
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

      int cnt=b-a-displayList.length;
      List<Word> ans=[];
      while(cnt>0&&b<allOfWord.length){
        Word v=allOfWord[b];
        if(Word.isAlive(v.id)){
          ans.add(v) ;
          cnt-=1;
        }
        b+=1;
      }
      displayList.addAll(ans);
      saveStateToFile();

    }


  }
  static void   flush({int p=-1,int o=-1,bool activate=false}) {
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
      for(var v in allOfWord.sublist(a,b)){
        if(activate){
          Word.makeAlive(v.id);
        }
        if(Word.isAlive(v.id)){
          displayList.add(v) ;
        }
        else {
          print("${v.english} is in sleep");
        }


      }
        saveStateToFile();

    }


  }

}
