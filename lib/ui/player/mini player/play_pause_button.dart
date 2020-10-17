import 'package:Beats/model/player.dart';
import 'package:Beats/style/appColors.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class PlayPauseButton extends StatefulWidget {
  final player;
  const PlayPauseButton({Key key, this.player}) : super(key: key);
  @override
  _PlayPauseButtonState createState() => _PlayPauseButtonState();
}

class _PlayPauseButtonState extends State<PlayPauseButton>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  @override
  void initState() {
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 450));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PlayerState>(
      stream: player.playerStateStream,
      builder: (context, snapshot) {
        final playerState = snapshot.data;
        final processingState = playerState?.processingState;
        if (processingState == ProcessingState.loading ||
            processingState == ProcessingState.buffering) {
          return FloatingActionButton(
            backgroundColor: accent,
            onPressed: null,
            child: CircularProgressIndicator(
              backgroundColor: Colors.black,
            ),
          );
        } else if (processingState == ProcessingState.completed) {
          return FloatingActionButton(
            backgroundColor: accent,
            child: Icon(Icons.replay),
            onPressed: () => widget.player.seek(Duration.zero, index: 0),
          );
        } else {
          return FloatingActionButton(
            backgroundColor: accent,
            child: AnimatedIcon(
              icon: AnimatedIcons.pause_play,
              progress: controller,
              semanticLabel: 'Play-Pause',
            ),
            onPressed: _handleOnPressed,
          );
        }
      },
    );
  }

  void _handleOnPressed() {
    setState(() {
      player.playing ? controller.forward() : controller.reverse();
      if (player.playing)
        player.pause();
      else if (!player.playing &&
          player.playerState.processingState != ProcessingState.completed)
        player.play();
    });
  }
}
