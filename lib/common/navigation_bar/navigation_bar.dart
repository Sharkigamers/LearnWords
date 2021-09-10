import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

class NavigationBar extends StatefulWidget {
  final List<Map<String, dynamic>>? icons;
  final int? indexBody;

  final updateIndexBody;

  const NavigationBar({
    @required this.icons,
    @required this.indexBody,
    this.updateIndexBody,
    Key? key
  }) : super(key: key);

  @override
  _NavigationBarState createState() => _NavigationBarState();
}

class _NavigationBarState extends State<NavigationBar> {
  int indexBody = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    indexBody = widget.indexBody != null ? widget.indexBody! : 0;
    return Container(
      color: Colors.green,
      height: 45,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: widget.icons != null ? widget.icons!.mapIndexed((index, element) => IconButton(
          onPressed: () {
            widget.updateIndexBody(index);
          },
          icon: indexBody != index && element['released'] != null ?
          element['released'] : element['pressed'] != null ? element['pressed']
              : null,
        )).toList()
        : [],
      ),
    );
  }
}
