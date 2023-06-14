import 'dart:convert';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'timer_anterior.dart';

class FormScreen extends StatefulWidget {
 final String? imageUrl;

  FormScreen({required this.imageUrl});

  @override
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  Future<String?> adicionarFormu(String nome, String phone) async {
    String? token = await FirebaseMessaging.instance.getToken();

    try {
      final result = await FirebaseFunctions.instanceFor(
          region: "southamerica-east1")
          .httpsCallable("SetDadosSocorristas")
          .call(({
        "nome": nome,
        "telefone": phone,
        "fcmToken": token,
        "foto": widget.imageUrl
      }));

      String response = result.data as String;
      Map<dynamic, dynamic> userData = json.decode(response);
      Map<dynamic, dynamic> userPayload = json.decode(userData['payload']);

      return userPayload['docId'] as String;
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null /*AppBar(
        title: Text('Formulário da ocorrência'),
      )*/,
      body: Padding(
        padding: const EdgeInsets.only(left:20, bottom:25, right: 20, top: 55),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text('Preencha o Formulário de identificação abaixo', style: TextStyle(
                  fontFamily: 'InterFonte',fontWeight: FontWeight.w600,fontSize: 30, color: Colors.purple)),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nome',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira um nome.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'Telefone',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira um telefone.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
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
                onPressed: () => {
                  //Salva os dados do Socorrista na coleção DadosSocorrista
                  adicionarFormu(_nameController.text, _phoneController.text).then((value) => {
                    print(value),
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TimerScreen(emergenciaId: value)))
                  }),
                },
                child: Text('Enviar Dados',
                  style: TextStyle(
                    fontFamily: 'InterFonte',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}