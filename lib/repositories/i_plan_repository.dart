import 'package:foodandbody/models/menu.dart';

abstract class IPlanRepository {
  Future<void> addPlanMenu(Menu menu);

  Future<void> getPlanById();
}
