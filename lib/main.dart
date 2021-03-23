import 'package:flutter/material.dart';
import 'package:wallpaper_app/Home.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,title: 'Tasveer',
      theme: ThemeData(
          primaryColor: Colors.black
      ),
      home: Home(),
    );
  }
}