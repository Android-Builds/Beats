import 'package:Beats/API/bloc/api_bloc.dart';
import 'package:Beats/model/player.dart';
import 'package:Beats/style/appColors.dart';
import 'package:Beats/ui/player/play_pause_button.dart';
import 'package:Beats/ui/player/progressindicator.dart';
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
    bool newSong = !(map['id'] == currentSongId);
    if (newSong && player.playing) {
      player.stop();
    }
    if (newSong || playlist == null) {
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
    currentSongId = map['id'];
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ApiBloc, ApiState>(
      builder: (context, state) {
        if (state is ApiLoaded) {
          _init(state.map[state.map.keys.toList()[0]]);
        }
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            children: [
              //SongProgressIndicator(image: image),
              Container(
                height: kToolbarHeight * 0.9,
                width: kToolbarHeight * 0.9,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6.0),
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(image),
                  ),
                ),
              ),
              Spacer(),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                  ),
                  SizedBox(height: 5.0),
                  Text(
                    artist,
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 13.0,
                    ),
                  )
                ],
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
      child: CircularProgressIndicator(
        strokeWidth: 3.0,
        backgroundColor: accent.withAlpha(80),
        valueColor: AlwaysStoppedAnimation<Color>(accent),
      ),
    );
  }

  Widget loaded() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Transform.scale(scale: 1.3, child: SongProgressIndicator()),
        Transform.scale(scale: 0.95, child: PlayPauseButton()),
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
