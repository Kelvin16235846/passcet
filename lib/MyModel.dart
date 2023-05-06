
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

import 'main.dart';

class MyModel{
  late List<String> mean;

  late String eng;
  late String phonics;

  late List<String> abouts;
  MyModel({this.eng="ENGLISH",this.phonics="phonics",this.mean=const ["中文意思"]});
  static List<MyModel> displayList=[];
  static List<MyModel> allOfWord=[];
  static int pos=0;
  static int ofst=5;
  static void makeDevicePortraitScreen(){
    WidgetsFlutterBinding.ensureInitialized(); //不加这个强制横/竖屏会报错
    /*SystemChrome.setPreferredOrientations([
      // 强制竖屏
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown
    ]);*/
  }
  static   List<double> _settingFontSize=[/*50,100,90,80,70,60,50,20,*/16,10];
  static List<double> get fontSizeOfSetting{return MyModel._settingFontSize;}
  static void makeDeviceLandscapeScreen(){
    //SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft,DeviceOrientation.landscapeRight]);
  }
  static Future<bool> inialize()async{
    allOfWord=[];
    String s=await loadAsset(path:"wz/c4_ECP.txt");
    var lst= s.split("\r\n");
    for(int i=0;i+2<lst.length;i+=3){
      allOfWord?.add(MyModel(eng:lst[i+0].trim(),phonics: lst[i+2].trim() ,mean: [lst[i+1].trim()]));
    }
    //log("文件加载完成${allOfWord?.length}");
    return true;
  }
  static void next(){
    pos+=ofst;
    flush(p:pos, o:ofst);
  }

  static String  cfgPath="cfg0.txt";
  static void   flush({int p=-1,int o=-1}){
    if(p==-1){
      p=MyModel.pos;
      o=MyModel.ofst;
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
        String dir="${(await  getApplicationDocumentsDirectory()).path}/${MyModel.cfgPath}";
        File f= File(dir);
        RandomAccessFile fl= await f.open(mode: FileMode.write);
        fl.writeStringSync("${MyModel.pos}\n");
        fl.writeStringSync("${MyModel.ofst}\n");
        fl.closeSync();

      });
    }


  }

}
