import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:round_timer/pages/timer_page.dart';
import '../widgets/framed_cell.dart';

class SetupPage extends StatefulWidget {
  const SetupPage({super.key});

  @override
  State<SetupPage> createState() => _SetupPageState();
}

class _SetupPageState extends State<SetupPage> {
  var roundTime = const Duration(seconds: 10);
  var restTime = const Duration(seconds: 5);
  var warningTime = const Duration(seconds: 0);
  int numberRounds = 20;
  int indexRounds = 3;
  int warningIndex = 0;
  late FixedExtentScrollController roundsScrollController;

  @override
  void initState() {
    super.initState();

    roundsScrollController =
        FixedExtentScrollController(initialItem: indexRounds);
  }

  @override
  void dispose() {
    roundsScrollController.dispose();

    super.dispose();
  }

  void start() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return TimerPage(
            roundTime: roundTime,
            restTime: restTime,
            warningTime: warningTime,
            rounds: indexRounds + 1,
          );
        },
      ),
    );
  }

    Widget buildPicker(String title, Widget child) {
    return Container(
      height: MediaQuery.of(context).copyWith().size.height / 3,
      color: CupertinoColors.systemBackground.resolveFrom(context),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                  decorationColor: Colors.white,
                ),
              ),
            ),
            Expanded(
              child: child,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        body: Container(
          color: Colors.white,
          child: SafeArea(
            child: Center(
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  FramedCell(
                    children: [
                      const Text(
                        'Round time:',
                        style: TextStyle(fontSize: 18),
                      ),
                      CupertinoButton(
                        onPressed: () {
                          showCupertinoModalPopup(
                            context: context,
                            builder: (context) => buildPicker(
                              'Round time',
                              CupertinoTimerPicker(
                                initialTimerDuration: roundTime,
                                mode: CupertinoTimerPickerMode.ms,
                                onTimerDurationChanged: (value) {
                                  setState(() {
                                    roundTime = value;
                                  });
                                },
                              ),
                            ),
                          );
                        },
                        child: Text(roundTime.toString().substring(2, 7)),
                      )
                    ],
                  ),
                  FramedCell(
                    children: [
                      const Text(
                        'Rest time:',
                        style: TextStyle(fontSize: 18),
                      ),
                      CupertinoButton(
                        onPressed: () {
                          showCupertinoModalPopup(
                            context: context,
                            builder: (context) => buildPicker(
                              'Rest time',
                              CupertinoTimerPicker(
                                initialTimerDuration: restTime,
                                mode: CupertinoTimerPickerMode.ms,
                                onTimerDurationChanged: (value) {
                                  setState(() {
                                    restTime = value;
                                  });
                                },
                              ),
                            ),
                          );
                        },
                        child: Text(restTime.toString().substring(2, 7)),
                      )
                    ],
                  ),
                  FramedCell(
                    children: [
                      const Text(
                        'Number of rounds:',
                        style: TextStyle(fontSize: 18),
                      ),
                      CupertinoButton(
                        onPressed: () {
                          roundsScrollController.dispose;
                          roundsScrollController = FixedExtentScrollController(
                              initialItem: indexRounds);
                          showCupertinoModalPopup(
                            context: context,
                            builder: (context) => buildPicker(
                              'Number of rounds',
                              CupertinoPicker(
                                scrollController: roundsScrollController,
                                itemExtent: 30,
                                onSelectedItemChanged: (value) {
                                  setState(() {
                                    indexRounds = value;
                                  });
                                },
                                children: List<Widget>.generate(numberRounds,
                                    (index) {
                                  return Text('${index + 1}');
                                }),
                              ),
                            ),
                          );
                        },
                        child: Text('${indexRounds + 1}'),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 50,
                    child: FramedCell(
                      children: [
                        const Text(
                          'Warning:',
                          style: TextStyle(fontSize: 18),
                        ),
                        CupertinoSlidingSegmentedControl(
                          groupValue: warningIndex,
                          children: const {
                            0: Text('OFF'),
                            1: Text('10 sec.'),
                            2: Text('30 sec.'),
                          },
                          onValueChanged: (value) {
                            setState(() {
                              warningIndex = value ?? 0;
                              switch (warningIndex) {
                                case 0:
                                  warningTime = const Duration(seconds: -1);
                                  break;
                                case 1:
                                  warningTime = const Duration(seconds: 10);
                                  break;
                                case 2:
                                  warningTime = const Duration(seconds: 30);
                                  break;
                                default:
                              }
                            });
                          },
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).copyWith().size.width - 50,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: CupertinoButton(
                        color: Colors.red,
                        child: const Text(
                          'START',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () {
                          start();
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
