import 'package:flutter/material.dart' ;
import 'dart:async';
import  'package:flutter/services.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'WordWidget.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft,DeviceOrientation.landscapeRight]);
    runApp(MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '过四级!!!',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue)
      ),
      home:   WordWidget(),
    );
  }
}



