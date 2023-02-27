import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:round_timer/setup/pages/setup_page.dart';
import 'setup/bloc/setup_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SetupBloc(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SetupPage(),
      ),
    );
  }
}
