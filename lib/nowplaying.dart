import 'package:Musify/API/saavn.dart';
import 'package:Musify/model/player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

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

  @override
  void initState() {
    super.initState();
    currentSongId = songId;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: FutureBuilder(
          future: newSong
              ? fetchSongDetails(songId)
              : Future.delayed(Duration(microseconds: 1)),
          builder: (context, snapshot) {
            if (snapshot.hasData || !newSong) {
              song = newSong ? snapshot.data : song;
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
                          image: CachedNetworkImageProvider(song.image),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 30.0, bottom: 20.0),
                      child: Text(
                        song.title,
                        style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 40.0),
                      child: Text(
                        song.artist,
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              return Text('Error');
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
