import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:foodandbody/screens/camera/bloc/camera_bloc.dart';
import 'package:foodandbody/screens/camera/camera.dart';
import 'package:foodandbody/screens/camera/show_food_result.dart';
import 'package:foodandbody/screens/camera/show_predict_result.dart';
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
  bool _isFoodCamera = true;

  void onPlatformViewCreated(int id) async {
    print('onPlatform');
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
    context.read<CameraBloc>().add(SetIsFlat(isFlat: 120));
    context.read<CameraBloc>().add(SetHasPlane(hasPlane: false));
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
      if (inclination < 1 || inclination > 179) {
        if (context.read<CameraBloc>().state.isFlat > inclination) {
          context.read<CameraBloc>().add(SetIsFlat(isFlat: inclination));
        }
      } else {
        if (inclination < 10 || inclination > 170) {
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // print(accelerometer);
    // final deviceRatio =
    //     MediaQuery.of(context).size.width / MediaQuery.of(context).size.height;
    // return Container();
    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.black,
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
              Navigator.of(context).pushReplacement(
                  (MaterialPageRoute(builder: (context) => Camera())));
            },
            icon: Icon(
              Icons.accessibility,
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
                        state.isFlat > 1 &&
                        state.isFlat < 179) {
                      return Text('Device is not flat: ${state.isFlat}');
                    } else {
                      return Text('Ready for take photo');
                    }
                  })))
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
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
              Navigator.of(context).pushReplacement((MaterialPageRoute(
                  builder: (context) => ShowPredictResult())));
            }
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
}
