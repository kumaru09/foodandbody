import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:foodandbody/models/depth.dart';
import 'package:path_provider/path_provider.dart';

enum ARStatus { initial, support, notsupport, notinstall, needcamera }

class ARCoreService {
  MethodChannel channel = const MethodChannel('ar.core.platform');
  ARStatus isSupportDepth = ARStatus.initial;
  String errorMessage = '';

  Future<void> isARCoreSupported() async {
    try {
      final res = await channel.invokeMethod<String>('isARCoreSupported');
      if (res == "notInstall") {
        isSupportDepth = ARStatus.notinstall;
        errorMessage =
            'กรุณาติดตั้ง Google Play Services for AR แล้วลองอีกครั้ง';
      } else if (res == "support")
        isSupportDepth = ARStatus.support;
      else if (res == "needCamera") {
        isSupportDepth = ARStatus.needcamera;
        errorMessage = 'กรุณาอณุญาตการใช้งานกล้องให้กับแอปพลิเคขันก่อนใช้งาน';
      } else {
        isSupportDepth = ARStatus.notsupport;
        errorMessage = 'อุปกรณ์ของคุณไม่รองรับกล้องประมาณแคลอรี';
      }
    } catch (_) {
      print('isARCoreSupported error: $_');
      throw Exception();
    }
  }

  Future<Depth?> getDepth() async {
    try {
      channel = const MethodChannel('ar.core.platform/depth');
      final data = await channel.invokeMethod<String>('getDepth');
      final res = json.decode(data!);
      final depth = Depth.fromJson(res);
      if (depth.depth.isNotEmpty) {
        print(depth.depth);
        print(depth.fovW);
        print(depth.fovH);
        final path = await getExternalStorageDirectory();
        final file = File("${path!.path}/depth.txt");
        await file.writeAsString('${depth.depth}');
        return depth;
      }
      throw Exception('error getting depth');
    } catch (e) {
      print('getDepth error: $e');
      throw Exception();
    }
  }

  Future<XFile?> takePicture() async {
    try {
      final path = await channel.invokeMethod<String>('takePicture');
      if (path != null) return XFile(path);
      throw Exception('error taking picture');
    } catch (e) {
      print('takePicture error: $e');
      throw Exception();
    }
  }
}
