import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:camera/camera.dart';
import 'package:main_app_flutter/pages/result_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

//Es del WidgetsBinding
class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  //INicializacion de camara
  void startCamera() {
    if (_cameraController != null) {
      _selectedCamera(_cameraController!.description);
    }
  }

  void stopCamera() {
    if (_cameraController != null) {
      _cameraController!.dispose();
    }
  }

  void _initCameraController(List<CameraDescription> cameras) {
    if (_cameraController != null) {
      return;
    }
    CameraDescription? camera;

    for (var i = 0; i < cameras.length; i++) {
      final CameraDescription current = cameras[i];
      if (current.lensDirection == CameraLensDirection.back) {
        camera = current;
        break;
      }
    }
    if (camera != null) {
      _selectedCamera(camera);
    }
  }

  bool _isGranted = false;
  late final Future<void> _future;
  CameraController? _cameraController;
  final textRecognizer = TextRecognizer();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _future = _requestCamera();
    //dispose para pararla segun el ciclo de vida del aplicativo
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    stopCamera();
    textRecognizer.close();
    super.dispose();
  }

  //Manejo de la camara
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      //app sin usarse
      stopCamera();
    } else if (state == AppLifecycleState.resumed &&
        _cameraController != null &&
        _cameraController!.value.isInitialized) {
      //app en uso
      startCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: const Text('OCR APP'),
        ),
        body: FutureBuilder(
          future: _future,
          builder: (context, snapshot) {
            return Stack(
              children: [
                if (_isGranted)
                  FutureBuilder<List<CameraDescription>>(
                    future: availableCameras(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        _initCameraController(snapshot.data!);
                        return Center(
                          child: CameraPreview(_cameraController!),
                        );
                      } else {
                        return const LinearProgressIndicator();
                      }
                    },
                  ),
                Container(
                  //alignment: Alignment.bottomCenter,
                  child: _isGranted
                      ? Column(
                          children: [
                            Expanded(
                              child: Container(),
                            ),
                            Container(
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 30.0),
                                child: MaterialButton(
                                  onPressed: _scan,
                                  color: Colors.deepPurple,
                                  textColor: Colors.white,
                                  //padding: EdgeInsets.all(16),
                                  //shape: CircleBorder(),
                                  child: const Text('Click para Escanear'),
                                ),
                              ),
                            )
                          ],
                        )
                      : const Center(
                          child: Text("Camera Off"),
                        ),
                )
              ],
            );
          },
        ));
  }

  Future<void> _requestCamera() async {
    final status = await Permission.camera.request();
    setState(() {
      _isGranted = status == PermissionStatus.granted;
    });
  }

  //Definicion de parametros de camara
  Future<void> _selectedCamera(CameraDescription camera) async {
    _cameraController =
        CameraController(camera, ResolutionPreset.max, enableAudio: false);
    await _cameraController!.initialize();

    if (!mounted) {
      return;
    }
    setState(() {});
  }

  Future<void> _scan() async {
    //Validar controlador
    if (_cameraController == null) return;
    final navigator = Navigator.of(context);

    try {
      final picture = await _cameraController!.takePicture();
      //POSIBLE ERROR DE FUNCIONALIDAD
      //final file = File(picture.path);
      final inputPicture = InputImage.fromFilePath(picture.path);
      final recognizer = await textRecognizer.processImage(inputPicture);
      await navigator.push(
        MaterialPageRoute(
          builder: (context) => ResultPage(
            text: recognizer.text,
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }
}


/*
theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
*/