import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'list_dentist.dart';


class FormScreen extends StatefulWidget {
  @override
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  CollectionReference DadosSocorristas = FirebaseFirestore.instance.collection('DadosSocorristas');
  Future<void> adicionarFormu(String nome, String phone) {
    return DadosSocorristas
        .add({
      'nome': nome,
      'phone': phone
    }).then((value) => print("Ocorrência Criada"))
        .catchError((error) => print("Erro ao adicionar os dados da ocorrência: $error"));
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
      appBar: AppBar(
        title: Text('Formulário da ocorrência'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
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
                  backgroundColor: Colors.purple,
                  elevation: 15,
                  shadowColor: Colors.purple,
                ),
                onPressed: () => {
                  //Salva os dados do Socorrista na coleção DadosSocorrista
                  adicionarFormu(_nameController.text, _phoneController.text),
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ListDentist()))
                },
                child: Text('Enviar Dados'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}