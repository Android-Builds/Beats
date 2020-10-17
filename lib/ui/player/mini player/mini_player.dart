import 'package:Beats/model/player.dart';
import 'package:Beats/ui/player/mini%20player/play_pause_button.dart';
import 'package:Beats/ui/player/mini%20player/progressindicator.dart';
import 'package:Beats/utils/themes.dart';
import 'package:flutter/material.dart';

class MiniPlayer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          song?.image != null
              ? SongProgressIndicator()
              : Icon(Icons.music_note),
          Spacer(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(song?.title ?? '', style: title.copyWith(fontSize: 15.0)),
              Text(song?.artist ?? '', style: small),
            ],
          ),
          Spacer(),
          player != null
              ? Container(
                  padding: EdgeInsets.all(12.0), child: PlayPauseButton())
              : SizedBox.shrink()
        ],
      ),
    );
  }
}
