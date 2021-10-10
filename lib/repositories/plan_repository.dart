import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:foodandbody/models/history.dart';
import 'package:foodandbody/models/history_entity.dart';
import 'package:foodandbody/models/menu.dart';
import 'package:foodandbody/models/menu_detail.dart';
import 'package:foodandbody/repositories/i_plan_repository.dart';
import 'package:http/http.dart' as http;

class PlanRepository implements IPlanRepository {
  final DateTime now = DateTime.now();
  late final DateTime lastMidnight = DateTime(now.year, now.month, now.day);

  @override
  Future<void> addPlanMenu(Menu menu, bool isEat) async {
    final CollectionReference foodHistories = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('foodhistories');
    final plan = await foodHistories
        .where('date', isGreaterThanOrEqualTo: lastMidnight)
        .get();
    if (plan.docs.isNotEmpty) {
      List<Menu> menuList = List.from(plan.docs.first.get('menuList'));
      if (isEat) {
        menuList
            .where((menuList) => menuList.name == menu.name)
            .first
            .timestamp = Timestamp.now();
      } else {
        menuList.add(Menu(name: menu.name, calories: menu.calories));
      }
      await plan.docs.first.reference.update({'menuList': menuList});
      final res = await http.get(Uri.parse(
          "https://foodandbody-api.azurewebsites.net/api/Menu/${menu.name}"));
      if (res.statusCode == 200) {
        updatePlan(MenuDetail.fromJson(json.decode(res.body)), isEat);
      } else {
        throw Exception('error fetching menu');
      }
    }
  }

  @override
  Future<History> getPlanById() async {
    log('Fetching data');
    final CollectionReference foodHistories = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('foodhistories');
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

  Future<void> updatePlan(MenuDetail menuDetail, bool isEat) async {
    final CollectionReference foodHistories = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('foodhistories');
    final plan = await foodHistories
        .where('date', isGreaterThanOrEqualTo: lastMidnight)
        .get();
    final data =
        History.fromEntity(HistoryEntity.fromSnapshot(plan.docs.first));
    if (plan.docs.isNotEmpty) {
      if (isEat) {
        await plan.docs.first.reference.update({
          'totalCal': data.totalCal + menuDetail.calories,
          'totalNutrient': data.totalNutrientList.copyWith(
              protein: data.totalNutrientList.protein + menuDetail.protein,
              fat: data.totalNutrientList.fat + menuDetail.fat,
              carb: data.totalNutrientList.carb + menuDetail.carb),
        });
      } else {
        await plan.docs.first.reference.update({
          'planNutrient': data.planNutrientList.copyWith(
              protein: data.planNutrientList.protein + menuDetail.protein,
              fat: data.planNutrientList.fat + menuDetail.fat,
              carb: data.planNutrientList.carb + menuDetail.carb)
        });
      }
    }
  }
}
