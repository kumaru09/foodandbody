import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:foodandbody/models/body.dart';
import 'package:foodandbody/models/body_predict.dart';
import 'package:foodandbody/models/depth.dart';
import 'package:foodandbody/models/menu_show.dart';
import 'package:foodandbody/models/predict.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;

class PredictBodyFailure implements Exception {
  @override
  String toString() {
    return 'ไม่สามารถวัดได้ กรุณาถ่ายภาพใหม่อีกครั้ง';
  }
}

class CameraRepository {
  CameraRepository({FirebaseStorage? firebaseFirestore})
      : _firebaseStorage = firebaseFirestore ?? FirebaseStorage.instance;
  final dio = Dio();
  final FirebaseStorage _firebaseStorage;
  final CollectionReference predict =
      FirebaseFirestore.instance.collection('predict');

  Future<List<MenuShow>> getPredictFood(XFile file) async {
    try {
      final fromData =
          FormData.fromMap({'image': await MultipartFile.fromFile(file.path)});
      final response = await dio.post(
          'https://bnn-food-ai-api.azurewebsites.net/api/predict/',
          data: fromData);
      print(response.data);
      List<MenuShow> results = [];
      for (int i = 0; i < response.data.length; i++) {
        final res = await http.get(Uri.parse(
            "https://foodandbody-api.azurewebsites.net/api/Menu/${response.data[0]}"));
        if (res.statusCode == 200) {
          results.add(MenuShow.fromJson(json.decode(res.body)));
        }
      }
      print(results);
      return results;
    } catch (e) {
      print('$e');
      return List.empty();
    }
  }

  Future<String> uploadFoodPic(XFile xfile) async {
    try {
      final file = File(xfile.path);
      final ext = p.extension(file.path);
      final uploadTask = await _firebaseStorage
          .ref('predict/photo/${Timestamp.now().seconds}$ext')
          .putFile(file);
      final uri = await uploadTask.ref.getDownloadURL();
      return uri;
    } catch (e) {
      return "";
    }
  }

  Future<List<Predict>> getPredictionFoodWithDepth(
      XFile file, Depth depth) async {
    try {
      final url = await uploadFoodPic(file);
      print(url);
      final fromData = FormData.fromMap({
        "image": await MultipartFile.fromFile(file.path),
        "depth": depth.depth,
        "fovH": depth.fovH,
        "fovW": depth.fovW
      });
      final response = await dio.post(
        "http://kumaru.trueddns.com:50310/api/depth/",
        data: fromData,
      );
      if (response.statusCode == 200) {
        print("res: ${response.data}");
        final List<Predict> predictData = response.data['predict']
            .map<Predict>((e) => Predict.fromJson(e))
            .toList();
        if (predictData.isNotEmpty) {
          // List<Predict> results = [];
          List<Map> predictMap = predictData.map((e) => e.toJson()).toList();
          print(predictData);
          await predict.add(
              {"predict": predictMap, "photo": url, "date": Timestamp.now()});
          // for (var i in predictData) {
          //   final res = await http.get(Uri.parse(
          //       "https://foodandbody-api.azurewebsites.net/api/Menu/name?name=${i.name}"));
          //   if (res.statusCode == 200) {
          //     results.add(PredictResult(
          //         predict: i,
          //         menuShow: MenuShow.fromJson(json.decode(res.body))));
          //   }
          // }
          return predictData;
        }
      }
      return List.empty();
    } catch (e) {
      print(e);
      return List.empty();
    }
  }

  Future<BodyPredict?> getPredictBody(
      {required List<XFile> image, required int height}) async {
    try {
      final formData = FormData.fromMap({
        "front": await MultipartFile.fromFile(image[0].path),
        "side": await MultipartFile.fromFile(image[1].path),
        "height": height
      });
      final res = await dio.post("http://kumaru.trueddns.com:50311/measure",
          data: formData);
      if (res.statusCode == 200) {
        final List<BodyPredict> body = res.data["res"]
            .map<BodyPredict>((e) => BodyPredict.fromJson(e))
            .toList();
        if (body.isNotEmpty) {
          return body.first;
        } else {
          throw PredictBodyFailure();
        }
      }
      throw PredictBodyFailure();
    } catch (_) {
      print("getpredict: $_");
      throw PredictBodyFailure();
    }
  }
}
