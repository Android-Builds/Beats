import 'package:Musify/API/saavn.dart';
import 'package:audioplayer/audioplayer.dart';

enum PlayerState { stopped, playing, paused }

AudioPlayer player;
PlayerState state = PlayerState.stopped;
SongDetails song;
String currentSongId = '';

initPlayer() {
  player = new AudioPlayer();
}
