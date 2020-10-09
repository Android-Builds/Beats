import 'package:Beats/style/appColors.dart';
import 'package:flare_flutter/flare.dart';
import 'package:flare_dart/math/mat2d.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_controller.dart';
import 'package:flutter/material.dart';

class Vis extends StatefulWidget {
  const Vis({Key key}) : super(key: key);
  @override
  _VisState createState() => _VisState();
}

class _VisState extends State<Vis> with FlareController {
  @override
  void initialize(FlutterActorArtboard artboard) {}

  @override
  void setViewTransform(Mat2D viewTransform) {}

  @override
  bool advance(FlutterActorArtboard artboard, double elapsed) {
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return FlareActor(
      "assets/visualizer.flr",
      alignment: Alignment.center,
      isPaused: false,
      fit: BoxFit.cover,
      animation: 'Alarm',
      controller: this,
      color: accent,
    );
  }
}
