import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:foodandbody/models/depth.dart';
import 'package:path_provider/path_provider.dart';

class ARCoreService {
  MethodChannel channel = const MethodChannel('ar.core.platform');

  Future<bool?> isARCoreSupported() async {
    return await channel.invokeMethod<bool>('isARCoreSupported');
  }

  Future<bool?> createSession() async {
    try {
      channel = const MethodChannel('ar.core.platform/depth');
      return await channel.invokeMethod<bool>('trackingPlane');
    } catch (e) {
      print('createSession error: $e');
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
    }
  }

  Future<XFile?> takePicture() async {
    try {
      final path = await channel.invokeMethod<String>('takePicture');
      if (path != null) return XFile(path);
      throw Exception('error taking picture');
    } catch (e) {
      print('takePicture error: $e');
    }
  }
}
