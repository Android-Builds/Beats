part of 'api_bloc.dart';

abstract class ApiState extends Equatable {}

class ApiInitial extends ApiState {
  @override
  List<Object> get props => [];
}

class ApiLoading extends ApiState {
  @override
  List<Object> get props => [];
}

class ApiLoaded extends ApiState {
  final map;

  ApiLoaded({@required this.map});
  @override
  List<Object> get props => null;
}

class ApiError extends ApiState {
  final String message;

  ApiError({@required this.message});

  @override
  List<Object> get props => null;
}
