
import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:example/bloc/internet_event.dart';
import 'package:example/bloc/internet_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class InternetBloc extends Bloc<InternetEvent, InternetState> {

  StreamSubscription? streamSubscription;
  final _connectivity = Connectivity();

  InternetBloc() : super(InternetInitialState()) {
    on<InternetLossEvent>((event, emit) => emit(InternetLossState()));
    on<InternetGainedEvent>((event, emit) => emit(InternetGainedState()));

    streamSubscription = _connectivity.onConnectivityChanged.listen((result) {

      if (result == ConnectivityResult.mobile || result == ConnectivityResult.wifi) {
        add(InternetGainedEvent());
      }
      else {
        add(InternetLossEvent());
      }
    });
  }

  @override
  Future<void> close() {
    streamSubscription?.cancel();
    return super.close();
  }
}