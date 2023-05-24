import 'dart:convert';

import 'package:fsfsfsf/wzcard.dart';

class Word {
  final List<Usage> usages;
  final List<Mean> means;
  final List<Collocation> collocations;
  final String chinese;
  final String usageCount;
  final String phonicsHelp;
  final String english;
  final String meanCount;
  final String phonics;
  final String collocationCount;
  List<WzCard> splitToEngAndChinese([bool dv=true]){
    List<WzCard> ans=[];
    if(dv){
      for(var m in means){
        ans.add(WzCard(wz:english,front: ))

      }
    }

    return ans;
  }
  Word({
    required this.usages,
    required this.means,
    required this.collocations,
    required this.chinese,
    required this.usageCount,
    required this.phonicsHelp,
    required this.english,
    required this.meanCount,
    required this.phonics,
    required this.collocationCount,
  });
  List<WzCard> ToEngTogChi([bool split=false]){
    List<WzCard> ans=[];
    if(!split){
      ans.add(WzCard(wz: "", front: english, back: chinese , index: -1));
    }
    else{
      for(var v in means){
        ans.add(WzCard(front: english,back: v.mean));
      }
    }
    return ans;
  }


  factory Word.fromJson(String str) => Word.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Word.fromMap(Map<String, dynamic> json) {
    int usageCount = int.parse(json['usage_count']);
    int meanCount = int.parse(json['mean_count']);
    int collocationCount = int.parse(json['collocation_count']);
    List<Usage> usages = [];
    List<Mean> means = [];
    List<Collocation> collocations = [];

    for (int i = 1; i <= usageCount; i++) {
      usages.add(Usage(
        usage: json['usage_$i'],
        usageEg: json['usage_${i}_eg'],
        usageEgChinese: json['usage_${i}_eg_chinese'],
      ));
    }

    for (int i = 1; i <= meanCount; i++) {
      means.add(Mean(
        mean: json['mean_$i'],
        meanEg: json['mean_${i}_eg'],
        meanEgChinese: json['mean_${i}_eg_chinese'],
      ));
    }

    for (int i = 1; i <= collocationCount; i++) {
      collocations.add(Collocation(
        collocation: json['collocation_$i'],
        collocationEg: json['collocation_${i}_eg'],
        collocationEgChinese: json['collocation_${i}_eg_chinese'],
      ));
    }

    return Word(
      usages: usages,
      means: means,
      collocations: collocations,
      chinese: json["chinese"],
      usageCount: json["usage_count"],
      phonicsHelp: json["phonics_help"],
      english: json["english"],
      meanCount: json["mean_count"],
      phonics: json["phonics"],
      collocationCount: json["collocation_count"],
    );
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> json = {
      "chinese": chinese,
      "usage_count": usageCount,
      "phonics_help": phonicsHelp,
      "english": english,
      "mean_count": meanCount,
      "phonics": phonics,
      "collocation_count": collocationCount,
    };

    for (int i = 0; i < usages.length; i++) {
      json['usage_${i + 1}'] = usages[i].usage;
      json['usage_${i + 1}_eg'] = usages[i].usageEg;
      json['usage_${i + 1}_eg_chinese'] = usages[i].usageEgChinese;
    }

    for (int i = 0; i < means.length; i++) {
      json['mean_${i + 1}'] = means[i].mean;
      json['mean_${i + 1}_eg'] = means[i].meanEg;
      json['mean_${i + 1}_eg_chinese'] = means[i].meanEgChinese;
    }

    for (int i = 0; i < collocations.length; i++) {
      json['collocation_${i + 1}'] = collocations[i].collocation;
      json['collocation_${i + 1}_eg'] = collocations[i].collocationEg;
      json['collocation_${i + 1}_eg_chinese'] = collocations[i].collocationEgChinese;
    }

    return json;
  }
}
class Usage {
  String _usage;
  String _usageEg;
  String _usageEgChinese;

  Usage({
    required String usage,
    required String usageEg,
    required String usageEgChinese,
  })  : _usage = usage,
        _usageEg = usageEg,
        _usageEgChinese = usageEgChinese;

  String get usage => _usage;
  set usage(String value) {
    _usage = value;
  }

  String get usageEg => _usageEg;
  set usageEg(String value) {
    _usageEg = value;
  }

  String get usageEgChinese => _usageEgChinese;
  set usageEgChinese(String value) {
    _usageEgChinese = value;
  }
}

class Mean {
  String _mean;
  String _meanEg;
  String _meanEgChinese;

  Mean({
    required String mean,
    required String meanEg,
    required String meanEgChinese,
  })  : _mean = mean,
        _meanEg = meanEg,
        _meanEgChinese = meanEgChinese;

  String get mean => _mean;
  set mean(String value) {
    _mean = value;
  }

  String get meanEg => _meanEg;
  set meanEg(String value) {
    _meanEg = value;
  }

  String get meanEgChinese => _meanEgChinese;
  set meanEgChinese(String value) {
    _meanEgChinese = value;
  }
}

class Collocation {
  String _collocation;
  String _collocationEg;
  String _collocationEgChinese;

  Collocation({
    required String collocation,
    required String collocationEg,
    required String collocationEgChinese,
  })  : _collocation = collocation,
        _collocationEg = collocationEg,
        _collocationEgChinese = collocationEgChinese;

  String get collocation => _collocation;
  set collocation(String value) {
    _collocation = value;
  }

  String get collocationEg => _collocationEg;
  set collocationEg(String value) {
    _collocationEg = value;
  }

  String get collocationEgChinese => _collocationEgChinese;
  set collocationEgChinese(String value) {
    _collocationEgChinese = value;
  }
}
/*

class Usage {
  final String usage;
  final String usageEg;
  final String usageEgChinese;

  Usage({
    required this.usage,
    required this.usageEg,
    required this.usageEgChinese,
  });
}

class Mean {
  final String mean;
  final String meanEg;
  final String meanEgChinese;

  Mean({
    required this.mean,
    required this.meanEg,
    required this.meanEgChinese,
  });
}

class Collocation {
  final String collocation;
  final String collocationEg;
  final String collocationEgChinese;

  Collocation({
    required this.collocation,
    required this.collocationEg,
    required this.collocationEgChinese,
  });
}*/
