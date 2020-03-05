import 'package:calendar_view/pages/home.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // fontFamily: "Yantramanav",
        primarySwatch: Colors.indigo,
        accentColor: Colors.redAccent,
      ),
      darkTheme: ThemeData(
        // fontFamily: "Yantramanav",
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        accentColor: Colors.redAccent,
      ),
      themeMode: ThemeMode.system,
      home: HomePage(title: 'Calendar'),
      debugShowCheckedModeBanner: false,
    );
  }
}
