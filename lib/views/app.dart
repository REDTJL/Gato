import 'package:flutter/material.dart';
import 'package:gato/views/home.dart';
import 'package:gato/config/config.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "the puss in boots",
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blue,
        primaryColor: Colors.white,
      ),
      home: Home(),
    );
  }
}
