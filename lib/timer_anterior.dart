import 'package:flutter/material.dart';
import 'dart:async';

import 'package:toothnow_pacient/list_dentist.dart';
import 'package:permission_handler/permission_handler.dart';

import 'maps.dart';
import 'rating.dart';

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
      appBar: AppBar(
        title: Text('Timer'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              getTimerText(),
              style: TextStyle(fontSize: 48),
            ),
            SizedBox(height: 20),
            Text(
              "Aguardando dentistas da região",
              style: TextStyle(fontSize: 51)
            )
          ],
        ),
      ),
    );
  }
}
