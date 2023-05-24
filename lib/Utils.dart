import 'dart:typed_data';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';

class Utils{
  static final player = AudioPlayer();

  static Future<String> readFileAsString(String filePath) async {
    try {
      File file = File(filePath);
      if (await file.exists()) {
        String content = await file.readAsString();
        return content;
      } else {
        print('File not found at $filePath');
        return '';
      }
    } catch (e) {
      print('Error reading file: $e');
      return '';
    }
  }
  static Future<void> writeStringToFile(String filePath, String content) async {
    try {
      File file = File(filePath);
      await file.writeAsString(content, mode: FileMode.write);
      print('File written successfully at $filePath');
    } catch (e) {
      print('Error writing file: $e');
    }
  }

  static Future<ByteData?> fileExistsInAssets(String filePath) async {
    try {
      ByteData data = await rootBundle.load(filePath);
      return (data.lengthInBytes != 0)? data:null;
    } catch (e) {
      return null;
    }
  }
  static void playAudio({required String eng ,String type ="__None__"})async{
    if(type=="__None__"){
      type="${DateTime.now().microsecondsSinceEpoch%2}";
    }

    await player.stop();
    fileExistsInAssets("wz/mp3file/${eng.trim()}_$type.mp3").then((a) async {
      if(a==null){
        a=await fileExistsInAssets("wz/__no_audio_hint.mp3");
      }
      if(a!=null){
        await player.setSourceBytes(a.buffer.asUint8List());
        await player.resume();
      }

    });


  }
}