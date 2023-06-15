import 'package:flutter/material.dart';
import 'dart:async';

import 'package:toothnow_pacient/list_dentist.dart';
import 'package:permission_handler/permission_handler.dart';

import 'maps.dart';
import 'rating.dart';

class TimerScreenDentist  extends StatefulWidget {
  final String? emergenciaId;
  TimerScreenDentist({required this.emergenciaId});

  @override
  _TimerScreenState createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreenDentist> {
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
              context, MaterialPageRoute(builder: (context) => LocalizacaoAtual(emergenciaId: widget.emergenciaId)));
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              getTimerText(),
              style: TextStyle(
                  fontSize: 48,
                  fontFamily: 'InterFonte',
                  fontWeight: FontWeight.w900),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: TextButton.styleFrom(
                  minimumSize: Size(327, 50),
                  backgroundColor: Colors.purple,
                  elevation: 0,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(50),
                      )
                  )
              ),
              onPressed: () async {
                final bool = await requestPermission();
                if (bool.isGranted) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LocalizacaoAtual(emergenciaId: widget.emergenciaId)));
                }},
              child: Text('Enviar localização',
                style: TextStyle(
                  fontFamily: 'InterFonte',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(height: 15),
            ElevatedButton(
              style: TextButton.styleFrom(
                  minimumSize: Size(327, 50),
                  backgroundColor: Colors.purple,
                  elevation: 0,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(50),
                      )
                  )
              ),
              onPressed: () {
                // Lógica do segundo botão da localização pegando a latitude e longitude do firebase
              },
              child: Text('Receber localização',
                style: TextStyle(
                  fontFamily: 'InterFonte',
                  fontWeight: FontWeight.w600,
                ),),
            ),
          ],
        ),
      ),
    );
  }
}
