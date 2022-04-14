import 'package:camera/camera.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodandbody/screens/camera/bloc/camera_bloc.dart';
import 'package:foodandbody/screens/camera/show_body_result.dart';
import 'package:foodandbody/screens/camera/show_food_result.dart';

class Camera extends StatefulWidget {
  @override
  _CameraState createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  @override
  void initState() {
    _initializeCamera(_selectedCamera);
    _audioPlayer = AudioPlayer();
    super.initState();
  }

  late List<CameraDescription> _cameras;
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  late AudioPlayer _audioPlayer;
  int _selectedCamera = 1;
  bool _isBodyCamera = true;
  List<XFile> _bodyImage = [];

  Future<void> _initializeCamera(int cameraIndex) async {
    try {
      _cameras = await availableCameras();
      setState(() {
        _controller = CameraController(
            _cameras[cameraIndex], ResolutionPreset.high,
            imageFormatGroup: ImageFormatGroup.jpeg);
        _initializeControllerFuture = _controller.initialize();
      });
    } on CameraException catch (e) {
      print("Error initializing camera: $e");
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (!_controller.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      _controller.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initializeCamera(_selectedCamera);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Color(0xDD000000),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            onPressed: () {
              if (_cameras.length > 1) {
                setState(() {
                  _isBodyCamera = !_isBodyCamera;
                  _selectedCamera = _selectedCamera == 1 ? 0 : 1;
                  _initializeCamera(_selectedCamera);
                });
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("เกิดข้อผิดพลาด กรุณาลองใหม่อีกครั้ง",
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .merge(TextStyle(color: Colors.white))),
                  backgroundColor: Color(0x77000000),
                  duration: Duration(seconds: 2),
                ));
              }
            },
            icon: Icon(
              _isBodyCamera ? Icons.accessibility : Icons.fastfood,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return _controller.buildPreview();
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_isBodyCamera) {
            _takeBodyPhoto();
          } else {
            _takeFoodPhoto();
          }
        },
        elevation: 2,
        backgroundColor: Colors.white,
        shape: CircleBorder(
            side: BorderSide(width: 6, color: Colors.grey.withOpacity(0.5))),
      ),
    );
  }

  void _takeFoodPhoto() async {
    try {
      final image = await _controller.takePicture();
      context.read<CameraBloc>().add(GetPredicton(file: image));
      _showResult(isBodyCamera: _isBodyCamera);
    } catch (e) {
      print("Take a photo failed: $e");
    }
  }

  void _takeBodyPhoto() async {
    XFile _image;
    try {
      await _playSignal();
      await Future.delayed(Duration(seconds: 5), () async {
        _image = await _controller.takePicture();
        _bodyImage.add(_image);
        await _playSignal();
      });
      await Future.delayed(Duration(seconds: 5), () async {
        _image = await _controller.takePicture();
        _bodyImage.add(_image);
        await _playSignal();
      });
      _showResult(isBodyCamera: _isBodyCamera);
      _bodyImage.clear();
    } catch (e) {
      print("Take a photo failed: $e");
    }
  }

  _showResult({required bool isBodyCamera}) {
    return _isBodyCamera
        ? showModalBottomSheet(
            context: context,
            elevation: 6,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            builder: (context) {
              return ShowBodyResult();
            })
        : Navigator.push(
            context, MaterialPageRoute(builder: (context) => ShowFoodResult()));
  }

  _playSignal() async {
    await _audioPlayer.setAsset('assets/beep-sound.mp3');
    _audioPlayer.play();
  }
}
