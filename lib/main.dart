import 'package:flutter/material.dart';
import 'package:wallpaper/wall_secreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Wallpaper',
      theme: ThemeData(
      ),
      home: WallScreen(),
    );
  }
}

