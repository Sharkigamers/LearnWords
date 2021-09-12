import 'package:flutter/material.dart';
import 'package:langage_trainer/common/class/json_class.dart';
import 'package:langage_trainer/pages/home/home_page.dart';

import 'dart:convert';

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

  @override
  void initState() {
    _readJson();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _words != null ? HomePage(
      words: _words
    ) : const Scaffold(
      backgroundColor: Colors.green,
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
}
