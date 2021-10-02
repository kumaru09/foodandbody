import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:foodandbody/models/history.dart';
import 'package:foodandbody/models/history_entity.dart';
import 'package:foodandbody/models/menu.dart';
import 'package:foodandbody/models/menu_detail.dart';
import 'package:foodandbody/repositories/i_plan_repository.dart';
import 'package:http/http.dart' as http;

class PlanRepository implements IPlanRepository {
  final foodHistories = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser?.uid)
      .collection('foodhistories');
  final now = new DateTime.now();
  late final lastMidnight = DateTime(now.year, now.month, now.year);

  @override
  Future<void> addPlanMenu(Menu menu) async {
    final plan = await foodHistories
        .where('date', isGreaterThanOrEqualTo: lastMidnight)
        .get();
    List<dynamic> menuList = List.from(plan.docs.first.get('menuList'));
    menuList.add(Menu(
        timestamp: Timestamp.now(), name: menu.name, calories: menu.calories));
    if (plan.docs.isNotEmpty) {
      await plan.docs.first.reference.update({'menuList': menuList});
      final res = await http.get(Uri.parse(
          "https://foodandbody-api.azurewebsites.net/api/Menu/${menu.name}"));
      if (res.statusCode == 200) {
        updatePlan(MenuDetail.fromJson(json.decode(res.body)));
      } else {
        throw Exception('error fetching menu');
      }
    }
  }

  @override
  Future<History> getPlanById() async {
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

  Future<void> updatePlan(MenuDetail menuDetail) async {
    final plan = await foodHistories
        .where('date', isGreaterThanOrEqualTo: lastMidnight)
        .get();
    final data =
        History.fromEntity(HistoryEntity.fromSnapshot(plan.docs.first));
    if (plan.docs.isNotEmpty) {
      await plan.docs.first.reference.update({
        'totalCal': data.totalCal + menuDetail.calories,
        'totalNutrient': data.totalNutrientList.copyWith(
            protein: data.totalNutrientList.protein + menuDetail.protein,
            fat: data.totalNutrientList.fat + menuDetail.fat,
            carb: data.totalNutrientList.carb + menuDetail.carb),
      });
    }
  }
}
