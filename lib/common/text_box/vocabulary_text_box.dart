import 'package:flutter/material.dart';

class VocabularyTextBox extends StatefulWidget {
  final Map<String, dynamic>? vocabularyContent;

  final CrossAxisAlignment alignmentColumn;

  const VocabularyTextBox({
    @required this.vocabularyContent,
    this.alignmentColumn = CrossAxisAlignment.start,
    Key? key
  }) : super(key: key);

  @override
  _VocabularyTextBoxState createState() => _VocabularyTextBoxState();
}

class _VocabularyTextBoxState extends State<VocabularyTextBox> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Container(
    child: Column(
      crossAxisAlignment: widget.alignmentColumn,
      children: [
        _vocabularyText(0),
        const SizedBox(height: 5),
        _vocabularyText(1)
      ],
    ),
  );

  Container _vocabularyText(int index) => Container(
    child: SelectableText.rich(
        TextSpan(
            children: <TextSpan>[
              TextSpan(
                  text: widget.vocabularyContent != null &&
                  widget.vocabularyContent!.length >= index + 1 ?
                  '${widget.vocabularyContent!.keys.elementAt(index)}: ' : '',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16
                  )
              ),
              TextSpan(
                  text: widget.vocabularyContent != null &&
                  widget.vocabularyContent!.length >= index + 1 ?
                  '${widget.vocabularyContent!.values.elementAt(index)}' : '',
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16
                  )
              ),
            ]
        )
    ),
  );
}
