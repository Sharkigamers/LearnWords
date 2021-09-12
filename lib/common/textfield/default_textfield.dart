import 'package:flutter/material.dart';

class DefaultTextField extends StatefulWidget {
  final bool? enable;
  final TextEditingController? textEditingController;
  final String? hintText;
  final int? maxLine;

  final getOnChangeValue;

  const DefaultTextField({
    this.enable = true,
    this.textEditingController,
    this.hintText,
    this.getOnChangeValue,
    this.maxLine = 1,
    Key? key
  }) : super(key: key);

  @override
  _DefaultTextFieldState createState() => _DefaultTextFieldState();
}

class _DefaultTextFieldState extends State<DefaultTextField> {
  String _currentValue = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextField(
        onChanged: (value) {
          setState(() {
            _currentValue = value;
          });
          if (widget.getOnChangeValue != null)
            widget.getOnChangeValue(value);
        },
        maxLines: widget.maxLine,
        enabled: widget.enable,
        controller: widget.textEditingController,
        style: const TextStyle(
            color: Colors.white
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          filled: true,
          fillColor: const Color.fromARGB(255, 100, 100, 100),
          contentPadding: const EdgeInsets.only(
              left: 14.0,
              bottom: 6.0,
              top: 8.0
          ),
          hintText: widget.hintText,
          hintStyle: const TextStyle(color: Colors.white),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          suffixIcon: IconButton(
            onPressed: () {
              if (widget.getOnChangeValue != null)
                widget.getOnChangeValue('');
              if (widget.textEditingController != null)
                widget.textEditingController!.clear();
              setState(() {
                _currentValue = '';
              });
            },
            icon: Icon(
              Icons.clear,
              color: _currentValue != '' ? Colors.red : Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
