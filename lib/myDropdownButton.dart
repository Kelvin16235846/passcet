import 'package:flutter/material.dart';

class MyDropdownButton extends StatefulWidget{
    const MyDropdownButton( {required this.value,required this.items,required this.onchange,super.key,});
  final List<DropdownMenuItem<String>>  items;
  final void Function(String val) onchange;
  final String value;
  @override
  State<StatefulWidget> createState() {
     return MyDropdownButtonState();
  }

}
class MyDropdownButtonState extends State<MyDropdownButton>{
  String _value="初始状态";
  @override
  Widget build(BuildContext context) {
    return DropdownButton(value: this._value, items:this.widget.items
      , onChanged: (value) {
    setState(() {
    this._value=value!;
    this.widget.onchange(value!);
    });
    });
  }
  @override
  void initState() {
     _value=widget.value;
    super.initState();
  }

}