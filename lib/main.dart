import 'package:flutter/material.dart';
import 'package:sq2_flutter/screen/todaymemo.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xff365172),
        accentColor: Color(0xfff5f5dc),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: TodayMemo(
        title: '메모습관 만들기',
      ),
    );
  }
}
