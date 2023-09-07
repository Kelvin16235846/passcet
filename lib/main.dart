import 'package:flutter/material.dart' ;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import  'package:flutter/services.dart';
import 'Word.dart';
import 'WordWidget.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  glb["docPath"]=(await  getApplicationDocumentsDirectory()).path;
  docPath=glb["docPath"];
  Word.cfgPath="d1hsfsfsfoSfsfdsYFDSdsbfsf";
  String dir="$docPath/${Word.cfgPath}";


  File f= File(dir);
  if(!f.existsSync()){
    Word.mvResourceToDocmentPath(await Word.readJsonWzFile(path_wzfile), Word.wordbook);
    Word.saveStateToFile();
  }
  Word.loadAllWord();
  Word.readStateFromFile();
  Word.flush();

    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft,DeviceOrientation.landscapeRight]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    WordWidget widget= WordWidget();
    runApp(   MaterialApp(
      title: '过四级!!!',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue)
      ),
      home:Scaffold(body: WordWidget(),),
    ));



}



