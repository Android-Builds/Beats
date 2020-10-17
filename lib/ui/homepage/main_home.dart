import 'package:Beats/ui/homepage/homePage.dart';
import 'package:Beats/ui/player/widgets/slidingpanel.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Musify(),
        SlidingPanel(),
      ],
    );
  }
}
