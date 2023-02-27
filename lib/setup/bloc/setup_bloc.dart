import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
part 'setup_event.dart';
part 'setup_state.dart';

class SetupBloc extends Bloc<SetupEvent, SetupState> {
  var roundTime = const Duration(seconds: 13);
  var restTime = const Duration(seconds: 5);
  var warningTime = const Duration(seconds: 10);
  var rounds = 3;

  SetupBloc()
      : super(const SetupInitial(
          Duration(seconds: 13),
          Duration(seconds: 5),
          Duration(seconds: 10),
          3,
        )) {
    on<SetupRoundTimeChanged>((event, emit) {
      roundTime = event.roundTime;
      emit(SetupUpdated(roundTime, restTime, warningTime, rounds));
    });
    on<SetupRestTimeChanged>((event, emit) {
      restTime = event.restTime;
      emit(SetupUpdated(roundTime, restTime, warningTime, rounds));
    });
    on<SetupRoundsChanged>((event, emit) {
      rounds = event.rounds;
      emit(SetupUpdated(roundTime, restTime, warningTime, rounds));
    });
    on<SetupWarningTimeChanged>((event, emit) {
      warningTime = event.warningTime;
      emit(SetupUpdated(roundTime, restTime, warningTime, rounds));
    });
    on<SetupStart>((event, emit) {
      emit(SetupStartTimer(roundTime, restTime, warningTime, rounds));
    });
    on<SetupReturned>((event, emit) {
      emit(SetupUpdated(roundTime, restTime, warningTime, rounds));
    });
  }
}
