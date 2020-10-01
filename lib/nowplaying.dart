import 'dart:async';
import 'dart:math';

import 'package:Beats/API/saavn.dart';
import 'package:Beats/model/player.dart';
import 'package:Beats/visualizer.dart';
import 'package:audio_session/audio_session.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:just_audio/just_audio.dart';

class NowPlaying extends StatefulWidget {
  final String songId;
  final bool newSong;
  const NowPlaying({Key key, @required this.songId, this.newSong = false})
      : super(key: key);
  @override
  _NowPlayingState createState() => _NowPlayingState(songId, newSong);
}

class _NowPlayingState extends State<NowPlaying> {
  final String songId;
  final bool newSong;

  _NowPlayingState(this.songId, this.newSong);

  // Future createPlaylist() async {
  //   SongDetails song = await fetchSongDetails(songId);
  //   _playlist = ConcatenatingAudioSource(children: [
  //     AudioSource.uri(Uri.parse(song.kUrl),
  //         tag: AudioMetadata(
  //           album: song.album,
  //           title: song.title,
  //           artwork: song.image,
  //         ))
  //   ]);
  //   return _playlist;
  // }

  bool change = false;
  bool volume = false;

  @override
  void initState() {
    super.initState();
    if (player == null) {
      player = AudioPlayer();
    }
    if (newSong && player.playing) {
      player.stop();
    }
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.black,
    ));
    _init();
  }

  _init() async {
    print(newSong);
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration.music());
    if (newSong || playlist == null) {
      SongDetails song = await fetchSongDetails(songId);
      playlist = ConcatenatingAudioSource(children: [
        AudioSource.uri(Uri.parse(song.kUrl),
            tag: AudioMetadata(
              album: song.album,
              title: song.title,
              artwork: song.image,
            ))
      ]);
      try {
        await player.load(playlist);
        setState(() {
          player.play();
        });
      } catch (e) {
        // catch load errors: 404, invalid url ...
        print("An error occured $e");
      }
    }
    currentSongId = songId;
  }

  @override
  void dispose() {
    //player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: playlist != null
            ? Column(
                children: [
                  StreamBuilder<SequenceState>(
                    stream: player.sequenceStateStream,
                    builder: (context, snapshot) {
                      final state = snapshot.data;
                      if (state?.sequence?.isEmpty ?? true) return SizedBox();
                      final metadata = state.currentSource.tag as AudioMetadata;
                      return Column(
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                height: 320,
                                width: 320,
                                child: Vis(),
                              ),
                              Container(
                                height: 200,
                                width: 200,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: CachedNetworkImageProvider(
                                        metadata.artwork),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 20.0, bottom: 15.0),
                            child: Text(
                              metadata.title ?? '',
                              style: TextStyle(
                                fontSize: 30.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 20.0),
                            child: Text(
                              metadata.album ?? '',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
                  SizedBox(height: 30.0),
                  ControlButtons(player),
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0)),
                    margin:
                        EdgeInsets.symmetric(horizontal: 40.0, vertical: 40.0),
                    child: Container(
                      height: 80.0,
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.symmetric(horizontal: 30.0),
                      child: !change
                          ? Row(
                              children: [
                                IconButton(
                                  icon:
                                      Icon(MaterialCommunityIcons.volume_high),
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
                                    icon: Text(
                                        "${snapshot.data?.toStringAsFixed(1)}x",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
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
                              stream: volume
                                  ? player.volumeStream
                                  : player.speedStream,
                              onChanged:
                                  volume ? player.setVolume : player.setSpeed,
                            ),
                    ),
                  ),
                  // Container(
                  //   height: 240.0,
                  //   child: StreamBuilder<SequenceState>(
                  //     stream: player.sequenceStateStream,
                  //     builder: (context, snapshot) {
                  //       final state = snapshot.data;
                  //       final sequence = state?.sequence ?? [];
                  //       return ListView.builder(
                  //         itemCount: sequence.length,
                  //         itemBuilder: (context, index) => Material(
                  //           color: index == state.currentIndex
                  //               ? Colors.grey.shade300
                  //               : null,
                  //           child: ListTile(
                  //             title: Text(sequence[index].tag.title),
                  //             onTap: () {
                  //               player.seek(Duration.zero, index: index);
                  //             },
                  //           ),
                  //         ),
                  //       );
                  //     },
                  //   ),
                  // ),
                ],
              )
            : Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

class ControlButtons extends StatelessWidget {
  final AudioPlayer player;

  ControlButtons(this.player);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        StreamBuilder<LoopMode>(
          stream: player.loopModeStream,
          builder: (context, snapshot) {
            final loopMode = snapshot.data ?? LoopMode.off;
            const icons = [
              Icon(MaterialIcons.repeat, color: Colors.grey),
              Icon(Icons.repeat, color: Colors.orange),
              Icon(Icons.repeat_one, color: Colors.orange),
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
                player.setLoopMode(cycleModes[
                    (cycleModes.indexOf(loopMode) + 1) % cycleModes.length]);
              },
            );
          },
        ),
        StreamBuilder<SequenceState>(
          stream: player.sequenceStateStream,
          builder: (context, snapshot) => IconButton(
            icon: Icon(Icons.skip_previous),
            onPressed: player.hasPrevious ? player.seekToPrevious : null,
          ),
        ),
        StreamBuilder<PlayerState>(
          stream: player.playerStateStream,
          builder: (context, snapshot) {
            final playerState = snapshot.data;
            final processingState = playerState?.processingState;
            final playing = playerState?.playing;
            if (processingState == ProcessingState.loading ||
                processingState == ProcessingState.buffering) {
              return FloatingActionButton(
                onPressed: null,
                child: CircularProgressIndicator(
                  backgroundColor: Colors.black,
                ),
              );
            } else if (playing != true) {
              return FloatingActionButton(
                child: Icon(Icons.play_arrow),
                onPressed: player.play,
              );
            } else if (processingState != ProcessingState.completed) {
              return FloatingActionButton(
                child: Icon(Icons.pause),
                onPressed: player.pause,
              );
            } else {
              return FloatingActionButton(
                child: Icon(Icons.replay),
                onPressed: () => player.seek(Duration.zero, index: 0),
              );
            }
          },
        ),
        StreamBuilder<SequenceState>(
          stream: player.sequenceStateStream,
          builder: (context, snapshot) => IconButton(
            icon: Icon(Icons.skip_next),
            onPressed: player.hasNext ? player.seekToNext : null,
          ),
        ),
        StreamBuilder<bool>(
          stream: player.shuffleModeEnabledStream,
          builder: (context, snapshot) {
            final shuffleModeEnabled = snapshot.data ?? false;
            return IconButton(
              icon: shuffleModeEnabled
                  ? Icon(Icons.shuffle, color: Colors.orange)
                  : Icon(Icons.shuffle, color: Colors.grey),
              onPressed: () {
                player.setShuffleModeEnabled(!shuffleModeEnabled);
              },
            );
          },
        ),
      ],
    );
  }
}

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
            inactiveTrackColor: Colors.grey[500],
            activeTrackColor: Color(0xffa5ecd7),
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
          right: 25.0,
          bottom: 0.0,
          child: Text('$_remaining'.substring(3, 7),
              style: Theme.of(context).textTheme.caption),
        ),
        Positioned(
          left: 25.0,
          bottom: 0.0,
          child: Text(widget.duration.toString().substring(3, 7),
              style: Theme.of(context).textTheme.caption),
        ),
      ],
    );
  }

  Duration get _remaining => widget.duration - widget.position;
}

_showSliderDialog({
  BuildContext context,
  String title,
  int divisions,
  double min,
  double max,
  String valueSuffix = '',
  Stream<double> stream,
  ValueChanged<double> onChanged,
}) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title, textAlign: TextAlign.center),
      content: StreamBuilder<double>(
        stream: stream,
        builder: (context, snapshot) => Container(
          height: 100.0,
          child: Column(
            children: [
              Text('${snapshot.data?.toStringAsFixed(1)}$valueSuffix',
                  style: TextStyle(
                      fontFamily: 'Fixed',
                      fontWeight: FontWeight.bold,
                      fontSize: 24.0)),
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

class AudioMetadata {
  final String album;
  final String title;
  final String artwork;

  AudioMetadata({this.album, this.title, this.artwork});
}
