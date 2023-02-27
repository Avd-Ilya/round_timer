import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:round_timer/timer/ticker/ticker.dart';
import 'package:round_timer/timer/widgets/timer_widget.dart';
import '../bloc/timer_bloc.dart';

class TimerPage extends StatelessWidget {
  const TimerPage(
      {super.key,
      required this.roundTime,
      required this.restTime,
      required this.warningTime,
      required this.rounds});

  final Duration roundTime;
  final Duration restTime;
  final Duration warningTime;
  final int rounds;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TimerBloc(
          ticker: const Ticker(),
          roundTime: roundTime,
          restTime: restTime,
          warningTime: warningTime,
          rounds: rounds),
      child: TimerWidget(
        pageContext: context,
      ),
    );
  }
}
