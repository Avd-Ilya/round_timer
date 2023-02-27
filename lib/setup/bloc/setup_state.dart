part of 'setup_bloc.dart';

@immutable
abstract class SetupState extends Equatable {
  const SetupState(
      this.roundTime, this.restTime, this.warningTime, this.rounds);
  final Duration roundTime;
  final Duration restTime;
  final Duration warningTime;
  final int rounds;

  @override
  List<Object?> get props => [roundTime, restTime, warningTime, rounds];
}

class SetupInitial extends SetupState {
  const SetupInitial(
      super.roundTime, super.restTime, super.warningTime, super.rounds);
}

class SetupUpdated extends SetupState {
  const SetupUpdated(
      super.roundTime, super.restTime, super.warningTime, super.rounds);
}

class SetupStartTimer extends SetupState {
  const SetupStartTimer(
      super.roundTime, super.restTime, super.warningTime, super.rounds);
}
