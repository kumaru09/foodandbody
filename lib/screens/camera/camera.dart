import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodandbody/repositories/camera_repository.dart';
import 'package:foodandbody/screens/camera/ar_camera.dart';
import 'package:foodandbody/screens/camera/bloc/camera_bloc.dart';
import 'package:foodandbody/screens/camera/show_body_result.dart';
import 'package:foodandbody/screens/camera/show_food_result.dart';
import 'package:foodandbody/services/arcore_service.dart';

class Camera extends StatefulWidget {
  @override
  _CameraState createState() => _CameraState();
}

class _CameraState extends State<Camera> with WidgetsBindingObserver {
  List<CameraDescription> _cameras = [];
  CameraController? _controller;

  String errorMessage = '';
  int _selected = 1;
  bool _isFoodCamera = false;

  @override
  void initState() {
    setupCamera();
    WidgetsBinding.instance?.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (_controller == null || !_controller!.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      _controller?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      setupCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    final CameraController? cameraController = _controller;

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
              onPressed: () async {
                if (context.read<ARCoreService>().isSupportDepth ==
                    ARStatus.initial)
                  await context.read<ARCoreService>().isARCoreSupported();
                if (context.read<ARCoreService>().isSupportDepth ==
                    ARStatus.support) {
                  Navigator.of(context).pushReplacement((MaterialPageRoute(
                      builder: (context) => ARCamera(
                          arCoreService: context.read<ARCoreService>()))));
                } else {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(SnackBar(
                      content:
                          Text('${context.read<ARCoreService>().errorMessage}'),
                    ));
                }
              },
              icon: Text('AR')),
          IconButton(
            onPressed: () {
              if (_cameras.length > 1) {
                setState(() {
                  _isFoodCamera = !_isFoodCamera;
                  _selected = _selected == 0 ? 1 : 0;
                  selectCamera(_selected);
                });
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("เกิดข้อผิดพลาด กรุณาลองใหม่อีกครั้ง",
                      style: TextStyle(color: Colors.white)),
                  backgroundColor: Color(0x99000000),
                  duration: Duration(seconds: 2),
                ));
              }
            },
            icon: Icon(
              _isFoodCamera ? Icons.fastfood : Icons.accessibility,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: (cameraController == null || !cameraController.value.isInitialized)
          ? Center(child: CircularProgressIndicator())
          : Center(
              child: cameraController.buildPreview(),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (_isFoodCamera) {
            try {
              final image = await cameraController?.takePicture();
              context.read<CameraBloc>().add(GetPredicton(file: image!));
              _showResult(isFoodCamera: _isFoodCamera, imagePath: image.path);
            } catch (e) {
              print("Take a photo failed: $e");
            }
          }
        },
        elevation: 2,
        backgroundColor: Colors.white,
        shape: CircleBorder(
            side: BorderSide(width: 6, color: Colors.grey.withOpacity(0.5))),
      ),
    );
  }

  Future<void> setupCamera() async {
    try {
      _cameras = await availableCameras();
      CameraController controller = await selectCamera(_selected);
      setState(() {
        _controller = controller;
      });
      print("cameras list: $_cameras");
    } on CameraException catch (e) {
      print("error in fetching the camera: $e");
    }
  }

  selectCamera(int index) async {
    try {
      CameraController controller = CameraController(
          _cameras[index], ResolutionPreset.high,
          imageFormatGroup: ImageFormatGroup.jpeg);
      await controller.initialize();
      return controller;
    } on CameraException catch (e) {
      print("Error initializing camera: $e");
    }
  }

  toggleCamera() async {
    int newSelected = (_selected + 1) % _cameras.length;
    _selected = newSelected;

    CameraController controller = await selectCamera(_selected);
    setState(() {
      _controller = controller;
    });
  }

  _showResult({required bool isFoodCamera, String? imagePath}) {
    return _isFoodCamera
        ? Navigator.push(
            context, MaterialPageRoute(builder: (context) => ShowFoodResult()))
        : showModalBottomSheet(
            context: context,
            elevation: 6,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            builder: (context) {
              return ShowBodyResult(imagePath: imagePath!);
            });
  }
}
