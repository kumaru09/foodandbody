import 'package:foodandbody/models/menu.dart';
import 'package:foodandbody/models/menu_show.dart';

abstract class IPlanRepository {
  Future<void> addPlanMenu(Menu menu, bool isEat);

  Future<void> getPlanById();

  Future<void> updatePlan(MenuShow menuDetail, bool isEat);
}
