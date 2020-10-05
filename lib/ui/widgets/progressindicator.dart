import 'dart:async';

import 'package:Beats/model/player.dart';
import 'package:Beats/style/appColors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

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
    return player != null
        ? player.playing
            ? (player.position.inSeconds / player.duration.inSeconds)
            : 0.0
        : 0.0;
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
