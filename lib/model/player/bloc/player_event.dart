part of 'player_bloc.dart';

abstract class PlayerEvent extends Equatable {}

class LoadPlayer extends PlayerEvent {
  final Map map;

  LoadPlayer(this.map);

  @override
  List<Object> get props => [map];
}
