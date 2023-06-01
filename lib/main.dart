import 'dart:io';
import 'package:flutter/material.dart';

//arquivos .dart
import 'messaging.dart';
import 'form_screen.dart';

// firebase
import 'firebase_options.dart';
import 'package:path/path.dart' as path;

import 'package:firebase_core/firebase_core.dart';

// firestore
import 'package:firebase_storage/firebase_storage.dart';


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