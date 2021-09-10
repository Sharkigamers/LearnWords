import 'package:langage_trainer/common/class/json_class.dart';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'package:langage_trainer/common/navigation_bar/navigation_bar.dart';
import 'package:langage_trainer/pages/question/question_page.dart';
import 'package:langage_trainer/pages/update_content/update_content_page.dart';

class HomePage extends StatefulWidget {
  final List<Map<String, dynamic>>? words;

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

  List<Map<String, dynamic>>? words;
  List<Map<String, dynamic>>? _activeWords;

  @override
  void initState() {
    if (widget.words != null)
      words = words = widget.words!.map((element) => element).toList();
    _bodyList = [
      UpdateContentPage(
        words: widget.words,
        updateWords: _sortActiveWords,
        writeToJson: JsonClass().writeToJsonVocabulary,
      ),
      QuestionPage(
        words: _activeWords,
        score: _score,
        updateScore: _updateScore,
      ),
    ];

    _sortActiveWords(widget.words);
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

  _updateIndexBody(int index) {
    setState(() {
      _indexBody = index;
    });
  }

  _updateScore(String type, Map<String, dynamic> content) {
    if (_score != null && _score!.containsKey(type))
      (_score![type])!.add(content);
  }

  _sortActiveWords(List<Map<String, dynamic>>? newWords) {
    if (newWords != null) {
      setState(() {
        words = newWords.map((element) => element).toList();
        _activeWords = newWords.expand((element) =>
        [if (element.containsKey('active') && element['active']) element]
        ).toList();
        _bodyList[1] = QuestionPage(
          words: _activeWords,
          score: _score,
          updateScore: _updateScore,
        );
      });
      //JsonClass().writeToJsonVocabulary(words);
    }
  }
}
