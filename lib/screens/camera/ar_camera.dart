import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:foodandbody/screens/camera/bloc/camera_bloc.dart';
import 'package:foodandbody/screens/camera/show_food_result.dart';
import 'package:foodandbody/screens/help/help.dart';
import 'package:foodandbody/services/arcore_service.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/src/provider.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:visibility_detector/visibility_detector.dart';

class ARCamera extends StatefulWidget {
  const ARCamera({required this.arCoreService, Key? key}) : super(key: key);
  final ARCoreService arCoreService;
  @override
  _State createState() => _State();
}

class _State extends State<ARCamera> with WidgetsBindingObserver {
  late VisibilityDetector visibilityDetector;
  final _streamSubscription = <StreamSubscription<dynamic>>[];
  final _trackingStream = const EventChannel("ar.core.platform/tracking");
  bool? hasPlane = false;

  void onPlatformViewCreated(int id) async {
    print('onPlatform');
    // hasPlane = await widget.arCoreService.createSession();
    // context.read<CameraBloc>().add(SetHasPlane(hasPlane: hasPlane!));
    _streamSubscription
        .add(_trackingStream.receiveBroadcastStream().listen((event) {
      if (event && !context.read<CameraBloc>().state.hasPlane) {
        context.read<CameraBloc>().add(SetHasPlane(hasPlane: true));
      } else if (!event && context.read<CameraBloc>().state.hasPlane) {
        context.read<CameraBloc>().add(SetHasPlane(hasPlane: false));
      }
    }));
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    if (defaultTargetPlatform == TargetPlatform.android) {
      visibilityDetector = VisibilityDetector(
          key: Key('visible-camera-key'),
          child: AndroidView(
            viewType: 'ar.core.platform',
            creationParamsCodec: StandardMessageCodec(),
            onPlatformViewCreated: onPlatformViewCreated,
          ),
          onVisibilityChanged: (visibilityInfo) {
            if (visibilityInfo.visibleFraction == 0) {}
          });
    }
    _streamSubscription.add(accelerometerEvents.listen((event) {
      final norm = sqrt(pow(event.x, 2) + pow(event.y, 2) + pow(event.z, 2));
      final inclination = (acos(event.z / norm) * (180 / pi)).round();
      // print(inclination);
      if (inclination < 2 || inclination > 178) {
        if (context.read<CameraBloc>().state.isFlat > inclination) {
          context.read<CameraBloc>().add(SetIsFlat(isFlat: inclination));
        }
      } else {
        if (context.read<CameraBloc>().state.isFlat < inclination) {
          context.read<CameraBloc>().add(SetIsFlat(isFlat: inclination));
        }
        if (inclination == 5 || inclination == 175) {
          context.read<CameraBloc>().add(SetIsFlat(isFlat: inclination));
        }
        if (inclination == 10 || inclination == 170) {
          context.read<CameraBloc>().add(SetIsFlat(isFlat: inclination));
        }
      }
    }));
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    _streamSubscription.forEach((subscription) {
      subscription.cancel();
    });
    print('dispose');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // print(accelerometer);
    // final deviceRatio =
    //     MediaQuery.of(context).size.width / MediaQuery.of(context).size.height;
    // return Container();
    return LoaderOverlay(
        child: Scaffold(
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
          // IconButton(
          //   onPressed: () {
          //     setState(() {
          //       _isFoodCamera = !_isFoodCamera;
          //     });
          //   },
          //   icon: Icon(
          //     _isFoodCamera ? Icons.fastfood : Icons.accessibility,
          //     color: Colors.white,
          //   ),
          // ),
          IconButton(
            onPressed: () {
              // setState(() {
              //   if (_currentFlashMode == FlashMode.auto) {
              //     _controller!.setFlashMode(FlashMode.off);
              //   } else if (_currentFlashMode == FlashMode.off) {
              //     _controller!.setFlashMode(FlashMode.auto);
              //   }
              //   _currentFlashMode = _controller!.value.flashMode;
              //   _isFlashModeOff = !_isFlashModeOff;
              // });
            },
            icon: Icon(
              Icons.flash_off,
              // _isFlashModeOff ? Icons.flash_off : Icons.flash_on,
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
      body: Stack(
        children: <Widget>[
          visibilityDetector,
          Positioned.fill(
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: BlocBuilder<CameraBloc, CameraState>(
                      builder: (context, state) {
                    if (!state.hasPlane) {
                      return Text('Searching Surface');
                    }
                    if (state.hasPlane &&
                        state.isFlat > 2 &&
                        state.isFlat < 178) {
                      return Text('Device is not flat: ${state.isFlat}');
                    } else {
                      return Text('Ready for take photo');
                    }
                  })))
        ],
      ),
      // body: (cameraController == null || !cameraController.value.isInitialized)
      //     ? Center(child: CircularProgressIndicator())
      //     : Transform.scale(
      //         scale: cameraController.value.aspectRatio / deviceRatio,
      //         child: Center(
      //           child: AspectRatio(
      //             aspectRatio: cameraController.value.aspectRatio,
      //             child: CameraPreview(cameraController),
      //           ),
      //         ),
      //       ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            // context.loaderOverlay.show();
            final depth = await widget.arCoreService.getDepth();
            final image = await widget.arCoreService.takePicture();
            if (image != null && depth != null) {
              print(image.path);
              // final img = File(image.path);
              // final decode = await decodeImageFromList(img.readAsBytesSync());
              // print("${decode.width}, ${decode.height}");
              context
                  .read<CameraBloc>()
                  .add(GetPredictonWithDepth(file: image, depth: depth));
              Navigator.of(context).pushReplacement(
                  (MaterialPageRoute(builder: (context) => ShowFoodResult())));
            }
            // final image = await cameraController?.takePicture();
            // _showResult(isFoodCamera: _isFoodCamera, imagePath: image.path);
            // await widget.arCoreService.getDepth();
            // Navigator.of(context).pop(image);
          } catch (e) {
            print("Take a photo failed: $e");
          }
        },
        elevation: 2,
        backgroundColor: Colors.white,
        shape: CircleBorder(
            side: BorderSide(width: 6, color: Colors.grey.withOpacity(0.5))),
      ),
    ));
  }
}
