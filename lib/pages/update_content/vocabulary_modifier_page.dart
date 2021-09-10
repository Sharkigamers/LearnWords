import 'package:flutter/material.dart';
import 'package:langage_trainer/common/textfield/default_textfield.dart';

class VocabularyModifierPage extends StatefulWidget {
  final Map<String, dynamic>? words;

  final updateValues;

  const VocabularyModifierPage({
    @required this.words,
    @required this.updateValues,
    Key? key
  }) : super(key: key);

  @override
  _VocabularyModifierPageState createState() => _VocabularyModifierPageState();
}

class _VocabularyModifierPageState extends State<VocabularyModifierPage> {
  Map<String, dynamic> words = {};

  TextEditingController _firstVocabularyController = TextEditingController();
  TextEditingController _secondVocabularyController = TextEditingController();

  @override
  void initState() {
    if (widget.words != null) {
      words = widget.words!;
      _firstVocabularyController = TextEditingController(text: words.values.elementAt(0));
      _secondVocabularyController = TextEditingController(text: words.values.elementAt(1));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: _appBar(),
        body: words.length > 0 ? GestureDetector(
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
                    child: _modifier(),
                  )
              ),
            )
        ) : null
    );
  }

  PreferredSize _appBar() => PreferredSize(
    preferredSize: Size(double.infinity, 45),
    child: AppBar(
      backgroundColor: Colors.green,
      leading: IconButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        icon: Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
        iconSize: 22,
      ),
      title: Text(
        'Value Modifier',
        style: TextStyle(
          color: Colors.white,
          fontSize: 18
        ),
      ),
    ),
  );

  Container _modifier() => Container(
    child: Column(
      children: [
        _textfieldBox(
          words.keys.elementAt(0),
          _firstVocabularyController
        ),
        _textfieldBox(
          words.keys.elementAt(1),
          _secondVocabularyController
        ),
        _validationButton(),
      ],
    ),
  );

  Container _textfieldBox(
    String title,
    TextEditingController controller
  ) => Container(
    width: double.infinity,
    margin: EdgeInsets.symmetric(vertical: 10),
    padding: EdgeInsets.only(top: 10),
    decoration: BoxDecoration(
      color: const Color.fromARGB(200, 40, 40, 40),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 10, right: 10, bottom: 5),
          child: SelectableText(
            title,
            style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 5),
          child: DefaultTextField(
            hintText: 'Set a value',
            textEditingController: controller,
          ),
        )
      ],
    ),
  );

  Container _validationButton() => Container(
    margin: EdgeInsets.symmetric(vertical: 5),
    child: ElevatedButton(
        onPressed: () {
          widget.updateValues(
            words,
            {
              words.keys.elementAt(0): _firstVocabularyController.text,
              words.keys.elementAt(1): _secondVocabularyController.text
            }
          );
          Navigator.of(context).pop();
        },
        child: const Text(
          'Validation',
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
}
