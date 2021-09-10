import 'package:flutter/material.dart';

class DefaultTextField extends StatefulWidget {
  final bool? enable;
  final TextEditingController? textEditingController;
  final String? hintText;

  const DefaultTextField({
    this.enable = true,
    this.textEditingController,
    this.hintText,
    Key? key
  }) : super(key: key);

  @override
  _DefaultTextFieldState createState() => _DefaultTextFieldState();
}

class _DefaultTextFieldState extends State<DefaultTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextField(
        enabled: widget.enable,
        controller: widget.textEditingController,
        style: TextStyle(
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
          hintStyle: TextStyle(color: Colors.white),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
    );
  }
}
