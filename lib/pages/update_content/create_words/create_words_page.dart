import 'package:flutter/material.dart';

import 'package:langage_trainer/common/textfield/default_textfield.dart';

class CreateWordsPage extends StatefulWidget {
  final createContent;

  const CreateWordsPage({
    @required this.createContent,
    Key? key
  }) : super(key: key);

  @override
  _CreateWordsPageState createState() => _CreateWordsPageState();
}

class _CreateWordsPageState extends State<CreateWordsPage> {
  TextEditingController _categoryController = TextEditingController();
  TextEditingController _firstLanguageController = TextEditingController();
  TextEditingController _separatorController = TextEditingController();
  TextEditingController _secondLanguageController = TextEditingController();
  TextEditingController _wordsController = TextEditingController();

  String? _creationError;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_creationError != null)
                  _errorMessage(),
                _allDescriptiveTextfield(),
                _createButton()
              ],
            ),
          )
      ),
    );
  }

  Container _errorMessage() => Container(
    margin: EdgeInsets.symmetric(
      vertical: 5,
      horizontal: 10
    ),
    child: Center(
      child: SelectableText(
        _creationError!,
        style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
            fontSize: 16
        ),
        textAlign: TextAlign.center,
      ),
    ),
  );

  Container _allDescriptiveTextfield() => Container(
    child: Column(
      children: [
        _descriptiveTextfield(
            'Category',
            'Set a category',
            _categoryController,
            1
        ),
        _descriptiveTextfield(
            'First language',
            'Set a first language',
            _firstLanguageController,
            1
        ),
        _descriptiveTextfield(
            'Separator',
            'Set a separator',
            _separatorController,
            1
        ),
        _descriptiveTextfield(
            'Second language',
            'Set a a second language',
            _secondLanguageController,
            1
        ),
        _descriptiveTextfield(
            'Words',
            '{word lang 1}{separator}{word lang 2}',
            _wordsController,
            null
        ),
      ],
    ),
  );

  Container _descriptiveTextfield(
      String title,
      String hintText,
      TextEditingController controller,
      int? maxLine,
      ) => Container(
    margin: EdgeInsets.only(bottom: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(bottom: 5),
          child: Text(
            title,
            style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold
            ),
          ),
        ),
        DefaultTextField(
          textEditingController: controller,
          hintText: hintText,
          maxLine: maxLine,
        )
      ],
    ),
  );

  Container _createButton() => Container(
    child: ElevatedButton(
      onPressed: () {
        if (FocusScope.of(context).hasFocus)
          FocusScope.of(context).unfocus();
        _createContent();
      },
      child: Text('Create'),
      style: ElevatedButton.styleFrom(
          minimumSize: Size(double.infinity, 40),
          primary: Colors.green
      ),
    ),
  );

  void _createContent() {
    _creationError = null;
    if (_firstLanguageController.text == '' ||
        _secondLanguageController.text == '' ||
        _separatorController.text == '' ||
        _categoryController.text == '' ||
        _wordsController.text == ''
    )
      setState(() {
        _creationError = 'Unfilled text field';
      });
    else if (_firstLanguageController.text == _secondLanguageController.text)
      setState(() {
        _creationError = 'First language and Second language text field can\'t '
        'handle the same value';
      });
    if (_creationError == null) {
      List<String> _newWords = _wordsController.text.split('\n');
      Map<String, List<Map<String, dynamic>>> parsedNewWords = {};
      parsedNewWords[_categoryController.text] = [];
      for (int i = 0; i < _newWords.length; ++i) {
        List<String> parsedString = _newWords[i].split(_separatorController.text);
        if (parsedString.length == 2 &&
          parsedString[0] != '' && parsedString[1] != '' &&
          parsedNewWords[_categoryController.text] != null
        ) {
          parsedNewWords[_categoryController.text]!.add(
              {
                _firstLanguageController.text: parsedString[0],
                _secondLanguageController.text: parsedString[1],
                'active': true,
              }
          );
        } else {
          setState(() {
            _creationError = 'Missing a separator in the words text field';
          });
          break;
        }
      }
      if (_creationError == null) {
        widget.createContent(parsedNewWords);
        _wordsController.clear();
      }
    }
  }
}
