import 'package:flutter/material.dart';
import 'package:langage_trainer/common/text_box/vocabulary_text_box.dart';

class TypePage extends StatefulWidget {
  final List<Map<String, dynamic>>? contentScore;
  final String? type;
  final Color? color;

  const TypePage({
    @required this.contentScore,
    @required this.type,
    @required this.color,
    Key? key
  }) : super(key: key);

  @override
  _TypePageState createState() => _TypePageState();
}

class _TypePageState extends State<TypePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size(double.infinity, 45),
        child: AppBar(
          backgroundColor: widget.color,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back),
            color: Colors.white,
            iconSize: 22,
          ),
          title: Text(
            widget.type != null ? widget.type!.toUpperCase() : '',
            style: const TextStyle(
                color: Colors.white,
                fontSize: 18
            ),
          ),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.black,
        child: SingleChildScrollView(
            child: listContent()
        ),
      ),
    );
  }

  Container listContent() => Container(
    child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widget.contentScore != null ? widget.contentScore!.map((content) =>
          Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(
                vertical: 15,
                horizontal: 50
            ),
            margin: const EdgeInsets.only(bottom: 5),
            decoration: BoxDecoration(
              color: const Color.fromARGB(200, 40, 40, 40),
              borderRadius: BorderRadius.circular(8),
            ),
            child: VocabularyTextBox(
              vocabularyContent: content,
              alignmentColumn: CrossAxisAlignment.center,
            )
          )).toList() : []
    )
  );
}
