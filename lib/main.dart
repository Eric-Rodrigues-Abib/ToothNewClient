import 'dart:convert';
import 'dart:io';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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

// A screen that allows users to take a picture using a given camera.
class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({
    super.key,
    required this.camera,
  });

  final CameraDescription camera;

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tire uma foto')),
      // You must wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner until the
      // controller has finished initializing.
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return CameraPreview(_controller);
          } else {
            // Otherwise, display a loading indicator.
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        // Provide an onPressed callback.
        onPressed: () async {
          // Take the Picture in a try / catch block. If anything goes wrong,
          // catch the error.
          try {
            // Ensure that the camera is initialized.
            await _initializeControllerFuture;

            // Attempt to take a picture and get the file `image`
            // where it was saved.
            final image = await _controller.takePicture();

            if (!mounted) return;

            // If the picture was taken, display it on a new screen.
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DisplayPictureScreen(
                  // Pass the automatically generated path to
                  // the DisplayPictureScreen widget.
                  imagePath: image.path,
                ),
              ),
            );
          } catch (e) {
            // If an error occurs, log the error to the console.
            print(e);
          }
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({super.key, required this.imagePath});

  /*
Future<void> _takePicture() async {
  await _controller;

  final image = await _controller.takePicture();
  image.saveTo('images');

  String? downloadUrl = await uploadFile(File(image.path));
  print(downloadUrl);

  if (downloadUrl != null) {
    print('Salvo com sucesso.');
  } else {
    print('Falha ao salvar o arquivo');
  }
}

*/

  Future<String?> uploadFile(File file) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference storageReference = storage.ref().child(fileName);
      UploadTask uploadTask = storageReference.putFile(file);
      TaskSnapshot taskSnapshot = await uploadTask;

      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: AppBar(title: const Text('Visualize a foto')),
        // The image is stored as a file on the device. Use the `Image.file`
        // constructor with the given path to display the image. */
      body: Row(
        children: [
          Expanded(
              child: Stack(
            children: [
              Positioned.fill(
                child: Image.file(File(imagePath), fit: BoxFit.cover),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                        padding: EdgeInsets.all(32),
                        child: CircleAvatar(
                          radius: 32,
                          backgroundColor: Colors.purple.withOpacity(0.5),
                          child: IconButton(
                            icon: Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 30,
                            ),
                            // Provide an onPressed callback.
                            onPressed: () async {
                              uploadFile(File(imagePath)).then((value) => {
                                print(value),
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => FormScreen(imageUrl: value)))
                                  });
                            },
                          ),
                        )),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                        padding: EdgeInsets.all(32),
                        child: CircleAvatar(
                          radius: 32,
                          backgroundColor: Colors.purple.withOpacity(0.5),
                          child: IconButton(
                            icon: Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 30,
                            ),
                            // Provide an onPressed callback.
                            onPressed: () async {
                              final firstCamera = cameras.first;
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => TakePictureScreen(
                                          camera: firstCamera)));
                            },
                          ),
                        )),
                  )
                ],
              )
            ],
          ))
        ],
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
          onPressed: () async {
            // Obtain a list of the available cameras on the device.
            final cameras = await availableCameras();
            // Get a specific camera from the list of available cameras.
            final firstCamera = cameras.first;
            // Lógica para o botão de emergência aqui
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TakePictureScreen(
                    // Pass the appropriate camera to the TakePictureScreen widget.
                    camera: firstCamera,
                  ),
                ));
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
