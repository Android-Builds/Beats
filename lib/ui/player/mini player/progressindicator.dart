import 'dart:async';

import 'package:Beats/model/player.dart';
import 'package:Beats/style/appColors.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: 50,
          width: 50,
          child: CircularProgressIndicator(
            value: getValue(),
            valueColor: AlwaysStoppedAnimation<Color>(accent),
          ),
        ),
        Container(
          child: song != null
              ? CircleAvatar(
                  backgroundImage: CachedNetworkImageProvider(song.image),
                )
              : CircleAvatar(
                  backgroundColor: Colors.white, child: Icon(Icons.music_note)),
        )
      ],
    );
  }
}
