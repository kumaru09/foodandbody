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
  Future<void> addPlanMenu(Menu menu, bool isEat) async {
    log(Timestamp.fromDate(DateTime(now.year, now.month, now.day)).toString());
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
            .where((menuList) => menuList.name == menu.name)
            .first
            .timestamp = Timestamp.now();
      } else {
        menuList.add(Menu(name: menu.name, calories: menu.calories));
      }
      List<Map> menuListMap = menuList.map((e) => e.toJson()).toList();
      await plan.docs.first.reference
          .update({'menuList': FieldValue.arrayUnion(menuListMap)});
      final res = await http.get(Uri.parse(
          "https://foodandbody-api.azurewebsites.net/api/Menu/${menu.name}"));
      if (res.statusCode == 200) {
        updatePlan(MenuShow.fromJson(json.decode(res.body)), isEat);
      } else {
        throw Exception('error fetching menu');
      }
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

  Future<void> updatePlan(MenuShow menuDetail, bool isEat) async {
    final plan = await foodHistories
        .where('date', isGreaterThanOrEqualTo: lastMidnight)
        .get();
    final data =
        History.fromEntity(HistoryEntity.fromSnapshot(plan.docs.first));
    if (plan.docs.isNotEmpty) {
      if (isEat) {
        await plan.docs.first.reference.update({
          'totalCal': data.totalCal + menuDetail.calory,
          'totalNutrient': data.totalNutrientList
              .copyWith(
                  protein: data.totalNutrientList.protein + menuDetail.protein,
                  fat: data.totalNutrientList.fat + menuDetail.fat,
                  carb: data.totalNutrientList.carb + menuDetail.carb)
              .toJson(),
        });
      } else {
        await plan.docs.first.reference.update({
          'planNutrient': data.planNutrientList
              .copyWith(
                  protein: data.planNutrientList.protein + menuDetail.protein,
                  fat: data.planNutrientList.fat + menuDetail.fat,
                  carb: data.planNutrientList.carb + menuDetail.carb)
              .toJson()
        });
      }
      print('added menu in plan');
    }
  }
}
