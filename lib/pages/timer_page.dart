import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TimerPage extends StatefulWidget {
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
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  Timer? timer;
  var time = const Duration();
  final player = AudioPlayer();

  late Duration roundTime;
  late Duration restTime;
  late Duration warningTime;
  late int rounds;
  var currentRound = 1;
  var isRound = true;
  var isWarning = false;

  @override
  void initState() {
    super.initState();

    roundTime = widget.roundTime;
    restTime = widget.restTime;
    warningTime = widget.warningTime;
    rounds = widget.rounds;
    startTimer();
  }

  void startTimer() {
    time = roundTime;
    if (time.inSeconds > 0) {
      var step = const Duration(seconds: 1);
      player.play(AssetSource('start.mp3'));
      timer = Timer.periodic(
        step,
        (timer) {
          debugPrint('startTimer');
          setState(
            () {
              time -= step;
              if (time.inSeconds == warningTime.inSeconds) {
                isWarning = true;
                player.play(AssetSource('warning.mp3'));
              }
              if (time.inSeconds == 0) {
                timer.cancel();
                currentRound += 1;
                isWarning = false;
                if (currentRound <= rounds) {
                  isRound = false;
                  startRestTimer();
                } else {
                  reset();
                }
              }
            },
          );
        },
      );
    }
  }

  void startRestTimer() {
    player.play(AssetSource('alert.mp3'));
    var step = const Duration(seconds: 1);
    time = restTime;

    timer = Timer.periodic(
      step,
      (timer) {
        debugPrint('startRestTimer');
        setState(
          () {
            time -= step;
            if (time.inSeconds == 0) {
              timer.cancel();
              isRound = true;
              startTimer();
            }
          },
        );
      },
    );
  }

  void reset() {
    Navigator.pop(context);
  }

  Color backgroundColor() {
    if (isWarning) {
      return Colors.red;
    } else {
      return isRound ? Colors.green : Colors.yellow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        body: Container(
          color: backgroundColor(),
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
                                visible: isRound,
                                child: Text(
                                  'ROUND $currentRound OF $rounds',
                                  style: const TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: !isRound,
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
                            time.toString().substring(2, 7),
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
                    width: MediaQuery.of(context).copyWith().size.width - 50,
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
                          reset();
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
      ),
    );
  }
}
