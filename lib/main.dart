import 'dart:io';
import 'package:flutter/material.dart';

// firebase
import 'firebase_options.dart';
import 'package:path/path.dart' as path;

import 'package:firebase_core/firebase_core.dart';

// firestore
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// camera
import 'package:camera/camera.dart';

List<CameraDescription> cameras = [];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  cameras = await availableCameras();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const appTitle = 'Ocorrências';

    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        appBar: null,
        body: const HomePage(),
      ),
    );
  }
}

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

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      cameras[0],
      ResolutionPreset.medium,
    );
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  FirebaseStorage storage = FirebaseStorage.instance;

  // tira a foto e salva no dispositivo
  Future<void> _takePicture() async {
    await _initializeControllerFuture;

    final XFile image = await _controller.takePicture();
    image.saveTo('images');

    String? downloadUrl = await uploadFile(File(image.path));

    if (downloadUrl != null) {
      print('Salvo com sucesso.');
    } else {
      print('Falha ao salvar o arquivo');
    }
  }

  Future<String?> uploadFile(File file) async {
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference storageReference = storage.ref().child(fileName);
      UploadTask uploadTask = storageReference.putFile(file);
      TaskSnapshot taskSnapshot = await uploadTask;

      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tire a foto da ocorrência'),
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_controller);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _takePicture();

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FormScreen()),
          );
        },
        child: Icon(Icons.camera),
      ),
    );
  }
}

class ListDentist extends StatefulWidget {
  const ListDentist({Key? key}) : super(key: key);

  @override
  State<ListDentist> createState() => _ListDentistState();
}

class _ListDentistState extends State<ListDentist> {


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: StreamBuilder(
          //Aqui ta aparecendo todos os dentistas presentes na coleção
          //Tem que fazer aparecer apenas os dentistas que aceitarem a notifcação da ocorrência
          stream: FirebaseFirestore.instance.collection('users').snapshots(),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView(
              children: snapshot.data!.docs.map((documents) {
                return ListTile(
                  leading: Icon(Icons.person),
                  title : Text(documents['nome']),
                    subtitle: Row(
                      children:
                      [Text(documents['telefone']),
                        Spacer(),
                        ElevatedButton(
                            child: Text('Aceitar'),
                            onPressed: (/*Adicionar aqui a lógica ao aceitar o dentista */) {},
                            style: TextButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    elevation: 15,
                                    shadowColor: Colors.lightGreen,

                        ),
                        )
                      ],
                    ),
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Criar ocorrência'),
      ),
      body: Center(
        child: ElevatedButton(
          style: TextButton.styleFrom(
            backgroundColor: Colors.purple,
            elevation: 15,
            shadowColor: Colors.purple,
          ),
          onPressed: () {
            // Lógica para o botão de emergência aqui
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CameraScreen()));
          },
          child: const Text(
            'Criar ocorrência',
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }
}