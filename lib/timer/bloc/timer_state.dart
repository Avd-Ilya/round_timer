part of 'timer_bloc.dart';

@immutable
abstract class TimerState extends Equatable {
  const TimerState(this.duration, this.rounds, this.currentRound)
      : sound = null;
  const TimerState.withSound(
      this.duration, this.rounds, this.currentRound, this.sound);
  final Duration duration;
  final int rounds;
  final int currentRound;
  final String? sound;

  @override
  List<Object?> get props => [duration];
}

class TimerInitial extends TimerState {
  const TimerInitial() : super(Duration.zero, 0, 0);
}

class TimerRun extends TimerState {
  const TimerRun(super.duration, super.rounds, super.currentRound);
  const TimerRun.withSound(
      Duration duration, int rounds, int currentRound, String sound)
      : super.withSound(duration, rounds, currentRound, sound);
}

class TimerWarning extends TimerState {
  const TimerWarning(super.duration, super.rounds, super.currentRound);
  const TimerWarning.withSound(
      Duration duration, int rounds, int currentRound, String sound)
      : super.withSound(duration, rounds, currentRound, sound);
}

class TimerRest extends TimerState {
  const TimerRest(super.duration, super.rounds, super.currentRound);
  const TimerRest.withSound(
      Duration duration, int rounds, int currentRound, String sound)
      : super.withSound(duration, rounds, currentRound, sound);
}

class TimerClose extends TimerState {
  const TimerClose() : super(Duration.zero, 0, 0);
    const TimerClose.withSound(String sound)
      : super.withSound(Duration.zero, 0, 0, sound);
}
