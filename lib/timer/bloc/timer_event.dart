part of 'timer_bloc.dart';

@immutable
abstract class TimerEvent extends Equatable {
  const TimerEvent();

  @override
  List<Object?> get props => [];
}

class TimerStarted extends TimerEvent {}

class TimerEnd extends TimerEvent {}

class _TimerTicked extends TimerEvent {
  const _TimerTicked({required this.duration});
  final Duration duration;

  @override
  List<Object?> get props => [duration];
}
