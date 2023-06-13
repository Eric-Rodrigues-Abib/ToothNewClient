import 'package:flutter/material.dart';

class TelaAvaliacao extends StatefulWidget {
  @override
  _TelaAvaliacaoState createState() => _TelaAvaliacaoState();
}

class _TelaAvaliacaoState extends State<TelaAvaliacao> {
  double _avaliacao = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Avaliação do Dentista'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Avalie o atendimento do dentista:',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.star, color: _avaliacao >= 1 ? Colors.amber : Colors.grey),
                  onPressed: () {
                    setState(() {
                      _avaliacao = 1;
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.star, color: _avaliacao >= 2 ? Colors.amber : Colors.grey),
                  onPressed: () {
                    setState(() {
                      _avaliacao = 2;
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.star, color: _avaliacao >= 3 ? Colors.amber : Colors.grey),
                  onPressed: () {
                    setState(() {
                      _avaliacao = 3;
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.star, color: _avaliacao >= 4 ? Colors.amber : Colors.grey),
                  onPressed: () {
                    setState(() {
                      _avaliacao = 4;
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.star, color: _avaliacao >= 5 ? Colors.amber : Colors.grey),
                  onPressed: () {
                    setState(() {
                      _avaliacao = 5;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Enviar avaliação
                print('Avaliação: $_avaliacao');
              },
              child: Text('Enviar Avaliação'),
            ),
          ],
        ),
      ),
    );
  }
}
