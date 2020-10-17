import 'dart:async';
import 'package:Beats/model/player.dart';
import 'package:Beats/ui/player/nowplaying.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:just_audio/just_audio.dart';

class MainAudioPlayer extends StatelessWidget {
  final size;

  const MainAudioPlayer({Key key, @required this.size}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder<SequenceState>(
        stream: player.sequenceStateStream,
        builder: (context, snapshot) {
          final state = snapshot.data;
          if (state?.sequence?.isEmpty ?? true) return SizedBox();
          final metadata = state.currentSource.tag as AudioMetadata;
          return Column(
            children: [
              Container(
                width: size.width * 0.9,
                height: size.width * 0.9,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(metadata.artwork),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 30.0, bottom: 10.0),
                child: Text(
                  metadata.title ?? '',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'DMSans',
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 20.0),
                child: Text(
                  metadata.album ?? '',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: StreamBuilder<Duration>(
                  stream: player.durationStream,
                  builder: (context, snapshot) {
                    final duration = snapshot.data ?? Duration.zero;
                    return StreamBuilder<Duration>(
                      stream: player.positionStream,
                      builder: (context, snapshot) {
                        var position = snapshot.data ?? Duration.zero;
                        if (position > duration) {
                          position = duration;
                        }
                        return SeekBar(
                          duration: duration,
                          position: position,
                          onChangeEnd: (newPosition) {
                            player.seek(newPosition);
                          },
                        );
                      },
                    );
                  },
                ),
              ),
              SizedBox(height: 20.0),
              ControlButtons(player),
              SizedBox(height: 30.0),
              ExtraControllers(),
            ],
          );
        },
      ),
    );
  }
}

class ExtraControllers extends StatefulWidget {
  @override
  _ExtraControllersState createState() => _ExtraControllersState();
}

class _ExtraControllersState extends State<ExtraControllers> {
  bool change = false;
  bool volume = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      margin: EdgeInsets.symmetric(horizontal: 40.0),
      child: Container(
        height: 80.0,
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(horizontal: 30.0),
        child: !change
            ? Row(
                children: [
                  IconButton(
                    icon: Icon(MaterialCommunityIcons.volume_high),
                    onPressed: () {
                      Timer(Duration(seconds: 3), () {
                        change = !change;
                        setState(() {});
                      });
                      setState(() {
                        volume = true;
                        change = !change;
                      });
                    },
                  ),
                  Spacer(),
                  IconButton(
                    icon: Icon(Icons.playlist_play),
                    onPressed: null,
                  ),
                  Spacer(),
                  StreamBuilder<double>(
                    stream: player.speedStream,
                    builder: (context, snapshot) => IconButton(
                      icon: Text("${snapshot.data?.toStringAsFixed(1)}x",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      onPressed: () {
                        Timer(Duration(seconds: 3), () {
                          change = !change;
                          setState(() {});
                        });
                        setState(() {
                          volume = false;
                          change = !change;
                        });
                      },
                    ),
                  ),
                ],
              )
            : _showSlider(
                context: context,
                divisions: 10,
                min: volume ? 0.0 : 0.5,
                max: volume ? 1.0 : 1.5,
                stream: volume ? player.volumeStream : player.speedStream,
                onChanged: volume ? player.setVolume : player.setSpeed,
              ),
      ),
    );
  }

  _showSlider(
      {BuildContext context,
      int divisions,
      double min,
      double max,
      String valueSuffix = '',
      Stream<double> stream,
      ValueChanged<double> onChanged}) {
    return StreamBuilder<double>(
      stream: stream,
      builder: (context, snapshot) => Container(
        height: 100.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${snapshot.data?.toStringAsFixed(1)}$valueSuffix',
              style: TextStyle(
                fontFamily: 'Fixed',
                fontWeight: FontWeight.w400,
                fontSize: 20.0,
              ),
            ),
            Slider(
              divisions: divisions,
              min: min,
              max: max,
              value: snapshot.data ?? 1.0,
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }
}
