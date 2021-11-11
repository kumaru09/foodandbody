import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:foodandbody/screens/help/help.dart';

part 'show_body_result.dart';

class Camera extends StatefulWidget {
  @override
  _CameraState createState() => _CameraState();
}

class _CameraState extends State<Camera> with WidgetsBindingObserver {
  List<CameraDescription> _cameras = [];
  CameraController? _controller;
  int _selected = 0;

  bool _isFoodCamera = true;
  // FlashMode? _currentFlashMode;

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
            onPressed: () {},
            icon: Icon(
              Icons.flash_on,
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
            showResult(
                context: context,
                isFoodCamera: _isFoodCamera,
                imagePath: image?.path);
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
        // _controller!.setFlashMode(FlashMode.off);
        // _currentFlashMode = _controller!.value.flashMode;
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

  showResult(
      {required BuildContext context,
      required bool isFoodCamera,
      String? imagePath}) {
    return showModalBottomSheet(
        context: context,
        elevation: 6,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(15))),
        builder: (context) {
          return Stack(clipBehavior: Clip.none, children: [
            isFoodCamera ? _foodResult(context) : _bodyResult(context),
            isFoodCamera
                ? Container()
                : Positioned(
                    bottom: MediaQuery.of(context).size.height * 0.41,
                    child: Container(
                      padding: EdgeInsets.only(left: 16, bottom: 23),
                      constraints:
                          BoxConstraints(maxHeight: 168, maxWidth: 168),
                      child: Card(
                        elevation: 6,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                            side: BorderSide(color: Colors.white, width: 3)),
                        child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            child: Image.file(File(imagePath!),
                                fit: BoxFit.cover)),
                      ),
                    ),
                  )
          ]);
        });
  }
}
