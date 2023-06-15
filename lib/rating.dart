import 'package:flutter/material.dart';

class TelaAvaliacao extends StatefulWidget {
  @override
  _TelaAvaliacaoState createState() => _TelaAvaliacaoState();
}

class _TelaAvaliacaoState extends State<TelaAvaliacao> {
  double _avaliacaoDentist = 0;
  double _avaliacaoApp = 0;
  final controllerDentist = TextEditingController();
  final controllerApp = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null, /* AppBar(
        title: Text('Avaliação do Dentista'),
      ),*/
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Dê uma nota ao atendimento',
              style: TextStyle(
                fontSize: 25,
                fontFamily: 'InterFonte',
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.star, color: _avaliacaoDentist >= 1 ? Colors.amber : Colors.grey),
                  onPressed: () {
                    setState(() {
                      _avaliacaoDentist = 1;
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.star, color: _avaliacaoDentist >= 2 ? Colors.amber : Colors.grey),
                  onPressed: () {
                    setState(() {
                      _avaliacaoDentist = 2;
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.star, color: _avaliacaoDentist >= 3 ? Colors.amber : Colors.grey),
                  onPressed: () {
                    setState(() {
                      _avaliacaoDentist = 3;
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.star, color: _avaliacaoDentist >= 4 ? Colors.amber : Colors.grey),
                  onPressed: () {
                    setState(() {
                      _avaliacaoDentist = 4;
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.star, color: _avaliacaoDentist >= 5 ? Colors.amber : Colors.grey),
                  onPressed: () {
                    setState(() {
                      _avaliacaoDentist = 5;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 8),
            TextField(
              controller: controllerDentist,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Comente a respeito do Atendimento',
              ),
            ),
            SizedBox(height: 20),
            Text(
                'Dê uma nota ao aplicativo',
                style: TextStyle(
                  fontSize: 25,
                  fontFamily: 'InterFonte',
                  fontWeight: FontWeight.w400,
                ),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.star, color: _avaliacaoApp >= 1 ? Colors.amber : Colors.grey),
                  onPressed: () {
                    setState(() {
                      _avaliacaoApp = 1;
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.star, color: _avaliacaoApp >= 2 ? Colors.amber : Colors.grey),
                  onPressed: () {
                    setState(() {
                      _avaliacaoApp = 2;
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.star, color: _avaliacaoApp >= 3 ? Colors.amber : Colors.grey),
                  onPressed: () {
                    setState(() {
                      _avaliacaoApp = 3;
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.star, color: _avaliacaoApp >= 4 ? Colors.amber : Colors.grey),
                  onPressed: () {
                    setState(() {
                      _avaliacaoApp = 4;
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.star, color: _avaliacaoApp >= 5 ? Colors.amber : Colors.grey),
                  onPressed: () {
                    setState(() {
                      _avaliacaoApp = 5;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 8),
            TextField(
              controller: controllerApp,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Comente a respeito do Aplicativo',
              ),
            ),
            SizedBox(height: 25),
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
                // Enviar avaliação
                print('Avaliação do Dentista: $_avaliacaoDentist');
                print(controllerDentist.text);
                print('Avaliação do App: $_avaliacaoApp');
                print(controllerApp.text);
              },
              child: Text('Enviar Avaliação',
                style: TextStyle(
                  fontFamily: 'InterFonte',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
