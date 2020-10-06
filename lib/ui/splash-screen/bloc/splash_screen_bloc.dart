import 'dart:async';
import 'package:Beats/API/saavn.dart';
import 'package:Beats/utils/constants.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:permission_handler/permission_handler.dart';
part 'splash_screen_event.dart';
part 'splash_screen_state.dart';

class SplashScreenBloc extends Bloc<SplashScreenEvent, SplashScreenState> {
  final SplashScreenState initial;
  Permission permission = Permission.storage;

  @override
  SplashScreenBloc(this.initial) : super(initial);

  @override
  Stream<SplashScreenState> mapEventToState(
    SplashScreenEvent event,
  ) async* {
    if (event is NavigateToHomeScreenEvent) {
      yield Loading();
      await Future.wait([preLoad()]);
      yield Loaded();
    }
  }
}

Future preLoad() {
  //initPlayer();
  miniPlayer = new StreamController();
  topSongs().then((value) {
    topsongs = value;
  });
  return getFeaturedPlaylists().then((value) {
    featuredPlaylists = value;
  });
}
