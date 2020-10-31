import 'dart:async';

import 'package:Beats/model/player/audio_metadata.dart';
import 'package:Beats/model/player/player.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:audio_session/audio_session.dart';
import 'package:just_audio/just_audio.dart';

part 'player_event.dart';
part 'player_state.dart';

class PlayerBloc extends Bloc<PlayerEvent, PlayerState> {
  PlayerBloc() : super(PlayerInitial());

  @override
  Stream<PlayerState> mapEventToState(
    PlayerEvent event,
  ) async* {
    if (event is LoadPlayer) {
      yield PlayerLoading();
      await _initPlayer(event.map[event.map.keys.toList()[0]]);
      yield PlayerLoaded();
    }
  }
}

_initPlayer(map) async {
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
