import 'dart:async';

import 'package:camera/camera.dart';
import 'package:foodandbody/models/body_predict.dart';
import 'package:foodandbody/repositories/user_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodandbody/repositories/camera_repository.dart';
import 'package:foodandbody/screens/camera/ar_camera.dart';
import 'package:foodandbody/screens/camera/bloc/camera_bloc.dart';
import 'package:foodandbody/screens/camera/show_body_result.dart';
import 'package:foodandbody/screens/camera/show_food_result.dart';
import 'package:foodandbody/services/arcore_service.dart';
import 'package:loader_overlay/loader_overlay.dart';

class Camera extends StatefulWidget {
  @override
  _CameraState createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  @override
  void initState() {
    super.initState();
    _initializeCamera(_selectedCamera);
    _audioPlayer = AudioPlayer();
    print('init end');
  }

  late List<CameraDescription> _cameras;
  late CameraController _controller;
  Future<void>? _initializeControllerFuture;
  late AudioPlayer _audioPlayer;
  Timer? _counterTimer;
  Duration _duration = Duration(seconds: 5);
  int _selectedCamera = 1;
  bool _isBodyCamera = true;
  List<XFile> _bodyImage = [];
  bool _isTakeImage = false;

  Future<void> _initializeCamera(int _selectedCamera) async {
    try {
      _cameras = await availableCameras();
      setState(() {
        _controller = CameraController(
            _cameras[_selectedCamera], ResolutionPreset.high,
            imageFormatGroup: ImageFormatGroup.jpeg);
        _initializeControllerFuture = _controller.initialize();
      });
    } on CameraException catch (e) {
      print("Error initializing camera: $e");
    } catch (_) {
      print("error");
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _audioPlayer.dispose();
    if (_counterTimer == null) {
      _counterTimer!.cancel();
    }

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

  void _startTimer() {
    _counterTimer =
        Timer.periodic(Duration(seconds: 1), (timer) => _setCountDown());
  }

  void _setCountDown() {
    const int _reduceSeconds = 1;
    setState(() {
      final seconds = _duration.inSeconds - _reduceSeconds;
      if (seconds < 0) {
        _counterTimer!.cancel();
      } else {
        _duration = Duration(seconds: seconds);
      }
    });
  }

  void _resetTimer() {
    setState(() {
      _counterTimer!.cancel();
      _duration = Duration(seconds: 5);
    });
  }

  @override
  Widget build(BuildContext context) {
    String _digit(int n) => n.toString().padLeft(1);
    final _seconds = _digit(_duration.inSeconds.remainder(60));

    return BlocListener<CameraBloc, CameraState>(
        listener: ((context, state) {
          if (state.status == CameraStatus.success) {
            _bodyImage.clear();
            context.loaderOverlay.hide();
            if (state.results != null) _showResult(state.results!);
          } else if (state.status == CameraStatus.failure) {
            _bodyImage.clear();
            context.loaderOverlay.hide();
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(
                content: Text('เกิดข้อผิดพลาด กรุณาลองใหม่อีกครั้ง'),
              ));
          }
        }),
        child: LoaderOverlay(
            disableBackButton: false,
            child: Scaffold(
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
                      context.loaderOverlay.show();
                      if (context.read<ARCoreService>().isSupportDepth ==
                          ARStatus.initial)
                        await context.read<ARCoreService>().isARCoreSupported();
                      if (context.read<ARCoreService>().isSupportDepth ==
                          ARStatus.support) {
                        Future.delayed(Duration(seconds: 1), () {
                          context.loaderOverlay.hide();
                          Navigator.of(context).pushReplacement(
                              (MaterialPageRoute(
                                  builder: (context) => ARCamera(
                                      arCoreService:
                                          context.read<ARCoreService>()))));
                        });
                        setState(() => _isBodyCamera = !_isBodyCamera);
                      } else {
                        context.loaderOverlay.hide();
                        ScaffoldMessenger.of(context)
                          ..hideCurrentSnackBar()
                          ..showSnackBar(SnackBar(
                            content: Text(
                                '${context.read<ARCoreService>().errorMessage}'),
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
              body: Stack(
                alignment: Alignment.center,
                children: [
                  FutureBuilder<void>(
                    future: _initializeControllerFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return _controller.buildPreview();
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                  _isBodyCamera
                      ? Container(
                          margin: EdgeInsets.fromLTRB(
                              20,
                              MediaQuery.of(context).size.height * 0.05,
                              20,
                              20),
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: MediaQuery.of(context).size.height * 0.7,
                          decoration: BoxDecoration(
                            border: Border.all(
                                width: 5,
                                color: Theme.of(context).primaryColor),
                          ),
                        )
                      : Container(),
                  _isBodyCamera
                      ? Text(
                          "$_seconds",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 100,
                              fontWeight: FontWeight.bold),
                        )
                      : Container(),
                  AnimatedOpacity(
                    opacity: _isTakeImage ? 1.0 : 0.0,
                    duration: Duration(milliseconds: 500),
                    child: Container(
                      color: Colors.white,
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                    ),
                  )
                ],
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
              floatingActionButton: FloatingActionButton(
                onPressed: () async {
                  if (_isBodyCamera) {
                    await _playSignal();
                    _startTimer();
                    await _takeBodyPhoto();
                    context.loaderOverlay.show();
                    context.read<CameraBloc>().add(GetBodyPredict(
                        image: _bodyImage,
                        height: context
                            .read<UserRepository>()
                            .cache
                            .get()!
                            .height!));
                  }
                },
                elevation: 2,
                backgroundColor: Colors.white,
                shape: CircleBorder(
                    side: BorderSide(
                        width: 6, color: Colors.grey.withOpacity(0.5))),
              ),
            )));
  }

  // void _takeFoodPhoto() async {
  //   try {
  //     final image = await _controller.takePicture();
  //     context.read<CameraBloc>().add(GetPredicton(file: image));
  //     _showResult(isBodyCamera: _isBodyCamera);
  //   } catch (e) {
  //     print("Take a photo failed: $e");
  //   }
  // }

  Future<void> _takeBodyPhoto() async {
    XFile _image;
    try {
      await Future.delayed(Duration(seconds: 5), () async {
        _image = await _controller.takePicture();
        _bodyImage.add(_image);
        setState(() => _isTakeImage = true);
        await _playSignal();
        setState(() => _isTakeImage = false);
      });
      _resetTimer();

      _startTimer();
      await Future.delayed(Duration(seconds: 5), () async {
        _image = await _controller.takePicture();
        _bodyImage.add(_image);
        setState(() => _isTakeImage = true);
        await _playSignal();
        setState(() => _isTakeImage = false);
      });
      _resetTimer();
    } catch (e) {
      print("Take a photo failed: $e");
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(
          content: Text('ถ่ายรูปไม่สำเร็จ กรุณาลองใหม่อีกครั้ง'),
        ));
    }
  }

  _showResult(BodyPredict bodyPredict) {
    return showModalBottomSheet(
        context: context,
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        builder: (context) {
          return ShowBodyResult(results: bodyPredict);
        });
  }

  _playSignal() async {
    await _audioPlayer.setAsset('assets/beep-sound.mp3');
    _audioPlayer.play();
  }
}
