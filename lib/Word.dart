
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
  Word({this.eng="ENGLISH",this.phonics="phonics",this.mean=const ["中文意思"],  this.abouts=const  []});
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
  static String path_wzfile="wz/out_六百个高频词.txt";
  static void setPathOfWzFile(String wzpath){
    path_wzfile="wz/"+wzpath;
    pos=0;
    ofst=20;
    saveStateToFile();
  }
  static Future<bool> inialize()async{


    //await readFWzFile();
    //log("文件加载完成${allOfWord?.length}");
    readJsonWzFile(path_wzfile);

    return true;
  }
  static void readJsonWzFile(String path_res)async{
    // 从资源文件中读取
    ByteData data = await rootBundle.load(path_res);
    List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    // 使用Utf8Decoder和LineSplitter逐行读取
    Stream<String> lines = utf8.decoder.bind(Stream.fromIterable(
        bytes.map((e) => [e]))).transform(const LineSplitter());
    try {
      // 处理每一行
      await for (String line in lines) {
         Map mp= jsonDecode(line);
         String phonics="";
         if(mp.containsKey("phonics"))phonics=mp["phonics"];
         Word w=Word(eng: mp["english"],phonics: phonics,mean:[mp["chinese"]] );
         allOfWord.add(w);
         addSentence(w);
      }
    } catch (e) {
      print('Error: $e');
    }

  }

  static Future<void> readFWzFile() async {
     String s=await loadAsset(path:"wz/c4_ECP.txt");
    var lst= s.split("\r\n");
    for(int i=0;i+2<lst.length;i+=3){
      allOfWord.add(Word(eng:lst[i+0].trim(),phonics: lst[i+2].trim() ,mean: [lst[i+1].trim()]));
        addSentence(allOfWord[allOfWord.length-1]);
    }

  }

  static void addSentence(Word word) {
    var pt="wz/sentenceByWz/${word.eng}.txt";
    //print("sentence_path is $pt");
          fileExistsInAssets(pt).then((val)
    {
      if(val==null||val.elementSizeInBytes<=10){
        word.abouts=["eg is no exist"];
      }
      else {
        final mp= jsonDecode(utf8.decode(val.buffer.asUint8List()));
        print('$mp');
        word.abouts=[ "${mp["eg"]}"];
      }
    }
    );
  }

  static String encodeState(){
    Map<String,dynamic> stateMap={
      "pos":pos,
      "ofst":ofst,
      "path_wzfile":path_wzfile,
    };
    return jsonEncode(stateMap);
  }
  static void decodeStateJson(String jsonstr){
    Map<String,dynamic> mp=jsonDecode(jsonstr);
    ofst=mp["ofst"];
    pos=mp["pos"];
    path_wzfile=mp["path_wzfile"];
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
