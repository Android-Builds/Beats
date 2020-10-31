import 'package:Beats/API/saavn.dart';
import 'package:just_audio/just_audio.dart';

AudioPlayer player;
ConcatenatingAudioSource playlist;
SongDetails song;
String currentSongId = '';

initPlayer() {
  player = new AudioPlayer();
}
