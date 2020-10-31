import 'dart:async';

import 'package:Beats/model/player/player.dart';
import 'package:Beats/style/appColors.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class SongProgressIndicator extends StatefulWidget {
  @override
  _SongProgressIndicatorState createState() => _SongProgressIndicatorState();
}

class _SongProgressIndicatorState extends State<SongProgressIndicator> {
  Timer t;
  @override
  void initState() {
    super.initState();
    t = Timer.periodic(const Duration(milliseconds: 500), (Timer t) {
      setState(() {});
    });
  }

  getValue() {
    if (player == null) {
      return 0.0;
    } else {
      var state = player.playerState.processingState;
      if (player.playing)
        return (player.position.inSeconds / player.duration.inSeconds);
      if (state != ProcessingState.completed &&
          player.position != null &&
          player.duration != null)
        return (player.position.inSeconds / player.duration.inSeconds);
      else
        return 0.0;
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (t != null && t.isActive) {
      t.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      backgroundColor: accent.withAlpha(80),
      strokeWidth: 2.0,
      value: getValue(),
      valueColor: AlwaysStoppedAnimation<Color>(accent),
    );
  }
}
