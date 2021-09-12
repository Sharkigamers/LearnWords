import 'package:flutter/material.dart';

import 'dart:convert';

import 'package:langage_trainer/common/class/json_class.dart';
import 'package:langage_trainer/pages/home/home_page.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Loader(),
    )
  );
}

class Loader extends StatefulWidget {
  const Loader({Key? key}) : super(key: key);

  @override
  _LoaderState createState() => _LoaderState();
}

class _LoaderState extends State<Loader> {
  Map<String, List<Map<String, dynamic>>>? _words;
  bool _isLoaded = false;

  @override
  void initState() {
    _readJson();
    _timeSplashScreen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoaded && _words != null ? HomePage(
      words: _words
    ) : Scaffold(
      backgroundColor: Colors.green,
      body: Center(
        child: Image.asset(
          'assets/images/splash_screen/splash_screen_logo.png',
          width: 300,
        ),
      )
    );
  }

  Future<void> _readJson() async {
    String? words = await JsonClass().readJsonVocabulary();
    if (words == null) {
      final bool result = await JsonClass().writeToJsonVocabulary({});
      if (result)
        words = await JsonClass().readJsonVocabulary();
      if (words != null)
        _words = (jsonDecode(words) as Map).map((key, value) =>
            MapEntry(key, (value as List).map((e) => e as Map<String, dynamic>).toList())
        );
    } else
      _words = (jsonDecode(words) as Map).map((key, value) =>
          MapEntry(key, (value as List).map((e) => e as Map<String, dynamic>).toList())
      );
    setState(() {});
  }

  Future _timeSplashScreen() async {
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      _isLoaded = true;
    });
  }
}
