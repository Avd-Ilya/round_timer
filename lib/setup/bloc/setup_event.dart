part of 'setup_bloc.dart';

@immutable
abstract class SetupEvent extends Equatable {

  @override
  List<Object?> get props => [];
}

class SetupRoundTimeChanged extends SetupEvent {
  SetupRoundTimeChanged({required this.roundTime});
  final Duration roundTime;

  @override
  List<Object?> get props => [roundTime];
}

class SetupRestTimeChanged extends SetupEvent {
  SetupRestTimeChanged({required this.restTime});
  final Duration restTime;

  @override
  List<Object?> get props => [restTime];
}

class SetupRoundsChanged extends SetupEvent {
  SetupRoundsChanged({required this.rounds});
  final int rounds;

  @override
  List<Object?> get props => [rounds];
}

class SetupWarningTimeChanged extends SetupEvent {
  SetupWarningTimeChanged({required this.warningTime});
  final Duration warningTime;

  @override
  List<Object?> get props => [warningTime];
}

class SetupStart extends SetupEvent {}

class SetupReturned extends SetupEvent {}