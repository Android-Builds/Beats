import 'dart:async';
import 'package:Beats/utils/constants.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'api_event.dart';
part 'api_state.dart';

class ApiBloc extends Bloc<ApiEvent, ApiState> {
  ApiBloc() : super(ApiInitial());

  @override
  Stream<ApiState> mapEventToState(ApiEvent event) async* {
    if (event is FetchApi) {
      yield ApiLoading();
      try {
        var map = await apicall;
        //print(map);
        yield ApiLoaded(map: map);
      } catch (e) {
        yield ApiError(message: e.toString());
      }
    }
  }
}
