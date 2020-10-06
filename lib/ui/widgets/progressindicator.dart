import 'dart:async';

import 'package:Beats/model/player.dart';
import 'package:Beats/style/appColors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class SongProgressIndicator extends StatefulWidget {
  final double size;
  const SongProgressIndicator({Key key, @required this.size}) : super(key: key);
  @override
  _SongProgressIndicatorState createState() =>
      _SongProgressIndicatorState(size);
}

class _SongProgressIndicatorState extends State<SongProgressIndicator> {
  final double size;

  _SongProgressIndicatorState(this.size);

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
          height: size,
          width: size,
          child: CircularProgressIndicator(
            value: getValue(),
            valueColor: AlwaysStoppedAnimation<Color>(accent),
          ),
        ),
        Container(
          height: size - 10.0,
          width: size - 10.0,
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
