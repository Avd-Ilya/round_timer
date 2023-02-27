import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:round_timer/timer/pages/timer_page.dart';
import '../../widgets/framed_cell.dart';
import '../bloc/setup_bloc.dart';

class SetupPage extends StatefulWidget {
  const SetupPage({super.key});

  @override
  State<SetupPage> createState() => _SetupPageState();
}

class _SetupPageState extends State<SetupPage> {
  late FixedExtentScrollController roundsScrollController;
  int numberRounds = 30;

  @override
  void initState() {
    super.initState();

    roundsScrollController = FixedExtentScrollController(initialItem: 1);
  }

  @override
  void dispose() {
    roundsScrollController.dispose();
    super.dispose();
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

  int groupValue(SetupState state) {
    switch (state.warningTime.inSeconds) {
      case 0:
        return 0;
      case 10:
        return 1;
      case 30:
        return 2;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SetupBloc, SetupState>(
      builder: (context, state) {
        if (state is SetupStartTimer) {
          Future.delayed(Duration.zero, () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return TimerPage(
                    roundTime: state.roundTime,
                    restTime: state.restTime,
                    warningTime: state.warningTime,
                    rounds: state.rounds,
                  );
                },
              ),
            ).then((_) {
              context.read<SetupBloc>().add(SetupReturned());
            });
          });
        }
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
                                    initialTimerDuration:
                                        state.roundTime, //roundTime,
                                    mode: CupertinoTimerPickerMode.ms,
                                    onTimerDurationChanged: (value) {
                                      context.read<SetupBloc>().add(
                                            SetupRoundTimeChanged(
                                                roundTime: value),
                                          );
                                    },
                                  ),
                                ),
                              );
                            },
                            child: Text(
                                state.roundTime.toString().substring(2, 7)),
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
                                    initialTimerDuration: state.restTime,
                                    mode: CupertinoTimerPickerMode.ms,
                                    onTimerDurationChanged: (value) {
                                      context.read<SetupBloc>().add(
                                            SetupRestTimeChanged(
                                                restTime: value),
                                          );
                                    },
                                  ),
                                ),
                              );
                            },
                            child:
                                Text(state.restTime.toString().substring(2, 7)),
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
                              roundsScrollController =
                                  FixedExtentScrollController(
                                      initialItem: state.rounds - 1);
                              showCupertinoModalPopup(
                                context: context,
                                builder: (context) => buildPicker(
                                  'Number of rounds',
                                  CupertinoPicker(
                                    scrollController: roundsScrollController,
                                    itemExtent: 30,
                                    onSelectedItemChanged: (value) {
                                      context.read<SetupBloc>().add(
                                            SetupRoundsChanged(
                                                rounds: value + 1),
                                          );
                                    },
                                    children: List<Widget>.generate(
                                        numberRounds, (index) {
                                      return Text('${index + 1}');
                                    }),
                                  ),
                                ),
                              );
                            },
                            child: Text('${state.rounds}'),
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
                              groupValue: groupValue(state),
                              children: const {
                                0: Text('OFF'),
                                1: Text('10 sec.'),
                                2: Text('30 sec.'),
                              },
                              onValueChanged: (value) {
                                var warningIndex = value ?? 0;
                                var warningTime = const Duration(seconds: 0);
                                switch (warningIndex) {
                                  case 0:
                                    break;
                                  case 1:
                                    warningTime = const Duration(seconds: 10);
                                    break;
                                  case 2:
                                    warningTime = const Duration(seconds: 30);
                                    break;
                                  default:
                                }
                                context.read<SetupBloc>().add(
                                      SetupWarningTimeChanged(
                                        warningTime: warningTime,
                                      ),
                                    );
                              },
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(),
                      ),
                      SizedBox(
                        width:
                            MediaQuery.of(context).copyWith().size.width - 50,
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
                              context.read<SetupBloc>().add(SetupStart());
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
      },
    );
  }
}
