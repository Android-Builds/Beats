import 'package:Beats/model/player.dart';
import 'package:Beats/ui/widgets/progressindicator.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class NowPlayingMini extends StatefulWidget {
  final double width;
  final double height;

  const NowPlayingMini({Key key, @required this.width, @required this.height})
      : super(key: key);
  @override
  _NowPlayingMiniState createState() => _NowPlayingMiniState(width, height);
}

class _NowPlayingMiniState extends State<NowPlayingMini> {
  final double width;
  final double height;

  _NowPlayingMiniState(this.width, this.height);
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        Container(
            height: height,
            width: width,
            child: Card(
              color: Colors.grey[900],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(200.0)),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 100.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(song?.title ?? '',
                            style: TextStyle(
                                fontSize: 17.0, fontWeight: FontWeight.bold)),
                        SizedBox(height: 5),
                        Text(song?.artist ?? '',
                            style: TextStyle(fontSize: 12.0)),
                      ],
                    ),
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: StreamBuilder<PlayerState>(
                      stream: player.playerStateStream,
                      builder: (context, snapshot) {
                        final playerState = snapshot.data;
                        final processingState = playerState?.processingState;
                        final playing = playerState?.playing;
                        if (processingState == ProcessingState.loading ||
                            processingState == ProcessingState.buffering) {
                          return FloatingActionButton(
                            mini: true,
                            heroTag: 'miniwait',
                            onPressed: null,
                            child: CircularProgressIndicator(
                              backgroundColor: Colors.black,
                            ),
                          );
                        } else if (playing != true) {
                          return FloatingActionButton(
                            mini: true,
                            heroTag: 'miniplay',
                            child: Icon(Icons.play_arrow),
                            onPressed: player.play,
                          );
                        } else if (processingState !=
                            ProcessingState.completed) {
                          return FloatingActionButton(
                            mini: true,
                            heroTag: 'minipause',
                            child: Icon(Icons.pause),
                            onPressed: player.pause,
                          );
                        } else {
                          return FloatingActionButton(
                            mini: true,
                            heroTag: 'minireplay',
                            child: Icon(Icons.replay),
                            onPressed: () =>
                                player.seek(Duration.zero, index: 0),
                          );
                        }
                      },
                    ),
                  )
                ],
              ),
            )),
        SongProgressIndicator(size: height + 10.0),
      ],
    );
  }
}
