import 'package:flutter/material.dart';
import 'dart:async';

import 'package:toothnow_pacient/list_dentist.dart';
import 'package:permission_handler/permission_handler.dart';

import 'maps.dart';
import 'rating.dart';

class TimerScreen extends StatefulWidget {
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
              context, MaterialPageRoute(builder: (context) => ListDentist()));
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
            ElevatedButton(
              onPressed: () async {
                final bool = await requestPermission();
                if (bool.isGranted) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LocalizacaoAtual()));
                }},
              child: Text('Enviar localização'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Lógica do segundo botão
              },
              child: Text('Receber localização'),
            ),
          ],
        ),
      ),
    );
  }
}
