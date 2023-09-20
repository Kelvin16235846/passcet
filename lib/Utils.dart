import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
import 'package:fsfsfsf/WordWidget.dart';

import 'Word.dart';

class Utils{
  static final player = AudioPlayer();
  static const String ONLY_EG='ONLY_PLAY_INSTANCE_VOICE';
  static const String ONLY_WZ='ONLY_PLAY_WZ_VOICE';
  static const String WZ_THEN_INSTANCE='PLAY_WZ_BEFOR_INSTANCE';
  static const String INSTANCE_THEN_WZ='PLAY_INSATNCE_THEN_WZ';
  static Future<ByteData?> fileExistsInAssets(String filePath) async {
    try {
      ByteData data = await rootBundle.load(filePath);
      return (data.lengthInBytes != 0)? data:null;
    } catch (e) {
      return null;
    }
  }
  static Future<void> playInstanceVoice(String wordId)async{

    await player.stop();
    String mp3Path="wz/eg_voices/"+wordId+".mp3";
    fileExistsInAssets(mp3Path).then((a) async {
      if(a==null){
        a=await fileExistsInAssets("wz/__no_audio_hint.mp3");
      }
      if(a!=null){
        await player.setSourceBytes(a.buffer.asUint8List());
        await player.resume();
      }
    });




  }
  static void playAudio({required String eng ,String type ="__None__"})async{
    if(WordWidgetState.playInstanceInteadWz){
      await Utils.playInstanceVoice(Word.displayList[WordWidgetState.curIndexOfWz].id);
      return;
    }
    if(type=="__None__"){
      type="${DateTime.now().microsecondsSinceEpoch%2}";
    }

    await player.stop();
    fileExistsInAssets("wz/wzmp3/${eng.trim()}_1.mp3").then((a) async {
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