import 'dart:convert';

import 'package:langage_trainer/common/class/json_class.dart';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'package:langage_trainer/common/navigation_bar/navigation_bar.dart';
import 'package:langage_trainer/pages/question/question_page.dart';
import 'package:langage_trainer/pages/update_content/update_content_page.dart';

class HomePage extends StatefulWidget {
  final Map<String, List<Map<String, dynamic>>>? words;

  const HomePage({
    @required this.words,
    Key? key
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const List<Map<String, Icon>> _icons = [
    {
      'released': Icon(
        Icons.home_outlined,
        color: Colors.white,
      ),
      'pressed': Icon(
        Icons.home,
        color: Colors.white,
      ),
    },
    {
      'released': Icon(
        Icons.bookmark_border,
        color: Colors.white,
      ),
      'pressed': Icon(
        Icons.bookmark,
        color: Colors.white,
      ),
    }
  ];

  List<Widget> _bodyList = [];
  int _indexBody = 0;

  Map<String, List<Map<String, dynamic>>>? _score = {
    'good': [],
    "pass": [],
    'wrong': []
  };

  Map<String, List<Map<String, dynamic>>>? words;
  List<Map<String, dynamic>>? _activeWords;

  @override
  void initState() {
    if (widget.words != null)
      words = (jsonDecode(jsonEncode(widget.words!)) as Map).map((key, value) =>
        MapEntry(key, (value as List).map((e) => e as Map<String, dynamic>).toList())
      );
    _sortAndUpdateWords(widget.words);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      bottomNavigationBar: NavigationBar(
        icons: _icons,
        indexBody: _indexBody,
        updateIndexBody: _updateIndexBody,
      ),
      body: _bodyList[_indexBody],
    );
  }

  void _updateIndexBody(int index) {
    setState(() {
      _indexBody = index;
    });
  }

  void _updateScore(String type, Map<String, dynamic> content) {
    if (_score != null && _score!.containsKey(type))
      (_score![type])!.add(content);
  }

  void _sortAndUpdateWords(Map<String, List<Map<String, dynamic>>>? newWords) {
    if (newWords != null) {
      setState(() {
        words = (jsonDecode(jsonEncode(newWords)) as Map).map((key, value) =>
            MapEntry(key, (value as List).map((e) => e as Map<String, dynamic>).toList())
        );
        _activeWords = [];
        for (int i = 0; i < newWords.length; ++i) {
          _activeWords = [
            ..._activeWords!,
            ...newWords[newWords.keys.elementAt(i)]!.expand((element) =>
              [
                if (element.containsKey('active') &&
                    element['active']) element
              ]
              ).toList()].toSet().toList();
        }

        _bodyList = [
          QuestionPage(
            allWords: words,
            words: _activeWords,
            score: _score,
            updateScore: _updateScore,
            updateWords: _sortAndUpdateWords,
            writeToJson: JsonClass().writeToJsonVocabulary,
          ),
          UpdateContentPage(
            words: words,
            updateWords: _sortAndUpdateWords,
            writeToJson: JsonClass().writeToJsonVocabulary,
          ),
        ];
      });
    }
  }
}
