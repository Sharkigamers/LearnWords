import 'package:flutter/material.dart';

Route defaultNavigatorTransition(dynamic targetPage) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => targetPage,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      Offset begin = Offset(0.0, 1.0);
      Offset end = Offset.zero;
      Cubic curve = Curves.ease;

      Animatable<Offset> tween = Tween(
          begin: begin,
          end: end
      ).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
