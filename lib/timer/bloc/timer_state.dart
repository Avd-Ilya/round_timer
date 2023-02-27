part of 'timer_bloc.dart';

@immutable
abstract class TimerState extends Equatable {
  const TimerState(this.duration, this.rounds, this.currentRound);
  final Duration duration;
  final int rounds;
  final int currentRound;

  @override
  List<Object?> get props => [duration];
}

class TimerInitial extends TimerState {
  const TimerInitial() : super(Duration.zero, 0, 0);
}

class TimerRun extends TimerState {
  const TimerRun(super.duration, super.rounds, super.currentRound);
}

class TimerWarning extends TimerState {
  const TimerWarning(super.duration, super.rounds, super.currentRound);
}

class TimerRest extends TimerState {
  const TimerRest(super.duration, super.rounds, super.currentRound);
}

class TimerClose extends TimerState {
  const TimerClose() : super(Duration.zero, 0, 0);
}
