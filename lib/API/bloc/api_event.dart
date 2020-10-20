part of 'api_bloc.dart';

abstract class ApiEvent extends Equatable {}

class FetchApi extends ApiEvent {
  @override
  List<Object> get props => null;
}
