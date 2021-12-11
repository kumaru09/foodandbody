import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:dio/dio.dart';
import 'package:foodandbody/models/menu_show.dart';
import 'package:http/http.dart' as http;

class CameraRepository {
  final dio = Dio();

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
}
