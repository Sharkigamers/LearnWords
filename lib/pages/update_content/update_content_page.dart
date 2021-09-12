import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

import 'package:langage_trainer/common/animations/pageTransition/navigatorTransition.dart';
import 'package:langage_trainer/common/class/utils.dart';
import 'package:langage_trainer/common/text_box/vocabulary_text_box.dart';
import 'package:langage_trainer/common/textfield/default_textfield.dart';
import 'package:langage_trainer/pages/update_content/create_words/create_words_page.dart';
import 'package:langage_trainer/pages/update_content/vocabulary_modifier_page.dart';

class UpdateContentPage extends StatefulWidget {
  final Map<String, List<Map<String, dynamic>>>? words;

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
  static const List<Tab> _tabs = [
    const Tab(
        icon: const Icon(
          Icons.menu_book,
        )
    ),
    const Tab(
      icon: const Icon(
        Icons.edit,
      ),
    ),
  ];

  TextEditingController _searchCategoryController = TextEditingController();
  String _searchValue = '';

  bool _hasModified = false;

  Map<String, List<Map<String, dynamic>>> words = {};
  Map<String, List<Map<String, dynamic>>> _oldWords = {};

  @override
  void dispose() {
    print(widget.words);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (widget.words != null) {
      words = (jsonDecode(jsonEncode(widget.words!)) as Map).map((key, value) =>
          MapEntry(key, (value as List).map((e) => e as Map<String, dynamic>).toList())
      );
      _oldWords = (jsonDecode(jsonEncode(words)) as Map).map((key, value) =>
          MapEntry(key, (value as List).map((e) => e as Map<String, dynamic>).toList())
      );
    }
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
            _updateContentPage(),
            CreateWordsPage(createContent: _createContent)
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
        tabs: _tabs
      ),
      actions: _actions(),
    ),
  );

  List<Widget>? _actions() {
    if (_hasModified)
      return [
        IconButton(
          onPressed: () {
            setState(() {
              _hasModified = false;
              words = (jsonDecode(jsonEncode(_oldWords)) as Map).map((key, value) =>
                  MapEntry(key, (value as List).map((e) => e as Map<String, dynamic>).toList())
              );
            });
          },
          icon: const Icon(
            Icons.clear,
            color: Colors.red,
          ),
        ),
        IconButton(
            onPressed: () {
              words.removeWhere((String key, List<Map<String, dynamic>> value) =>
                value.length == 0
              );
              setState(() {
                _hasModified = false;
                Utils().clearDuplicate(words);
                _oldWords = (jsonDecode(jsonEncode(words)) as Map).map((key, value) =>
                    MapEntry(key, (value as List).map((e) => e as Map<String, dynamic>).toList())
                );
              });
              widget.updateWords(_oldWords);
              _writeToJson(_oldWords);
            },
            icon: const Icon(
              Icons.check,
              color: Colors.white,
            )
        ),
      ];
  }

  Container _updateContentPage() => Container(
    child: ListView(
      children: [
        Container(
          margin: EdgeInsets.all(10),
          child: DefaultTextField(
              textEditingController: _searchCategoryController,
              hintText: 'Filter by category',
              getOnChangeValue: _getOnChangeValue
          ),
        ),
        _visualisation()
      ],
    ),
  );

  Container _visualisation() => Container(
    child: ListView.builder(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      itemCount: words.length,
      itemBuilder: (BuildContext build, int i) {
        if (words.keys.elementAt(i).startsWith(_searchValue))
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.symmetric(
                    vertical: 5,
                    horizontal: 15
                ),
                child: SelectableText(
                  words.keys.elementAt(i),
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),
              categoryBoxes(i),
          ],
        );
        return Container();
      }
    ),
  );

  Container categoryBoxes(int i) => Container(
    child: Column(
        children: words[words.keys.elementAt(i)] != null &&
            words[words.keys.elementAt(i)]!.length > 0 ?
        words[words.keys.elementAt(i)]!.mapIndexed((index, element) =>
            Container(
              margin: const EdgeInsets.only(bottom: 5),
              decoration: BoxDecoration(
                color: const Color.fromARGB(200, 40, 40, 40),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListTile(
                onTap: () {
                  Navigator.of(context).push(defaultNavigatorTransition(
                      VocabularyModifierPage(
                        words: element,
                        updateValues: _updateVocabulary,
                      )
                  ));
                },
                title: VocabularyTextBox(
                  vocabularyContent: element,
                ),
                trailing: _updateModification(
                    words[words.keys.elementAt(i)]!,
                    index
                ),
              ),
            )
        ).toList() : []
    ),
  );

  Container _updateModification(
    List<Map<String, dynamic>> content,
    int i
  ) => Container(
    child: Wrap(
      children: [
        IconButton(
          onPressed: () {
            if (content[i].containsKey('active'))
              setState(() {
                _hasModified = true;
                content[i]['active'] = !content[i]['active'];
              });
          },
          icon: Icon(
            Icons.desktop_access_disabled,
            color: content[i].containsKey('active') &&
                content[i]['active'] ? Colors.white : Colors.blue,
          ),
        ),
        IconButton(
          onPressed: () {
            setState(() {
              _hasModified = true;
              content.removeAt(i);
            });
          },
          icon: const Icon(
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
    for (int i = 0; i < words.length; ++i)
      if (words[words.keys.elementAt(i)] != null)
        for (int j = 0; j < words[words.keys.elementAt(i)]!.length; ++j) {
          if (words[words.keys.elementAt(i)] != null &&
            DeepCollectionEquality().equals(
              oldValue,
              words[words.keys.elementAt(i)]![j])
          ) {
            if (mounted)
              setState(() {
                _hasModified = true;
                words[words.keys.elementAt(i)]![j].update(
                  oldValue.keys.elementAt(0),
                      (existingValue) => newValue.values.elementAt(0),
                  ifAbsent: () => newValue.values.elementAt(0),
                );
                words[words.keys.elementAt(i)]![j].update(
                  oldValue.keys.elementAt(1),
                      (existingValue) => newValue.values.elementAt(1),
                  ifAbsent: () => newValue.values.elementAt(1),
                );
              });
            break;
          }
        }
  }

  void _writeToJson(Map<String, List<Map<String, dynamic>>> oldWords) async {
    if (widget.writeToJson != null) {
      await widget.writeToJson(oldWords);
    }
  }

  void _getOnChangeValue(String value) {
    setState(() {
      _searchValue = value;
    });
  }

  void _createContent(Map<String, List<Map<String, dynamic>>> contentToAdd) {
    if (words.containsKey(contentToAdd.keys.first) &&
      words[contentToAdd.keys.first] != null &&
      contentToAdd[contentToAdd.keys.first] != null &&
      contentToAdd[contentToAdd.keys.first]!.length > 0
    ) {
      words[contentToAdd.keys.first] = [
        ...words[contentToAdd.keys.first]!,
        ...contentToAdd[contentToAdd.keys.first]!
      ];
      _hasModified = true;
    } else if (contentToAdd[contentToAdd.keys.first] != null) {
      words[contentToAdd.keys.first] = contentToAdd[contentToAdd.keys.first]!;
      _hasModified = true;
    }
    setState(() {});
  }
}
