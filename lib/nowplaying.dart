// import 'package:Beats/API/saavn.dart';
// import 'package:Beats/model/player.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';

// class NowPlaying extends StatefulWidget {
//   final String songId;
//   final bool newSong;
//   const NowPlaying({Key key, @required this.songId, this.newSong = false})
//       : super(key: key);
//   @override
//   _NowPlayingState createState() => _NowPlayingState(songId, newSong);
// }

// class _NowPlayingState extends State<NowPlaying> {
//   final String songId;
//   final bool newSong;

//   _NowPlayingState(this.songId, this.newSong);

//   int session;

//   getSession() async {
//     //     try {
//     //   final int result = await _channel.invokeMethod('getSessionID');
//     //   session = result ;
//     // } on PlatformException catch (e) {
//     //   session = null;
//     // }
//   }

//   @override
//   void initState() {
//     super.initState();
//     currentSongId = songId;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         body: FutureBuilder(
//           future: newSong
//               ? fetchSongDetails(songId)
//               : Future.delayed(Duration(microseconds: 1)),
//           builder: (context, snapshot) {
//             if (snapshot.hasData || !newSong) {
//               song = newSong ? snapshot.data : song;
//               return Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Container(
//                       height: 270,
//                       width: 270,
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         image: DecorationImage(
//                           image: CachedNetworkImageProvider(song.image),
//                         ),
//                       ),
//                     ),
//                     Padding(
//                       padding: EdgeInsets.only(top: 30.0, bottom: 20.0),
//                       child: Text(
//                         song.title,
//                         style: TextStyle(
//                           fontSize: 30.0,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                     Padding(
//                       padding: EdgeInsets.only(bottom: 40.0),
//                       child: Text(
//                         song.artist,
//                         style: TextStyle(
//                           fontSize: 16.0,
//                           fontWeight: FontWeight.w400,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             } else if (snapshot.hasError) {
//               return Text('Error');
//             } else {
//               return Center(child: CircularProgressIndicator());
//             }
//           },
//         ),
//       ),
//     );
//   }
// }

import 'dart:math';

import 'package:Beats/API/saavn.dart';
import 'package:audio_session/audio_session.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  AudioPlayer _player;
  ConcatenatingAudioSource _playlist1 = ConcatenatingAudioSource(children: [
    AudioSource.uri(
      Uri.parse(
          "https://s3.amazonaws.com/scifri-episodes/scifri20181123-episode.mp3"),
      tag: AudioMetadata(
        album: "Science Friday",
        title: "A Salute To Head-Scratching Science (5 seconds)",
        artwork:
            "https://media.wnyc.org/i/1400/1400/l/80/1/ScienceFriday_WNYCStudios_1400.jpg",
      ),
    ),
    AudioSource.uri(
      Uri.parse(
          "https://s3.amazonaws.com/scifri-episodes/scifri20181123-episode.mp3"),
      tag: AudioMetadata(
        album: "Science Friday",
        title: "A Salute To Head-Scratching Science",
        artwork:
            "https://media.wnyc.org/i/1400/1400/l/80/1/ScienceFriday_WNYCStudios_1400.jpg",
      ),
    ),
    AudioSource.uri(
      Uri.parse("https://s3.amazonaws.com/scifri-segments/scifri201711241.mp3"),
      tag: AudioMetadata(
        album: "Science Friday",
        title: "From Cat Rheology To Operatic Incompetence",
        artwork:
            "https://media.wnyc.org/i/1400/1400/l/80/1/ScienceFriday_WNYCStudios_1400.jpg",
      ),
    ),
  ]);

  ConcatenatingAudioSource _playlist;

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

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.black,
    ));
    _init();
  }

  _init() async {
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration.speech());
    SongDetails song = await fetchSongDetails(songId);
    _playlist = ConcatenatingAudioSource(children: [
      AudioSource.uri(Uri.parse(song.kUrl),
          tag: AudioMetadata(
            album: song.album,
            title: song.title,
            artwork: song.image,
          ))
    ]);
    try {
      await _player.load(_playlist);
      setState(() {
        _player.play();
      });
    } catch (e) {
      // catch load errors: 404, invalid url ...
      print("An error occured $e");
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _playlist != null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  StreamBuilder<SequenceState>(
                    stream: _player.sequenceStateStream,
                    builder: (context, snapshot) {
                      final state = snapshot.data;
                      if (state?.sequence?.isEmpty ?? true) return SizedBox();
                      final metadata = state.currentSource.tag as AudioMetadata;
                      return Center(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 270,
                            width: 270,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: CachedNetworkImageProvider(
                                    metadata.artwork),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 30.0, bottom: 20.0),
                            child: Text(
                              metadata.title ?? '',
                              style: TextStyle(
                                fontSize: 30.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 40.0),
                            child: Text(
                              metadata.album ?? '',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ));
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: StreamBuilder<Duration>(
                      stream: _player.durationStream,
                      builder: (context, snapshot) {
                        final duration = snapshot.data ?? Duration.zero;
                        return StreamBuilder<Duration>(
                          stream: _player.positionStream,
                          builder: (context, snapshot) {
                            var position = snapshot.data ?? Duration.zero;
                            if (position > duration) {
                              position = duration;
                            }
                            return SeekBar(
                              duration: duration,
                              position: position,
                              onChangeEnd: (newPosition) {
                                _player.seek(newPosition);
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                  ControlButtons(_player),
                  SizedBox(height: 8.0),
                  Row(
                    children: [
                      StreamBuilder<LoopMode>(
                        stream: _player.loopModeStream,
                        builder: (context, snapshot) {
                          final loopMode = snapshot.data ?? LoopMode.off;
                          const icons = [
                            Icon(Icons.repeat, color: Colors.grey),
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
                              _player.setLoopMode(cycleModes[
                                  (cycleModes.indexOf(loopMode) + 1) %
                                      cycleModes.length]);
                            },
                          );
                        },
                      ),
                      Expanded(
                        child: Text(
                          "Playlist",
                          // style: Theme.of(context).textTheme.headline6,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      StreamBuilder<bool>(
                        stream: _player.shuffleModeEnabledStream,
                        builder: (context, snapshot) {
                          final shuffleModeEnabled = snapshot.data ?? false;
                          return IconButton(
                            icon: shuffleModeEnabled
                                ? Icon(Icons.shuffle, color: Colors.orange)
                                : Icon(Icons.shuffle, color: Colors.grey),
                            onPressed: () {
                              _player
                                  .setShuffleModeEnabled(!shuffleModeEnabled);
                            },
                          );
                        },
                      ),
                    ],
                  ),
                  // Container(
                  //   height: 240.0,
                  //   child: StreamBuilder<SequenceState>(
                  //     stream: _player.sequenceStateStream,
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
                  //               _player.seek(Duration.zero, index: index);
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
        IconButton(
          icon: Icon(Icons.volume_up),
          onPressed: () {
            _showSliderDialog(
              context: context,
              title: "Adjust volume",
              divisions: 10,
              min: 0.0,
              max: 1.0,
              stream: player.volumeStream,
              onChanged: player.setVolume,
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
        StreamBuilder<double>(
          stream: player.speedStream,
          builder: (context, snapshot) => IconButton(
            icon: Text("${snapshot.data?.toStringAsFixed(1)}x",
                style: TextStyle(fontWeight: FontWeight.bold)),
            onPressed: () {
              _showSliderDialog(
                context: context,
                title: "Adjust speed",
                divisions: 10,
                min: 0.5,
                max: 1.5,
                stream: player.speedStream,
                onChanged: player.setSpeed,
              );
            },
          ),
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
        Positioned(
          right: 25.0,
          bottom: 0.0,
          child: Text(
              RegExp(r'((^0*[1-9]\d*:)?\d{2}:\d{2})\.\d+$')
                      .firstMatch("$_remaining")
                      ?.group(1) ??
                  '$_remaining',
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

class AudioMetadata {
  final String album;
  final String title;
  final String artwork;

  AudioMetadata({this.album, this.title, this.artwork});
}
