import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:round_timer/timer/bloc/timer_bloc.dart';
import 'package:round_timer/timer/ticker/ticker.dart';

void main() {
  // TestWidgetsFlutterBinding.ensureInitialized();
  group('Timer', () {
    late TimerBloc timerBloc = TimerBloc(
        ticker: const Ticker(),
        roundTime: Duration.zero,
        restTime: Duration.zero,
        warningTime: Duration.zero,
        rounds: 0);

    setUp(() {
      timerBloc = TimerBloc(
          ticker: const Ticker(),
          roundTime: const Duration(seconds: 5),
          restTime: const Duration(seconds: 2),
          warningTime: const Duration(seconds: 3),
          rounds: 2);
    });

    blocTest<TimerBloc, TimerState>(
      'Start',
      build: () => timerBloc,
      act: (bloc) => bloc.add(TimerStarted()),
      expect: () => const <TimerState>[
        TimerRun(Duration(seconds: 5), 2, 1),
      ],
    );

    blocTest<TimerBloc, TimerState>(
      'Round => warning',
      build: () => timerBloc,
      act: (bloc) =>
          bloc.add(const TimerTicked(duration: Duration(seconds: 3))),
      expect: () => const <TimerState>[
        TimerWarning(Duration(seconds: 3), 2, 1),
      ],
    );

    blocTest<TimerBloc, TimerState>(
      'Round => rest',
      build: () => timerBloc,
      act: (bloc) =>
          bloc.add(const TimerTicked(duration: Duration(seconds: 0))),
      expect: () => const <TimerState>[
        TimerRun(Duration(seconds: 0), 2, 1),
      ],
      verify: (bloc) {
        return bloc.statusTimer == StatusTimer.rest;
      },
    );

    blocTest<TimerBloc, TimerState>(
      'Warning => rest',
      setUp: () {
        timerBloc.statusTimer = StatusTimer.warning;
      },
      build: () => timerBloc,
      act: (bloc) =>
          bloc.add(const TimerTicked(duration: Duration(seconds: 0))),
      expect: () => const <TimerState>[
        TimerWarning(Duration(seconds: 0), 2, 1),
      ],
      verify: (bloc) {
        return bloc.statusTimer == StatusTimer.rest;
      },
    );

    blocTest<TimerBloc, TimerState>(
      'Rest => round',
      setUp: () {
        timerBloc.statusTimer = StatusTimer.rest;
      },
      build: () => timerBloc,
      act: (bloc) =>
          bloc.add(const TimerTicked(duration: Duration(seconds: 0))),
      expect: () => const <TimerState>[
        TimerRest(Duration(seconds: 0), 2, 1),
      ],
      verify: (bloc) {
        return bloc.statusTimer == StatusTimer.round;
      },
    );

    blocTest<TimerBloc, TimerState>(
      'Round => end',
      setUp: () {
        timerBloc.currentRound = 2;
      },
      build: () => timerBloc,
      act: (bloc) =>
          bloc.add(const TimerTicked(duration: Duration(seconds: 0))),
      expect: () => const <TimerState>[
        TimerClose(),
      ],
    );
    
    tearDown(() {
      timerBloc.close();
    });
  });
}
