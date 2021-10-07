import 'package:foodandbody/models/menu.dart';
import 'package:foodandbody/models/menu_detail.dart';

abstract class IPlanRepository {
  Future<void> addPlanMenu(Menu menu, bool isEat);

  Future<void> getPlanById();

  Future<void> updatePlan(MenuDetail menuDetail, bool isEat);
}
