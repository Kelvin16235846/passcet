import 'package:flutter/material.dart' ;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:async';
import  'package:flutter/services.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'Model.dart';
import 'WordWidget.dart';

Future<String> loadAsset({required String path}) async {
  var a = await rootBundle.loadString(path);
  return a;
}
void main() {
  WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft,DeviceOrientation.landscapeRight]);
    runApp( const MyApp() );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '过四级!!!',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue)
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
    return  WordWidget();
  }
  @override
  void initState()  {
    super.initState();
    Model.inialize();
    Model.flush();
  }
}



