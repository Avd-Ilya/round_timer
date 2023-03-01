import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/timer_bloc.dart';

class TimerWidget extends StatelessWidget {
  const TimerWidget({super.key, required this.pageContext});

  final BuildContext pageContext;

  void reset() {
    Future.delayed(Duration.zero, () {
      Navigator.pop(pageContext);
    });
  }

  Color backgroundColor(TimerState state) {
    if (state is TimerRun) {
      return Colors.green;
    }
    if (state is TimerWarning) {
      return Colors.red;
    }
    if (state is TimerRest) {
      return Colors.yellow;
    }
    return Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.dark,
      child: BlocBuilder<TimerBloc, TimerState>(
        builder: (context, state) {
          if (state.sound != null) {
            AudioPlayer().play(AssetSource(state.sound ?? ''));
          }
          if (state is TimerInitial) {
            context.read<TimerBloc>().add(TimerStarted());
          }
          if (state is TimerClose) {
            debugPrint('close');
            reset();
          }
          debugPrint('$state');
          return Scaffold(
            body: Container(
              color: backgroundColor(state),
              child: SafeArea(
                child: Center(
                  child: Column(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  Visibility(
                                    visible: state is TimerRun ||
                                        state is TimerWarning,
                                    child: Text(
                                      'ROUND ${context.select((TimerBloc bloc) => bloc.state.currentRound)} OF ${context.select((TimerBloc bloc) => bloc.state.rounds)}',
                                      style: const TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    visible: state is TimerRest,
                                    child: const Text(
                                      'REST',
                                      style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                // timeText(state),
                                context.select((TimerBloc bloc) => bloc
                                    .state.duration
                                    .toString()
                                    .substring(2, 7)),
                                style: const TextStyle(
                                  fontSize: 70,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width:
                            MediaQuery.of(context).copyWith().size.width - 50,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: CupertinoButton(
                            color: Colors.black,
                            child: const Text(
                              'Reset',
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onPressed: () {
                              context.read<TimerBloc>().add(TimerEnd());
                            },
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
