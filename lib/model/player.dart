import 'package:Beats/API/saavn.dart';
import 'package:just_audio/just_audio.dart';

enum PlayerState { stopped, playing, paused }

AudioPlayer player;
PlayerState state = PlayerState.stopped;
SongDetails song;
String currentSongId = '';

initPlayer() {
  player = new AudioPlayer();
}
