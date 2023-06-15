import 'package:flutter/material.dart';
import 'dart:async';

import 'package:toothnow_pacient/list_dentist.dart';
import 'package:permission_handler/permission_handler.dart';

import 'maps.dart';
import 'rating.dart';
import 'dentist_timer.dart';

class TimerScreen extends StatefulWidget {
  final String? emergenciaId;

  TimerScreen({required this.emergenciaId});

  @override
  _TimerScreenState createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  int secondsRemaining = 90;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      setState(() {
        if (secondsRemaining < 1) {
          timer.cancel();

          Navigator.push(
              context, MaterialPageRoute(builder: (context) => ListDentist(emergenciaId: widget.emergenciaId)));
          // remover da lista do firebase
        } else {
          secondsRemaining--;
        }
      });
    });
  }

  String getTimerText() {
    // transforma minuto em segundo
    int minutes = secondsRemaining ~/ 60;
    int seconds = secondsRemaining % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  Future<PermissionStatus> requestPermission() async {
    var status = await Permission.location.request();
    return status;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Padding(
        padding: const EdgeInsets.only(left:20, right: 20, top: 55),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
                "Aguardando os Dentistas da região",
                style: TextStyle(
                    fontSize: 30,
                    fontFamily: 'InterFonte',
                    fontWeight: FontWeight.w500,
                    color: Colors.purple)
            ),
            SizedBox(height: 40),
            Text(
              getTimerText(),
              style: TextStyle(
                fontSize: 48,
                fontFamily: 'InterFonte',
                fontWeight: FontWeight.w900),
            )
          ],
        ),
      ),
    );
  }
}
