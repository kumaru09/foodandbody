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
  final History _plan;
  late List<Menu> planMenu =
      _plan.menuList.where((value) => value.timestamp == null).toList();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: planMenu.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return _buildPlanCard(context, planMenu[index]);
        });
  }

  Widget _buildPlanCard(BuildContext context, Menu item) {
    return InkWell(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => MenuPage.plan(menu: item)));
      },
      child: Card(
        elevation: 2,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: ListTile(
          contentPadding: EdgeInsets.fromLTRB(17, 10, 10, 10),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                constraints: BoxConstraints(minWidth: 70),
                alignment: Alignment.centerLeft,
                child: Text(
                  "${item.calories.round()}",
                  style: Theme.of(context).textTheme.headline5!.merge(
                        TextStyle(
                            color: Theme.of(context).colorScheme.secondary),
                      ),
                ),
              ),
              Expanded(
                  child: Padding(
                padding: EdgeInsets.only(left: 16),
                child: Text(
                  "${item.name}",
                  maxLines: 1,
                  softWrap: false,
                  overflow: TextOverflow.fade,
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.subtitle1!.merge(TextStyle(
                      color: Theme.of(context).colorScheme.secondary)),
                ),
              )),
            ],
          ),
          trailing: IconButton(
            icon: Icon(
              Icons.close,
              color: Theme.of(context).colorScheme.secondary,
            ),
            onPressed: () {
              context
                  .read<PlanBloc>()
                  .deleteMenu(item.name, item.volumn)
                  .then((value) => context.read<PlanBloc>().add(LoadPlan()));
            },
          ),
        ),
      ),
    );
  }
}
