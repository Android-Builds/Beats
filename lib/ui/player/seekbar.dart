import 'dart:math';

import 'package:Beats/style/appColors.dart';
import 'package:flutter/material.dart';

class SeekBar extends StatefulWidget {
  final Duration duration;
  final Duration position;
  final ValueChanged<Duration> onChanged;
  final ValueChanged<Duration> onChangeEnd;

  SeekBar({
    @required this.duration,
    @required this.position,
    this.onChanged,
    this.onChangeEnd,
  });

  @override
  _SeekBarState createState() => _SeekBarState();
}

class _SeekBarState extends State<SeekBar> {
  double _dragValue;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SliderTheme(
          data: SliderThemeData(
            thumbShape: SliderComponentShape.noOverlay,
            activeTrackColor: accent,
            trackHeight: 1.0,
          ),
          child: Slider(
            min: 0.0,
            max: widget.duration.inMilliseconds.toDouble(),
            value: min(_dragValue ?? widget.position.inMilliseconds.toDouble(),
                widget.duration.inMilliseconds.toDouble()),
            onChanged: (value) {
              setState(() {
                _dragValue = value;
              });
              if (widget.onChanged != null) {
                widget.onChanged(Duration(milliseconds: value.round()));
              }
            },
            onChangeEnd: (value) {
              if (widget.onChangeEnd != null) {
                widget.onChangeEnd(Duration(milliseconds: value.round()));
              }
              _dragValue = null;
            },
          ),
        ),
        // Positioned(
        //   right: 25.0,
        //   bottom: 0.0,
        //   child: Text(
        //       RegExp(r'((^0*[1-9]\d*:)?\d{2}:\d{2})\.\d+$')
        //               .firstMatch("$_remaining")
        //               ?.group(1) ??
        //           '$_remaining',
        //       style: Theme.of(context).textTheme.caption),
        // ),
        Positioned(
          left: 25.0,
          bottom: 0.0,
          child: Text('$_remaining'.substring(3, 7),
              style: Theme.of(context).textTheme.caption),
        ),
        Positioned(
          right: 25.0,
          bottom: 0.0,
          child: Text(widget.duration.toString().substring(3, 7),
              style: Theme.of(context).textTheme.caption),
        ),
      ],
    );
  }

  Duration get _remaining => widget.duration - widget.position;
}
