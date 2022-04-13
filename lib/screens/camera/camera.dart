import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodandbody/repositories/camera_repository.dart';
import 'package:foodandbody/screens/camera/bloc/camera_bloc.dart';
import 'package:foodandbody/screens/help/help.dart';
import 'package:foodandbody/screens/camera/show_body_result.dart';
import 'package:foodandbody/screens/camera/show_food_result.dart';

class Camera extends StatefulWidget {
  @override
  _CameraState createState() => _CameraState();
}

class _CameraState extends State<Camera> with WidgetsBindingObserver {
  List<CameraDescription> _cameras = [];
  CameraController? _controller;
  int _selected = 0;

  bool _isFoodCamera = true;
  bool _isFlashModeOff = true;
  FlashMode? _currentFlashMode;

  @override
  void initState() {
    super.initState();
    setupCamera();
    WidgetsBinding.instance?.addObserver(this);
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
    final deviceRatio =
        MediaQuery.of(context).size.width / MediaQuery.of(context).size.height;
    final CameraController? cameraController = _controller;

    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
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
              setState(() {
                _isFoodCamera = !_isFoodCamera;
              });
            },
            icon: Icon(
              _isFoodCamera ? Icons.fastfood : Icons.accessibility,
              color: Colors.white,
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                if (_currentFlashMode == FlashMode.auto) {
                  _controller!.setFlashMode(FlashMode.off);
                } else if (_currentFlashMode == FlashMode.off) {
                  _controller!.setFlashMode(FlashMode.auto);
                }
                _currentFlashMode = _controller!.value.flashMode;
                _isFlashModeOff = !_isFlashModeOff;
              });
            },
            icon: Icon(
              _isFlashModeOff ? Icons.flash_off : Icons.flash_on,
              color: Colors.white,
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Help()));
            },
            icon: Icon(
              Icons.help_outline,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: (cameraController == null || !cameraController.value.isInitialized)
          ? Center(child: CircularProgressIndicator())
          : Transform.scale(
              scale: cameraController.value.aspectRatio / deviceRatio,
              child: Center(
                child: AspectRatio(
                  aspectRatio: cameraController.value.aspectRatio,
                  child: CameraPreview(cameraController),
                ),
              ),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            final image = await cameraController?.takePicture();
            // context.read<CameraBloc>().add(GetPredicton(file: image!));
            _showResult(isFoodCamera: _isFoodCamera, image: image!);
          } catch (e) {
            print("Take a photo failed: $e");
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
      CameraController controller = await selectCamera();
      setState(() {
        _controller = controller;
        _controller!.setFlashMode(FlashMode.off);
        _currentFlashMode = _controller!.value.flashMode;
        _isFlashModeOff = _currentFlashMode == FlashMode.off;
        // print("controller: ${_controller!.value.flashMode}");
        // print("mode: $_currentFlashMode");
      });
    } on CameraException catch (e) {
      print("error in fetching the camera: $e");
    }
  }

  selectCamera() async {
    try {
      CameraController controller =
          CameraController(_cameras[_selected], ResolutionPreset.high);
      await controller.initialize();
      return controller;
    } on CameraException catch (e) {
      print("Error initializing camera: $e");
    }
  }

  toggleCamera() async {
    int newSelected = (_selected + 1) % _cameras.length;
    _selected = newSelected;

    CameraController controller = await selectCamera();
    setState(() {
      _controller = controller;
    });
  }

  _showResult({required bool isFoodCamera, required XFile image}) {
    return _isFoodCamera
        ? Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => BlocProvider<CameraBloc>(
                    create: (_) => CameraBloc(
                        cameraRepository: context.read<CameraRepository>())
                      ..add(GetPredicton(file: image)),
                    child: const ShowFoodResult())))
        : showModalBottomSheet(
            context: context,
            elevation: 6,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            builder: (context) {
              return ShowBodyResult(imagePath: image.path);
            });
  }
}
