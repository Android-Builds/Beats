import 'package:Beats/API/bloc/api_bloc.dart';
import 'package:Beats/model/player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:audio_session/audio_session.dart';
import 'package:just_audio/just_audio.dart';

class CollapsedPanel extends StatelessWidget {
  final String image;
  final String title;
  final String artist;

  const CollapsedPanel({
    Key key,
    @required this.image,
    @required this.title,
    @required this.artist,
  }) : super(key: key);

  _init(map) async {
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration.music());
    if (player == null) {
      player = AudioPlayer();
    }
    if (true /*newSong || playlist == null*/) {
      playlist = ConcatenatingAudioSource(children: [
        AudioSource.uri(Uri.parse(map['more_info']['encrypted_media_url']),
            tag: AudioMetadata(
              album: map['title'],
              title: map['more_info']['album'],
              artwork: map['image'],
            ))
      ]);
      try {
        await player.load(playlist);
        player.play();
      } catch (e) {
        // catch load errors: 404, invalid url ...
        print("An error occured $e");
      }
    }
    //currentSongId = songId;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ApiBloc, ApiState>(
      builder: (context, state) {
        if (state is ApiLoaded) {
          _init(state.map[state.map.keys.toList()[0]]);
        }
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Row(
            children: [
              Container(
                height: kToolbarHeight * 0.9,
                width: kToolbarHeight * 0.9,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(image),
                  ),
                ),
              ),
              Spacer(),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: title + '\n',
                  style: DefaultTextStyle.of(context)
                      .style
                      .copyWith(fontWeight: FontWeight.bold, fontSize: 15.0),
                  children: <TextSpan>[
                    TextSpan(
                      text: artist,
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 12.0,
                      ),
                    ),
                  ],
                ),
              ),
              Spacer(),
              (state is ApiLoading || state is ApiError) ? loading() : loaded(),
            ],
          ),
        );
      },
    );
  }

  Widget loading() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0),
      child: CircularProgressIndicator(),
    );
  }

  Widget loaded() {
    return Row(
      children: [
        IconButton(
          icon: Icon(Icons.play_arrow),
          onPressed: () {
            player.pause();
          },
        )
      ],
    );
  }
}

class AudioMetadata {
  final String album;
  final String title;
  final String artwork;

  AudioMetadata({this.album, this.title, this.artwork});
}
