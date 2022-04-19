import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:foodandbody/screens/camera/bloc/camera_bloc.dart';
import 'package:foodandbody/screens/camera/camera.dart';
import 'package:foodandbody/screens/camera/camera_dialog.dart';
import 'package:foodandbody/screens/camera/show_food_result.dart';
import 'package:foodandbody/screens/camera/show_predict_result.dart';
import 'package:foodandbody/screens/help/help.dart';
import 'package:foodandbody/services/arcore_service.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/src/provider.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  void onPlatformViewCreated(int id) async {
    print('onPlatform');
    _streamSubscription
        .add(_trackingStream.receiveBroadcastStream().listen((event) {
      final res = json.decode(event);
      bool hasPlane = res["hasPlane"];
      int count = res["count"];
      if (hasPlane &&
          !context.read<CameraBloc>().state.hasPlane &&
          count > 1000) {
        context.read<CameraBloc>().add(SetHasPlane(hasPlane: true));
      } else if (!hasPlane &&
          context.read<CameraBloc>().state.hasPlane &&
          count < 1000) {
        context.read<CameraBloc>().add(SetHasPlane(hasPlane: false));
      }
    }));
  }

  @override
  void initState() {
    super.initState();
    _showDialog();
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
      if (inclination < 2 || inclination > 178) {
        if (context.read<CameraBloc>().state.isFlat > inclination &&
            context.read<CameraBloc>().state.hasPlane) {
          context.read<CameraBloc>().add(SetIsFlat(isFlat: inclination));
        }
      } else {
        if (inclination < 10 || inclination > 170) {
          if (context.read<CameraBloc>().state.hasPlane)
            context.read<CameraBloc>().add(SetIsFlat(isFlat: inclination));
        }
      }
    }));
  }

  void _showDialog() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      bool? isFoodDialogChecked = prefs.getBool('isFoodDialogChecked');
      if (isFoodDialogChecked == null) {
        final value = await showDialog<bool>(
            context: context, builder: (BuildContext context) => FoodDialog());
        if (value!) prefs.setBool('isFoodDialogChecked', true);
      }
    } catch (_) {}
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
    return LoaderOverlay(
        disableBackButton: false,
        child: Scaffold(
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
            alignment: Alignment.center,
            children: <Widget>[
              visibilityDetector,
              Positioned.fill(
                  bottom: MediaQuery.of(context).size.height * 0.12,
                  child: Align(
                      alignment: Alignment.bottomCenter,
                      child: FittedBox(
                          fit: BoxFit.fill,
                          child: Container(
                            padding: EdgeInsets.only(left: 16, right: 16),
                            height: 32,
                            child: Center(child:
                                BlocBuilder<CameraBloc, CameraState>(
                                    builder: (context, state) {
                              if (!state.hasPlane) {
                                return Text(
                                  'กรุณาขยับกล้องขึ้นลงให้จุดสีเขียวขึ้นบนอาหาร',
                                  style: TextStyle(
                                      color: Color(0xFFFFFFFF), fontSize: 12),
                                );
                              }
                              if (state.hasPlane &&
                                  state.isFlat > 2 &&
                                  state.isFlat < 178) {
                                return Text(
                                  'กรุณาขยับกล้องให้ขนานกับพื้น: ${state.isFlat}',
                                  style: TextStyle(
                                      color: Color(0xFFFFFFFF), fontSize: 12),
                                );
                              } else {
                                return Text(
                                  'พร้อมสำหรับถ่ายรูป',
                                  style: TextStyle(
                                      color: Color(0xFFFFFFFF), fontSize: 12),
                                );
                              }
                            })),
                            decoration: BoxDecoration(
                                color: const Color(0xff232F34),
                                borderRadius: BorderRadius.circular(10)),
                          ))))
            ],
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              try {
                final depth = await widget.arCoreService.getDepth();
                final image = await widget.arCoreService.takePicture();
                if (image != null && depth != null) {
                  context
                      .read<CameraBloc>()
                      .add(GetPredictonWithDepth(file: image, depth: depth));
                  Navigator.of(context).pushReplacement((MaterialPageRoute(
                      builder: (context) => ShowFoodResult())));
                } else {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(SnackBar(
                      content: Text('ถ่ายไม่สำเร็จ กรุณาลองใหม่อีกครั้ง'),
                    ));
                }
              } catch (e) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(SnackBar(
                    content: Text('ถ่ายไม่สำเร็จ กรุณาลองใหม่อีกครั้ง'),
                  ));
              }
            },
            elevation: 2,
            backgroundColor: Colors.white,
            shape: CircleBorder(
                side:
                    BorderSide(width: 6, color: Colors.grey.withOpacity(0.5))),
          ),
        ));
  }
}
