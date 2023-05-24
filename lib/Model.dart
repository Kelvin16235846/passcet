import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:fsfsfsf/Utils.dart';
import 'package:fsfsfsf/Word.dart';
import 'package:path_provider/path_provider.dart';
class Model{
  static List<Word> displayList=[];
  static List<Word> allOfWord=[];
  static int pos=0;
  static int ofst=20;
  static   final List<double> _settingFontSize=[/*50,100,90,80,70,60,50,20,*/16,10];
  static List<double> get fontSizeOfSetting{return Model._settingFontSize;}
  static    final String  path_root="modelcfg.json";
  static   String  path_WzFile="wz/json_600_unsorted.txt";
  static  String path_wzFileCfg=path_WzFile+"_Config";

  //调用这个函数之后程序就会重启
  static void changefWzFile(String wzpath){
    path_WzFile=wzpath;
    writerRootConfig();
  }
  static Future<void> readRootConfig() async {
    String ptwz=await  Utils.readFileAsString(path_root);
    ptwz=ptwz.trim();
    if(ptwz!=""){
      path_WzFile=ptwz;
    }
  }
  static Future<void> readWzFile() async {
    String pathRes=path_WzFile;
    // 从资源文件中读取
    ByteData data = await rootBundle.load(pathRes);
    List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    // 使用Utf8Decoder和LineSplitter逐行读取
    Stream<String> lines = utf8.decoder.bind(Stream.fromIterable(
        bytes.map((e) => [e]))).transform(const LineSplitter());
    allOfWord=[];
    try {
      // 处理每一行
      await for (String line in lines) {
        //在这里进行处理
        allOfWord.add(Word.fromJson(line));
      }
    } catch (e) {
      print('Error: $e');
    }
  }
  static Future<void> readWzConfigFile() async {
    var jsonstr= await Utils.readFileAsString(path_wzFileCfg);
    if(jsonstr==""){
      pos=0;
      ofst=10;
    }
    else {
      decodeStateJson(jsonstr);
    }

  }

  static void writerRootConfig(){
    Utils.writeStringToFile(path_WzFile, path_root);
  }
  static void writerWzConfigFile(){
    Utils.writeStringToFile(encodeState(), path_wzFileCfg);
  }
  static Future<bool> inialize()async{
    readRootConfig();
    readWzConfigFile();
    readWzFile();
    return true;
  }

  static String encodeState(){
    Map<String,dynamic> stateMap={
      "pos":pos,
      "ofst":ofst
    };
    return jsonEncode(stateMap);
  }
  static void decodeStateJson(String jsonstr){
    Map<String,dynamic> mp=jsonDecode(jsonstr);
    ofst=mp["ofst"];
    pos=mp["pos"];
     }

  static void next(){
    pos+=ofst;
    flush(p:pos, o:ofst);
  }
  static void   flush({int p=-1,int o=-1}){
    if(p==-1){
      p=Model.pos;
      o=Model.ofst;
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
      writerWzConfigFile();
    }
  }

}
