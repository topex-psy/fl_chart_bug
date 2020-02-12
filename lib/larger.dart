import 'package:flutter/material.dart';
import 'grafik_uang_makan.dart';

class LargerView extends StatefulWidget {
  @override
  _LargerViewState createState() => _LargerViewState();
}

class _LargerViewState extends State<LargerView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Larger View"),),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.all(20),
        child: GrafikUangMakan(barWidth: 20,)
      )
    );
  }
}