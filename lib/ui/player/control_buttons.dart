import 'package:Beats/style/appColors.dart';
import 'package:Beats/ui/player/play_pause_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:just_audio/just_audio.dart';

class ControlButtons extends StatefulWidget {
  final AudioPlayer player;

  ControlButtons(this.player);

  @override
  _ControlButtonsState createState() => _ControlButtonsState();
}

class _ControlButtonsState extends State<ControlButtons>
    with SingleTickerProviderStateMixin {
  AnimationController controller;

  @override
  void initState() {
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 450));
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          StreamBuilder<LoopMode>(
            stream: widget.player.loopModeStream,
            builder: (context, snapshot) {
              var loopMode = snapshot.data ?? LoopMode.off;
              List<Widget> icons = [
                Center(child: Icon(Icons.loop, color: Colors.grey)),
                Center(
                    child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(Icons.loop_rounded, color: accent),
                    Text('1',
                        style: TextStyle(
                          fontSize: 6.0,
                          color: accent,
                          fontWeight: FontWeight.bold,
                        )),
                  ],
                )),
                Center(child: Icon(Icons.loop_rounded, color: accent)),
              ];
              const cycleModes = [
                LoopMode.off,
                LoopMode.all,
                LoopMode.one,
              ];
              final index = cycleModes.indexOf(loopMode);
              return IconButton(
                icon: icons[index],
                onPressed: () {
                  widget.player.setLoopMode(cycleModes[
                      (cycleModes.indexOf(loopMode) + 1) % cycleModes.length]);
                },
              );
            },
          ),
          Spacer(),
          StreamBuilder<SequenceState>(
            stream: widget.player.sequenceStateStream,
            builder: (context, snapshot) => IconButton(
              icon: Icon(MaterialCommunityIcons.skip_previous_circle),
              onPressed: widget.player.hasPrevious
                  ? widget.player.seekToPrevious
                  : null,
            ),
          ),
          Spacer(),
          PlayPauseButton(mini: false),
          Spacer(),
          StreamBuilder<SequenceState>(
            stream: widget.player.sequenceStateStream,
            builder: (context, snapshot) => IconButton(
              icon: Icon(MaterialCommunityIcons.skip_next_circle),
              onPressed:
                  widget.player.hasNext ? widget.player.seekToNext : null,
            ),
          ),
          Spacer(),
          StreamBuilder<bool>(
            stream: widget.player.shuffleModeEnabledStream,
            builder: (context, snapshot) {
              final shuffleModeEnabled = snapshot.data ?? false;
              return IconButton(
                icon: shuffleModeEnabled
                    ? Icon(MaterialCommunityIcons.shuffle_variant,
                        color: accent)
                    : Icon(Ionicons.ios_shuffle, color: Colors.grey),
                onPressed: () {
                  widget.player.setShuffleModeEnabled(!shuffleModeEnabled);
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
