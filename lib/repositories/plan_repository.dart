import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:foodandbody/models/exercise_entity.dart';
import 'package:foodandbody/models/exercise_repo.dart';
import 'package:foodandbody/models/history.dart';
import 'package:foodandbody/models/history_entity.dart';
import 'package:foodandbody/models/menu.dart';
import 'package:foodandbody/models/menu_show.dart';
import 'package:foodandbody/models/predict.dart';
import 'package:foodandbody/repositories/i_plan_repository.dart';
import 'package:http/http.dart' as http;

class PlanRepository implements IPlanRepository {
  PlanRepository({
    FirebaseFirestore? firebaseFirestore,
    FirebaseAuth? firebaseAuth,
    http.Client? httpClient,
  })  : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance,
        _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        this.httpClient = httpClient ?? http.Client();

  final FirebaseFirestore _firebaseFirestore;
  final FirebaseAuth _firebaseAuth;
  final http.Client httpClient;

  final DateTime now = DateTime.now();
  late final DateTime lastMidnight = DateTime(now.year, now.month, now.day);

  @override
  Future<void> addPlanMenu(
      String name, double? oldVolumn, double volumn, bool isEat) async {
    final res = await httpClient.get(
        Uri.parse("https://foodandbody-api.azurewebsites.net/api/Menu/$name"));
    if (res.statusCode == 200) {
      final menu = MenuShow.fromJson(json.decode(res.body));
      final CollectionReference foodHistories = _firebaseFirestore
          .collection('users')
          .doc(_firebaseAuth.currentUser?.uid)
          .collection('foodhistories');
      final plan =
          await foodHistories.orderBy('date', descending: true).limit(1).get();
      if (plan.docs.isNotEmpty) {
        List<Menu> menuList = plan.docs.first
            .get('menuList')
            .map<Menu>((menu) => Menu.fromJson(menu))
            .toList();
        if (isEat) {
          final menuSelect = menuList.where((menuList) =>
              menuList.name == menu.name && menuList.timestamp == null);
          if (menuSelect.isNotEmpty) {
            final menuOne =
                menuSelect.where((element) => element.volumn == oldVolumn);
            if (menuOne.isNotEmpty) {
              if (menuOne.first.volumn != volumn) {
                menuList.remove(menuOne.first);
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
                        menuList.name == menu.name &&
                        menuList.timestamp == null &&
                        menuList.volumn == oldVolumn)
                    .first
                    .timestamp = Timestamp.now();
              }
            }
          } else {
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

  Future<void> addPlanCamera(Predict predict) async {
    final CollectionReference foodHistories = _firebaseFirestore
        .collection('users')
        .doc(_firebaseAuth.currentUser?.uid)
        .collection('foodhistories');
    final plan =
        await foodHistories.orderBy('date', descending: true).limit(1).get();
    if (plan.docs.isNotEmpty) {
      List<Menu> menuList = plan.docs.first
          .get('menuList')
          .map<Menu>((menu) => Menu.fromJson(menu))
          .toList();
      menuList.add(Menu(
          name: predict.name,
          calories: predict.calory,
          serve: 1,
          protein: predict.protein,
          fat: predict.fat,
          carb: predict.carb,
          volumn: 1,
          timestamp: Timestamp.now()));
      List<Map> menuListMap = menuList.map((e) => e.toJson()).toList();
      await plan.docs.first.reference.update({'menuList': menuListMap});
      await updatePlanCamera(predict);
    } else {
      throw Exception();
    }
  }

  Future<void> updatePlanCamera(Predict predict) async {
    final CollectionReference foodHistories = _firebaseFirestore
        .collection('users')
        .doc(_firebaseAuth.currentUser?.uid)
        .collection('foodhistories');
    final plan =
        await foodHistories.orderBy('date', descending: true).limit(1).get();
    if (plan.docs.isNotEmpty) {
      final data =
          History.fromEntity(HistoryEntity.fromSnapshot(plan.docs.first));
      await plan.docs.first.reference.update({
        'totalCal': data.totalCal + predict.calory,
        'totalNutrient': data.totalNutrientList
            .copyWith(
              protein: data.totalNutrientList.protein + predict.protein,
              fat: data.totalNutrientList.fat + predict.fat,
              carb: data.totalNutrientList.carb + predict.carb,
            )
            .toJson(),
      });
    } else {
      throw Exception();
    }
  }

  @override
  Future<History> getPlanById() async {
    log('Fetching data');
    final CollectionReference foodHistories = _firebaseFirestore
        .collection('users')
        .doc(_firebaseAuth.currentUser?.uid)
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
    final CollectionReference foodHistories = _firebaseFirestore
        .collection('users')
        .doc(_firebaseAuth.currentUser?.uid)
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

  Future<void> deletePlan(String name, double volume) async {
    final CollectionReference foodHistories = _firebaseFirestore
        .collection('users')
        .doc(_firebaseAuth.currentUser?.uid)
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
          .where((menu) =>
              menu.name == name &&
              menu.timestamp == null &&
              menu.volumn == volume)
          .first);
      List<Map> menuListMap = menuList.map((e) => e.toJson()).toList();
      await plan.docs.first.reference.update({'menuList': menuListMap});
    }
  }

  Future<void> addWaterPlan(int water) async {
    final CollectionReference foodHistories = _firebaseFirestore
        .collection('users')
        .doc(_firebaseAuth.currentUser?.uid)
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
    final CollectionReference foodHistories = _firebaseFirestore
        .collection('users')
        .doc(_firebaseAuth.currentUser?.uid)
        .collection('foodhistories');
    final plan = await foodHistories
        .where('date', isGreaterThanOrEqualTo: lastMidnight)
        .get();
    if (plan.docs.isNotEmpty) {
      return plan.docs.first.get('totalWater');
    } else {
      return 0;
    }
  }

  Future<void> addExercise(ExerciseRepo exercise) async {
    final CollectionReference foodHistories = _firebaseFirestore
        .collection('users')
        .doc(_firebaseAuth.currentUser?.uid)
        .collection('foodhistories');
    final plan = await foodHistories
        .where('date', isGreaterThanOrEqualTo: lastMidnight)
        .get();
    if (plan.docs.isNotEmpty) {
      List<ExerciseRepo> exerciseList = await plan.docs.first
          .get('exerciseList')
          .map<ExerciseRepo>((exercise) => ExerciseRepo.fromJson(exercise))
          .toList();
      exerciseList.add(exercise);
      List<Map> exerciseMap = exerciseList.map((e) => e.toJson()).toList();
      await plan.docs.first.reference.update({
        'exerciseList': exerciseMap,
        'totalBurn': double.parse(
            (plan.docs.first.get('totalBurn') + exercise.calory)
                .toStringAsFixed(1))
      });
    } else {
      throw Exception('error adding exerciseList');
    }
  }

  Future<List<ExerciseRepo>> getExercise() async {
    final CollectionReference foodhistories = _firebaseFirestore
        .collection('users')
        .doc(_firebaseAuth.currentUser?.uid)
        .collection('foodhistories');
    final plan =
        await foodhistories.orderBy('date', descending: true).limit(1).get();
    if (plan.docs.isNotEmpty) {
      List<ExerciseRepo> exerciseList = plan.docs.first
          .get('exerciseList')
          .map<ExerciseRepo>((e) => ExerciseRepo.fromJson(e))
          .toList();
      return exerciseList;
    } else {
      return List.empty();
    }
  }

  Future<void> deleteExercise(ExerciseRepo exercise) async {
    final CollectionReference foodhistories = _firebaseFirestore
        .collection('users')
        .doc(_firebaseAuth.currentUser?.uid)
        .collection('foodhistories');
    final plan =
        await foodhistories.orderBy('date', descending: true).limit(1).get();
    if (plan.docs.isNotEmpty) {
      final List<ExerciseRepo> exerciseList = plan.docs.first
          .get('exerciseList')
          .map<ExerciseRepo>((e) => ExerciseRepo.fromJson(e))
          .toList();
      exerciseList.removeWhere((element) =>
          element.id == exercise.id && element.timestamp == exercise.timestamp);
      List<Map> exerciseMap = exerciseList.map((e) => e.toJson()).toList();
      await plan.docs.first.reference.update({
        'exerciseList': exerciseMap,
        'totalBurn': plan.docs.first.get('totalBurn') - exercise.calory
      });
    } else {
      throw Exception('error deleting exercise');
    }
  }
}

extension on double {
  double toFixStringOneDot(double volumn, double serve) =>
      (double.parse(((this * volumn) / serve).toStringAsFixed(1)));
}
