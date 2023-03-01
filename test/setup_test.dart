import 'package:flutter_test/flutter_test.dart';
import 'package:round_timer/setup/bloc/setup_bloc.dart';
import 'package:bloc_test/bloc_test.dart';

void main() {
    group("Setup", () {
    late SetupBloc setupBloc;

    setUp(() {
      setupBloc = SetupBloc();
    });

    blocTest<SetupBloc, SetupState>(
      'emits [SetupUpdated] when SetupRoundTimeChanged is added.',
      setUp: () {
        setupBloc.roundTime = Duration.zero;
        setupBloc.restTime = Duration.zero;
        setupBloc.warningTime = Duration.zero;
        setupBloc.rounds = 0;
      },
      build: () => setupBloc,
      act: (bloc) => bloc
          .add(SetupRoundTimeChanged(roundTime: const Duration(seconds: 1))),
      expect: () => const <SetupState>[
        SetupUpdated(Duration(seconds: 1), Duration.zero, Duration.zero, 0)
      ],
    );

    blocTest<SetupBloc, SetupState>(
      'emits [SetupUpdated] when SetupRestTimeChanged is added.',
      setUp: () {
        setupBloc.roundTime = Duration.zero;
        setupBloc.restTime = Duration.zero;
        setupBloc.warningTime = Duration.zero;
        setupBloc.rounds = 0;
      },
      build: () => setupBloc,
      act: (bloc) =>
          bloc.add(SetupRestTimeChanged(restTime: const Duration(seconds: 1))),
      expect: () => const <SetupState>[
        SetupUpdated(Duration.zero, Duration(seconds: 1), Duration.zero, 0)
      ],
    );

    blocTest<SetupBloc, SetupState>(
      'emits [SetupUpdated] when SetupWarningTimeChanged is added.',
      setUp: () {
        setupBloc.roundTime = Duration.zero;
        setupBloc.restTime = Duration.zero;
        setupBloc.warningTime = Duration.zero;
        setupBloc.rounds = 0;
      },
      build: () => setupBloc,
      act: (bloc) => bloc.add(
          SetupWarningTimeChanged(warningTime: const Duration(seconds: 1))),
      expect: () => const <SetupState>[
        SetupUpdated(Duration.zero, Duration.zero, Duration(seconds: 1), 0)
      ],
    );

    blocTest<SetupBloc, SetupState>(
      'emits [SetupUpdated] when SetupRoundsChanged is added.',
      setUp: () {
        setupBloc.roundTime = Duration.zero;
        setupBloc.restTime = Duration.zero;
        setupBloc.warningTime = Duration.zero;
        setupBloc.rounds = 0;
      },
      build: () => setupBloc,
      act: (bloc) => bloc.add(SetupRoundsChanged(rounds: 1)),
      expect: () => const <SetupState>[
        SetupUpdated(Duration.zero, Duration.zero, Duration.zero, 1)
      ],
    );

    blocTest<SetupBloc, SetupState>(
      'emits [SetupStartTimer] when SetupStart is added.',
      setUp: () {
        setupBloc.roundTime = Duration.zero;
        setupBloc.restTime = Duration.zero;
        setupBloc.warningTime = Duration.zero;
        setupBloc.rounds = 0;
      },
      build: () => setupBloc,
      act: (bloc) => bloc.add(SetupStart()),
      expect: () => const <SetupState>[
        SetupStartTimer(Duration.zero, Duration.zero, Duration.zero, 0)
      ],
    );

    blocTest<SetupBloc, SetupState>(
      'emits [SetupUpdated] when SetupReturned is added.',
      setUp: () {
        setupBloc.roundTime = Duration.zero;
        setupBloc.restTime = Duration.zero;
        setupBloc.warningTime = Duration.zero;
        setupBloc.rounds = 0;
      },
      build: () => setupBloc,
      act: (bloc) => bloc.add(SetupReturned()),
      expect: () => const <SetupState>[
        SetupUpdated(Duration.zero, Duration.zero, Duration.zero, 0)
      ],
    );

    tearDown(() {
      setupBloc.close();
    });
  });
}
