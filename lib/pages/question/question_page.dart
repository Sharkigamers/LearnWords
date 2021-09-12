import 'dart:convert';

import 'package:flutter/material.dart';

import 'dart:math';
import 'package:flutter/services.dart';

import 'package:langage_trainer/common/animations/pageTransition/navigatorTransition.dart';
import 'package:langage_trainer/common/textfield/default_textfield.dart';

import 'package:langage_trainer/pages/question/type_page.dart';

class QuestionPage extends StatefulWidget {
  final Map<String, List<Map<String, dynamic>>>? allWords;
  final List<Map<String, dynamic>>? words;
  final Map<String, List<Map<String, dynamic>>>? score;

  final updateScore;
  final updateWords;
  final writeToJson;

  const QuestionPage({
    @required this.allWords,
    @required this.words,
    @required this.score,
    @required this.updateScore,
    @required this.updateWords,
    this.writeToJson,
    Key? key
  }) : super(key: key);

  @override
  _QuestionPageState createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  Random _random = Random();
  int _selectedRandomWord = 0;
  int _selectedRandomTranslation = 0;

  bool? _responseValidation;

  TextEditingController _textEditingController = TextEditingController();

  TextEditingController _importController = TextEditingController();

  @override
  void initState() {
    _chargeNewWord();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _appBar(),
      body: GestureDetector(
        onTap: () {
          if (FocusScope.of(context).hasFocus)
            FocusScope.of(context).unfocus();
        },
        child: Center(
          child: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.symmetric(
                    vertical: 50,
                    horizontal: 20
                ),
                child: _mainContent()
              )
          ),
        )
      )
    );
  }

  PreferredSize _appBar() => PreferredSize(
    preferredSize: const Size(double.infinity, 45),
    child: AppBar(
      backgroundColor: Colors.green,
      title: const Text(
        'Learn Words',
        style: const TextStyle(
            color: Colors.white
        ),
      ),
      actions: [
        IconButton(
          onPressed: () => _export(),
          icon: Icon(Icons.upload_rounded)
        ),
        IconButton(
            onPressed: () => _import(),
            icon: Icon(Icons.download_rounded)
        ),
      ],
    ),
  );

  Container _mainContent() => Container(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        _textBox(
            widget.words != null && widget.words!.length > 0 &&
            _selectedRandomWord <= widget.words!.length ?
            widget.words![_selectedRandomWord].values.elementAt(_selectedRandomTranslation) :
            'No value has already been set'
        ),
        DefaultTextField(
          hintText: 'Write the translation',
          textEditingController: _textEditingController,
          enable: _responseValidation == null ? true : false,
        ),
        _validationButton(),
        if (_responseValidation != null)
          _response(),
        if (_responseValidation == null)
          _passButton(),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Container>[
              _scoreButton(
                  type: 'good',
                  color: Colors.green
              ),
              _scoreButton(
                  type: 'pass',
                  color: Colors.orange
              ),
              _scoreButton(
                  type: 'wrong',
                  color: Colors.red
              ),
            ],
          ),
        )
      ],
    ),
  );

  Container _textBox(String word) => Container(
    margin: const EdgeInsets.only(bottom: 10),
    width: MediaQuery.of(context).size.width,
    height: 50,
    decoration: BoxDecoration(
        color: const Color.fromARGB(200, 40, 40, 40),
        borderRadius: BorderRadius.circular(8)
    ),
    child: Center(
      child: SelectableText(
        word,
        style: const TextStyle(
            color: Colors.white,
            fontSize: 18
        ),
      ),
    )
  );

  Container _validationButton() => Container(
    margin: const EdgeInsets.only(bottom: 20),
    child: ElevatedButton(
        onPressed: () {
          _validation();
        },
        child: const Text(
          'Valider',
          style: const TextStyle(color: Colors.white),
        ),
        style: ElevatedButton.styleFrom(
            primary: Colors.green,
            minimumSize: Size(
                MediaQuery.of(context).size.width,
                40
            )
        )
    ),
  );

  Container _response() => Container(
    child: Column(
      children: <Container>[
        Container(
            margin: const EdgeInsets.only(bottom: 10),
            child: _responseValidation! ? const Text(
              'Good response',
              style: const TextStyle(
                  color: Colors.green,
                  fontSize: 18,
                  fontWeight: FontWeight.bold
              ),
            ) : const Text(
              'Wrong response',
              style: const TextStyle(
                  color: Colors.red,
                  fontSize: 18,
                  fontWeight: FontWeight.bold
              ),
            )
        ),
        _textBox(
          widget.words != null && _selectedRandomWord <= widget.words!.length ?
          _selectedRandomTranslation == 1 ?
          widget.words![_selectedRandomWord].values.elementAt(0) :
          widget.words![_selectedRandomWord].values.elementAt(1) : 'Error'
        ),
        _nextButton()
      ],
    ),
  );

  Container _nextButton() => Container(
    margin: const EdgeInsets.only(bottom: 20),
    child: ElevatedButton(
        onPressed: () {
          if (FocusScope.of(context).hasFocus)
            FocusScope.of(context).unfocus();
          _chargeNewWord();
          setState(() {
            _responseValidation = null;
          });
          _textEditingController.clear();
        },
        child: const Text(
          'Next',
          style: const TextStyle(color: Colors.white),
        ),
        style: ElevatedButton.styleFrom(
            primary: Colors.green,
            minimumSize: Size(
                MediaQuery.of(context).size.width,
                40
            )
        )
    ),
  );

  Container _passButton() => Container(
    margin: const EdgeInsets.only(bottom: 20),
    child: ElevatedButton(
        onPressed: () {
          if (widget.words!.length > 0)
            widget.updateScore('pass', widget.words![_selectedRandomWord]);
          if (FocusScope.of(context).hasFocus)
            FocusScope.of(context).unfocus();
          _chargeNewWord();
          setState(() {});
          _textEditingController.clear();
        },
        child: const Text(
          'Pass',
          style: const TextStyle(color: Colors.white),
        ),
        style: ElevatedButton.styleFrom(
            primary: Colors.orange,
            minimumSize: Size(
                MediaQuery.of(context).size.width,
                40
            )
        )
    ),
  );

  Container _scoreButton({
    String type = '',
    Color color = Colors.white,
  }) => Container(
    child: ElevatedButton(
      onPressed: () {
        Navigator.of(context).push(defaultNavigatorTransition(TypePage(
          contentScore: widget.score != null && widget.score!.containsKey(type) ?
          widget.score![type] : null,
          type: type,
          color: color,
        )));
      },
      child: Column(
        children: <Text>[
          Text(
            type.toUpperCase(),
            style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16
            ),
          ),
          Text(
            widget.score != null && widget.score!.containsKey(type) ?
            (widget.score![type])!.length.toString() : '0',
            style: const TextStyle(
                color: Colors.white,
                fontSize: 16
            ),
          ),
        ],
      ),
      style: ElevatedButton.styleFrom(
        primary: color,
        minimumSize: const Size(100, 50)
      ),
    ),
  );

  Future _import() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 40, 40, 40),
          title: Text(
            'Import',
            style: TextStyle(
                color: Colors.white
            ),
          ),
          content: SingleChildScrollView(
            child: DefaultTextField(
              textEditingController: _importController,
              hintText: 'Set configuration to import',
              maxLine: null,
            )
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
              style: ElevatedButton.styleFrom(
                  primary: Colors.red
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (widget.allWords != null) {
                  Map<String, List<Map<String, dynamic>>> tmp = {}..addAll(widget.allWords!)..addAll(
                    (jsonDecode(_importController.text) as Map).map((key, value) =>
                        MapEntry(key, (value as List).map((e) =>
                        e as Map<String, dynamic>).toList())));
                  if (widget.updateWords != null)
                    widget.updateWords(tmp);
                  if (widget.writeToJson != null)
                    widget.writeToJson(tmp);
                }
                Navigator.of(context).pop();
              },
              child: Text('Save'),
              style: ElevatedButton.styleFrom(
                  primary: Colors.green
              ),
            ),
          ],
        );
      },
    );
  }

  Future _export() {
    String textToExport = jsonEncode(widget.allWords).toString();
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 40, 40, 40),
          title: Text(
            'Export',
            style: TextStyle(
                color: Colors.white
            ),
          ),
          content: SingleChildScrollView(
            child: SelectableText(
              textToExport,
              style: TextStyle(
                  color: Colors.white
              ),
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
              style: ElevatedButton.styleFrom(
                  primary: Colors.red
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: textToExport));
                Navigator.of(context).pop();
              },
              child: Text('Copy'),
              style: ElevatedButton.styleFrom(
                  primary: Colors.green
              ),
            ),
          ],
        );
      },
    );
  }

  void _validation() {
    if (_textEditingController.text != '' && _responseValidation == null) {
      if (FocusScope.of(context).hasFocus)
        FocusScope.of(context).unfocus();
      if ((_selectedRandomTranslation == 1 &&
      widget.words![_selectedRandomWord].values.elementAt(0).toLowerCase() ==
      _textEditingController.text.toLowerCase()) ||
      (_selectedRandomTranslation == 0 && widget.words!.length > 0 &&
      widget.words![_selectedRandomWord].values.elementAt(1).toLowerCase() ==
      _textEditingController.text.toLowerCase())) {
        widget.updateScore('good', widget.words![_selectedRandomWord]);
        _responseValidation = true;
      } else if (widget.words!.length > 0) {
        widget.updateScore('wrong', widget.words![_selectedRandomWord]);
        _responseValidation = false;
      }
      setState(() {});
    }
  }

  void _chargeNewWord() {
    if (widget.words != null && widget.words!.length > 0)
      _selectedRandomWord = _random.nextInt(widget.words!.length);
    _selectedRandomTranslation = _random.nextInt(2);
  }
}
