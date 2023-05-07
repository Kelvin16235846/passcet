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

import 'MyModel.dart';
import 'WordWdget.dart';

Future<String> loadAsset({required String path}) async {
  var a = await rootBundle.loadString(path);
  return a;
}
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
    MyModel.inialize();
    Future(()async{
    String dir="${(await  getApplicationDocumentsDirectory()).path}/${MyModel.cfgPath}";
    File f= File(dir);
    if(f.existsSync()){
      var dts=f.readAsLinesSync();
      MyModel.pos= int.parse(dts[0]);
      MyModel.ofst=int.parse(dts[1]);
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
      title: '过四级!!!',
      theme: ThemeData(
          primarySwatch: Colors.blue
      ),
      home: const MyHomePage(title: '过四级!'),
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
    MyModel.flush();
  }
}



