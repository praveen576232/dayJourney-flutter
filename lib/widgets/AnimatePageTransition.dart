import 'package:flutter/material.dart';

class AnimatedPageTransition extends PageRouteBuilder {
  Widget screen;
  Alignment alignment;
  
  AnimatedPageTransition({@required this.screen,@required this.alignment})
      : super(
            transitionDuration: Duration(milliseconds: 300),
            transitionsBuilder: (context, animation1, animation2, child) {
              return ScaleTransition(
                alignment: alignment,
                scale: animation1,
                child: child,
              );
            },
            pageBuilder: (context, animation1, animation2) {
              return screen;
            });
}
