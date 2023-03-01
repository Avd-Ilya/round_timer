import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import '../ticker/ticker.dart';
part 'timer_event.dart';
part 'timer_state.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  StatusTimer statusTimer = StatusTimer.round;
  // final player = AudioPlayer();
  final Ticker _ticker;
  final Duration roundTime;
  final Duration restTime;
  final Duration warningTime;
  final int rounds;
  int currentRound = 1;

  StreamSubscription<Duration>? _tickerSubscription;

  TimerBloc(
      {required Ticker ticker,
      required this.roundTime,
      required this.restTime,
      required this.warningTime,
      required this.rounds})
      : _ticker = ticker,
        super(const TimerInitial()) {
    on<TimerStarted>(_onStarted);
    on<TimerTicked>(_onTicked);
    on<TimerEnd>((event, emit) {
      emit(const TimerClose());
    });
  }

  @override
  Future<void> close() {
    _tickerSubscription?.cancel();
    return super.close();
  }

  void _onStarted(TimerStarted event, Emitter<TimerState> emit) {
    // player.play(AssetSource('start.mp3'));
    emit(TimerRun.withSound(roundTime, rounds, currentRound, 'start.mp3'));
    startTimer(roundTime);
  }

  void startTimer(Duration time) {
    _tickerSubscription?.cancel();
    _tickerSubscription = _ticker
        .tick(ticks: time)
        .listen((duration) => add(TimerTicked(duration: duration)));
  }

  void _onTicked(TimerTicked event, Emitter<TimerState> emit) {
    switch (statusTimer) {
      case StatusTimer.round:
        if (event.duration.inSeconds > 0) {
          if (event.duration.inSeconds == warningTime.inSeconds) {
            // player.play(AssetSource('warning.mp3'));
            statusTimer = StatusTimer.warning;
            emit(TimerWarning.withSound(event.duration, rounds, currentRound, 'warning.mp3'));
            startTimer(warningTime);
          } else {
            emit(TimerRun(event.duration, rounds, currentRound));
          }
        } else {
          if (currentRound < rounds) {
            emit(TimerRun.withSound(event.duration, rounds, currentRound, 'alert.mp3'));
            // player.play(AssetSource('alert.mp3'));
            statusTimer = StatusTimer.rest;
            startTimer(restTime + const Duration(seconds: 1));
          } else {
            // player.play(AssetSource('ending.mp3'));
            emit(const TimerClose.withSound('ending.mp3'));
          }
        }
        break;
      case StatusTimer.warning:
        if (event.duration.inSeconds == 0) {
          if (currentRound < rounds) {
            emit(TimerWarning.withSound(event.duration, rounds, currentRound, 'alert.mp3'));
            // player.play(AssetSource('alert.mp3'));
            statusTimer = StatusTimer.rest;
            startTimer(restTime + const Duration(seconds: 1));
          } else {
            // player.play(AssetSource('ending.mp3'));
            emit(const TimerClose.withSound('ending.mp3'));
          }
        } else {
          emit(TimerWarning(event.duration, rounds, currentRound));
        }
        break;
      case StatusTimer.rest:
        if (event.duration.inSeconds == 0) {
          emit(TimerRest.withSound(event.duration, rounds, currentRound, 'start.mp3'));
          // player.play(AssetSource('start.mp3'));
          statusTimer = StatusTimer.round;
          currentRound += 1;
          startTimer(roundTime + const Duration(seconds: 1));
        } else {
          emit(TimerRest(event.duration, rounds, currentRound));
        }
        break;
      default:
    }
  }
}

enum StatusTimer { round, warning, rest }
