import 'package:foodandbody/models/menu.dart';
import 'package:foodandbody/models/menu_show.dart';

abstract class IPlanRepository {
  Future<void> addPlanMenu(
      String name, double oldVolumn, double volumn, bool isEat);

  Future<void> getPlanById();

  Future<void> updatePlan(MenuShow menuDetail, double volumn, bool isEat);

  Future<void> deletePlan(String name, double volume);
}
