import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

import 'package:langage_trainer/common/animations/pageTransition/navigatorTransition.dart';
import 'package:langage_trainer/common/text_box/vocabulary_text_box.dart';
import 'package:langage_trainer/pages/update_content/vocabulary_modifier_page.dart';

class UpdateContentPage extends StatefulWidget {
  final List<Map<String, dynamic>>? words;

  final updateWords;
  final writeToJson;

  const UpdateContentPage({
    @required this.words,
    @required this.updateWords,
    this.writeToJson,
    Key? key
  }) : super(key: key);

  @override
  _UpdateContentPageState createState() => _UpdateContentPageState();
}

class _UpdateContentPageState extends State<UpdateContentPage> {
  bool _hasModified = false;

  List<Map<String, dynamic>> words = [];
  List<Map<String, dynamic>> _oldWords = [];

  @override
  void initState() {
    if (widget.words != null) {
      words = widget.words!;
      _oldWords = (jsonDecode(jsonEncode(widget.words!)) as List)
          .map((e) => e as Map<String, dynamic>).toList();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: _appBar(),
        body: TabBarView(
          children: [
            _visualisation(),
            Icon(Icons.directions_transit),
          ],
        ),
      ),
    );
  }

  PreferredSize _appBar() => PreferredSize(
    preferredSize: const Size(double.infinity, 90),
    child: AppBar(
      backgroundColor: Colors.green,
      title: const Text(
        'Update Words',
        style: const TextStyle(
            color: Colors.white
        ),
      ),
      bottom: const TabBar(
        tabs: [
          Tab(
            icon: Icon(
              Icons.menu_book,
            )
          ),
          Tab(
            icon: Icon(
              Icons.edit,
            ),
          ),
        ],
      ),
      actions: _hasModified ? [
        IconButton(
          onPressed: () {
            setState(() {
              _hasModified = false;
              words = (jsonDecode(jsonEncode(_oldWords)) as List)
                  .map((e) => e as Map<String, dynamic>).toList();
            });
          },
          icon: Icon(
            Icons.clear,
            color: Colors.red,
          ),
        ),
        IconButton(
          onPressed: () {
            setState(() {
              _hasModified = false;
              _oldWords = (jsonDecode(jsonEncode(words)) as List)
                  .map((e) => e as Map<String, dynamic>).toList();
            });
            widget.updateWords(_oldWords);
            _writeToJson(_oldWords);
          },
          icon: Icon(
            Icons.check,
            color: Colors.white,
          )
        ),
      ] : null,
    ),
  );

  Container _visualisation() => Container(
    color: Colors.black,
    child: SingleChildScrollView(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: words.length,
        itemBuilder: (BuildContext build, int i) => Container(
          margin: EdgeInsets.only(bottom: 5),
          decoration: BoxDecoration(
            color: const Color.fromARGB(200, 40, 40, 40),
            borderRadius: BorderRadius.circular(8),
          ),
          child: ListTile(
            onTap: () {
              Navigator.of(context).push(defaultNavigatorTransition(
                  VocabularyModifierPage(
                    words: words[i],
                    updateValues: _updateVocabulary,
                  )
              ));
            },
            title: VocabularyTextBox(
              vocabularyContent: words[i],
            ),
            trailing: _updateModification(i),
          ),
        )
      ),
    ),
  );

  Container _updateModification(int i) => Container(
    child: Wrap(
      children: [
        IconButton(
          onPressed: () {
            if (words[i].containsKey('active'))
              setState(() {
                _hasModified = true;
                words[i]['active'] = !words[i]['active'];
              });
          },
          icon: Icon(
            Icons.desktop_access_disabled,
            color: words[i].containsKey('active') &&
                words[i]['active'] ? Colors.white : Colors.blue,
          ),
        ),
        IconButton(
          onPressed: () {
            setState(() {
              _hasModified = true;
              words.removeAt(i);
            });
          },
          icon: Icon(
            Icons.clear,
            color: Colors.red,
          ),
        ),
      ],
    )
  );

  void _updateVocabulary(
    Map<String, dynamic> oldValue,
    Map<String, dynamic> newValue,
  ) {
    for (int i = 0; i < words.length; ++i) {
      if (DeepCollectionEquality().equals(oldValue, words[i])) {
        if (mounted)
          setState(() {
            _hasModified = true;
            words[i].update(
              oldValue.keys.elementAt(0),
              (existingValue) => newValue.values.elementAt(0),
              ifAbsent: () => newValue.values.elementAt(0),
            );
            words[i].update(
              oldValue.keys.elementAt(1),
              (existingValue) => newValue.values.elementAt(1),
              ifAbsent: () => newValue.values.elementAt(1),
            );
          });
        break;
      }
    }
  }

  void _writeToJson(List<Map<String, dynamic>> oldWords) async {
    if (widget.writeToJson != null)
      await widget.writeToJson(oldWords);
  }
}
