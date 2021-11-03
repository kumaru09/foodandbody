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
  final DateTime now = DateTime.now();
  late final DateTime lastMidnight = DateTime(now.year, now.month, now.day);

  @override
  Future<void> addPlanMenu(String name, double volumn, bool isEat) async {
    final res = await http.get(
        Uri.parse("https://foodandbody-api.azurewebsites.net/api/Menu/$name"));
    if (res.statusCode == 200) {
      final menu = MenuShow.fromJson(json.decode(res.body));
      final CollectionReference foodHistories = FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .collection('foodhistories');
      final plan = await foodHistories
          .where('date', isGreaterThanOrEqualTo: lastMidnight)
          .get();
      if (plan.docs.isNotEmpty) {
        List<Menu> menuList = plan.docs.first
            .get('menuList')
            .map<Menu>((menu) => Menu.fromJson(menu))
            .toList();
        if (isEat) {
          final menuSelect = menuList
              .where((menuList) =>
                  menuList.name == menu.name && menuList.timestamp == null)
              .first;
          if (menuSelect.volumn != volumn) {
            menuList.remove(menuSelect);
            menuList.add(Menu(
                name: menu.name,
                calories: menu.calory
                    .toDouble()
                    .toFixStringOneDot(volumn, menu.serve),
                serve: menu.serve,
                protein: menu.protein.toFixStringOneDot(volumn, menu.serve),
                fat: menu.fat.toFixStringOneDot(volumn, menu.serve),
                carb: menu.carb.toFixStringOneDot(volumn, menu.serve),
                volumn: volumn,
                timestamp: Timestamp.now()));
          } else {
            menuList
                .where((menuList) =>
                    menuList.name == menu.name && menuList.timestamp == null)
                .first
                .timestamp = Timestamp.now();
          }
          await updatePlan(menu, volumn, isEat);
        } else {
          menuList.add(Menu(
            name: menu.name,
            calories:
                menu.calory.toDouble().toFixStringOneDot(volumn, menu.serve),
            serve: menu.serve,
            protein: menu.protein.toFixStringOneDot(volumn, menu.serve),
            fat: menu.fat.toFixStringOneDot(volumn, menu.serve),
            carb: menu.carb.toFixStringOneDot(volumn, menu.serve),
            volumn: volumn,
          ));
        }
        List<Map> menuListMap = menuList.map((e) => e.toJson()).toList();
        await plan.docs.first.reference.update({'menuList': menuListMap});
      }
    } else {
      throw Exception('error fetching menu');
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

  Future<void> updatePlan(
      MenuShow menuDetail, double volumn, bool isEat) async {
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
          'totalCal': data.totalCal +
              menuDetail.calory
                  .toDouble()
                  .toFixStringOneDot(volumn, menuDetail.serve),
          'totalNutrient': data.totalNutrientList
              .copyWith(
                protein: data.totalNutrientList.protein +
                    menuDetail.protein
                        .toFixStringOneDot(volumn, menuDetail.serve),
                fat: data.totalNutrientList.fat +
                    menuDetail.fat.toFixStringOneDot(volumn, menuDetail.serve),
                carb: data.totalNutrientList.carb +
                    menuDetail.carb.toFixStringOneDot(volumn, menuDetail.serve),
              )
              .toJson(),
        });
      }
      print('added menu in plan');
    }
  }

  Future<void> deletePlan(String name) async {
    final CollectionReference foodHistories = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('foodhistories');
    final plan = await foodHistories
        .where('date', isGreaterThanOrEqualTo: lastMidnight)
        .get();
    if (plan.docs.isNotEmpty) {
      List<Menu> menuList = plan.docs.first
          .get('menuList')
          .map<Menu>((menu) => Menu.fromJson(menu))
          .toList();
      menuList.remove(menuList
          .where((menu) => menu.name == name && menu.timestamp == null)
          .first);
      List<Map> menuListMap = menuList.map((e) => e.toJson()).toList();
      await plan.docs.first.reference.update({'menuList': menuListMap});
    }
  }

  Future<void> addWaterPlan(int water) async {
    final CollectionReference foodHistories = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('foodhistories');
    final plan = await foodHistories
        .where('date', isGreaterThanOrEqualTo: lastMidnight)
        .get();
    if (plan.docs.isNotEmpty) {
      return plan.docs.first.reference.update({'totalWater': water});
    } else {
      throw Exception('error fetching data');
    }
  }

  Future<int> getWaterPlan() async {
    final CollectionReference foodHistories = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('foodhistories');
    final plan = await foodHistories
        .where('date', isGreaterThanOrEqualTo: lastMidnight)
        .get();
    if (plan.docs.isNotEmpty) {
      return plan.docs.first.get('totalWater');
    } else {
      throw Exception('error fetching water');
    }
  }
}

extension on double {
  double toFixStringOneDot(double volumn, double serve) =>
      (double.parse(((this * volumn) / serve).toStringAsFixed(1)));
}
