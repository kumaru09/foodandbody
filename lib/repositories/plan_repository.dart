import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:foodandbody/models/history.dart';
import 'package:foodandbody/models/history_entity.dart';
import 'package:foodandbody/models/menu.dart';
import 'package:foodandbody/models/menu_show.dart';
import 'package:foodandbody/repositories/i_plan_repository.dart';
import 'package:http/http.dart' as http;

class PlanRepository implements IPlanRepository {
  final foodHistories = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser?.uid)
      .collection('foodhistories');
  final DateTime now = DateTime.now();
  late final DateTime lastMidnight = DateTime(now.year, now.month, now.day);

  @override
  Future<void> addPlanMenu(String name, double volumn, bool isEat) async {
    final res = await http.get(
        Uri.parse("https://foodandbody-api.azurewebsites.net/api/Menu/$name"));
    if (res.statusCode == 200) {
      final menu = MenuShow.fromJson(json.decode(res.body));
      final plan = await foodHistories
          .where('date', isGreaterThanOrEqualTo: lastMidnight)
          .get();
      if (plan.docs.isNotEmpty) {
        List<Menu> menuList = plan.docs.first
            .get('menuList')
            .map<Menu>((menu) => Menu.fromJson(menu))
            .toList();
        if (isEat) {
          menuList
              .where((menuList) =>
                  menuList.name == menu.name && menuList.timestamp == null)
              .first
              .timestamp = Timestamp.now();
        } else {
          menuList.add(Menu(
              name: menu.name,
              calories:
                  double.parse((menu.calory * volumn).toStringAsFixed(1))));
        }
        List<Map> menuListMap = menuList.map((e) => e.toJson()).toList();
        await plan.docs.first.reference.update({'menuList': menuListMap});
        await updatePlan(menu, volumn, isEat);
      }
    } else {
      throw Exception('error fetching menu');
    }
  }

  @override
  Future<History> getPlanById() async {
    log('Fetching data');
    final plan = await foodHistories
        .where('date', isGreaterThanOrEqualTo: lastMidnight)
        .get();
    if (plan.docs.isNotEmpty) {
      return History.fromEntity(HistoryEntity.fromSnapshot(plan.docs.first));
    } else {
      final history = History(Timestamp.now());
      foodHistories.add(history.toEntity().toJson());
      return history;
    }
  }

  Future<void> updatePlan(
      MenuShow menuDetail, double volumn, bool isEat) async {
    final plan = await foodHistories
        .where('date', isGreaterThanOrEqualTo: lastMidnight)
        .get();
    final data =
        History.fromEntity(HistoryEntity.fromSnapshot(plan.docs.first));
    if (plan.docs.isNotEmpty) {
      if (isEat) {
        await plan.docs.first.reference.update({
          'totalCal': data.totalCal +
              double.parse((menuDetail.calory * volumn).toStringAsFixed(1)),
          'totalNutrient': data.totalNutrientList
              .copyWith(
                  protein: data.totalNutrientList.protein +
                      double.parse(
                          (menuDetail.protein * volumn).toStringAsFixed(1)),
                  fat: data.totalNutrientList.fat +
                      double.parse(
                          (menuDetail.fat * volumn).toStringAsFixed(1)),
                  carb: data.totalNutrientList.carb +
                      double.parse(
                          (menuDetail.carb * volumn).toStringAsFixed(1)))
              .toJson(),
        });
      } else {
        await plan.docs.first.reference.update({
          'planNutrient': data.planNutrientList
              .copyWith(
                  protein: data.planNutrientList.protein +
                      double.parse(
                          (menuDetail.protein * volumn).toStringAsFixed(1)),
                  fat: data.planNutrientList.fat +
                      double.parse(
                          (menuDetail.fat * volumn).toStringAsFixed(1)),
                  carb: data.planNutrientList.carb +
                      double.parse(
                          (menuDetail.carb * volumn).toStringAsFixed(1)))
              .toJson()
        });
      }
      print('added menu in plan');
    }
  }

  Future<void> deletePlan(String name) async {
    final plan = await foodHistories
        .where('date', isGreaterThanOrEqualTo: lastMidnight)
        .get();
    if (plan.docs.isNotEmpty) {
      List<Menu> menuList = plan.docs.first
          .get('menuList')
          .map<Menu>((menu) => Menu.fromJson(menu))
          .toList();
      menuList
          .removeWhere((menu) => menu.name == name && menu.timestamp == null);
      List<Map> menuListMap = menuList.map((e) => e.toJson()).toList();
      await plan.docs.first.reference.update({'menuList': menuListMap});
      final res = await http.get(Uri.parse(
          "https://foodandbody-api.azurewebsites.net/api/Menu/$name"));
      if (res.statusCode == 200) {
        final menuDetail = MenuShow.fromJson(json.decode(res.body));
        final data =
            History.fromEntity(HistoryEntity.fromSnapshot(plan.docs.first));
        await plan.docs.first.reference.update({
          'planNutrient': data.planNutrientList
              .copyWith(
                  protein: data.planNutrientList.protein - menuDetail.protein,
                  fat: data.planNutrientList.fat - menuDetail.fat,
                  carb: data.planNutrientList.carb - menuDetail.carb)
              .toJson()
        });
      } else {
        throw Exception('error deleting menu');
      }
    }
  }
}
