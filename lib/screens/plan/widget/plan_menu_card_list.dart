import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodandbody/models/history.dart';
import 'package:foodandbody/models/menu.dart';
import 'package:foodandbody/screens/menu/menu.dart';
import 'package:foodandbody/screens/plan/bloc/plan_bloc.dart';

class PlanMenuCardList extends StatefulWidget {
  const PlanMenuCardList(this._plan);

  final History _plan;

  @override
  _PlanMenuCardListState createState() => _PlanMenuCardListState(_plan);
}

class _PlanMenuCardListState extends State<PlanMenuCardList> {
  _PlanMenuCardListState(this._plan);
  GlobalKey<AnimatedListState> animatedListKey = GlobalKey();
  final History _plan;
  late List<Menu> planMenu =
      _plan.menuList.where((value) => value.timestamp == null).toList();

  @override
  Widget build(BuildContext context) {
    return AnimatedList(
      key: animatedListKey,
      initialItemCount: planMenu.length,
      shrinkWrap: true,
      itemBuilder: (context, index, animation) {
        return _buildPlanCard(context, planMenu[index], animation);
      },
    );
  }

  Widget _buildPlanCard(
      BuildContext context, Menu item, Animation<double> animation) {
    return SizeTransition(
        sizeFactor: animation,
        child: InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          MenuPage(menuName: item.name, isPlanMenu: true)));
            },
            child: Card(
              color: Colors.white,
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: ListTile(
                contentPadding: EdgeInsets.fromLTRB(17, 10, 10, 10),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                        flex: 3,
                        child: Text("${item.calories.round()}",
                            style: Theme.of(context)
                                .textTheme
                                .headline5!
                                .merge(TextStyle(color: Color(0xFF515070))))),
                    Expanded(
                        flex: 7,
                        child: Text("${item.name}",
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1!
                                .merge(TextStyle(color: Color(0xFF515070)))))
                  ],
                ),
                trailing: IconButton(
                  icon: Icon(
                    Icons.close,
                    color: Color(0xFF515070),
                  ),
                  onPressed: () {
                    int removeIndex = planMenu.indexOf(item);
                    Menu removedItem = planMenu.removeAt(removeIndex);
                    context
                        .read<PlanBloc>()
                        .deleteMenu(item.name)
                        .then((_) => context.read<PlanBloc>().add(LoadPlan()));
                    AnimatedListRemovedItemBuilder builder =
                        (context, animation) {
                      return _buildPlanCard(context, removedItem, animation);
                    };

                    animatedListKey.currentState
                        ?.removeItem(removeIndex, builder);
                  },
                ),
              ),
            )));
  }
}
