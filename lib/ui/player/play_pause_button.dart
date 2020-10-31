import 'package:Beats/model/player/player.dart';
import 'package:Beats/style/appColors.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class PlayPauseButton extends StatefulWidget {
  final player;
  final bool mini;
  const PlayPauseButton({
    Key key,
    this.player,
    this.mini = true,
  }) : super(key: key);
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
            mini: widget.mini,
            backgroundColor: accent,
            onPressed: null,
            child: CircularProgressIndicator(
              strokeWidth: 3.0,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          );
        } else if (processingState == ProcessingState.completed) {
          return FloatingActionButton(
            mini: widget.mini,
            backgroundColor: accent,
            child: Icon(Icons.replay),
            onPressed: () => widget.player.seek(Duration.zero, index: 0),
          );
        } else {
          return FloatingActionButton(
            mini: widget.mini,
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
